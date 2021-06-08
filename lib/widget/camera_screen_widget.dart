import 'dart:isolate';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../classifiers/object_classifier/object_classifier.dart';
import '../classifiers/object_classifier/recognition.dart';
import '../classifiers/object_classifier/stats.dart';
import '../main.dart';
import '../utils/isolate_utils.dart';
import 'camera_view_singleton.dart';
import 'card_view_widget.dart';

class CameraScreenWidget extends StatefulWidget {
  const CameraScreenWidget(
      {required this.resultsCallback, required this.statsCallback, Key? key})
      : super(key: key);

  /// Callback to pass results after inference to [HomeView]
  final Function(List<Recognition> recognitions) resultsCallback;

  /// Callback to inference stats to [HomeView]
  final Function(Stats stats) statsCallback;
  @override
  _CameraScreenWidgetState createState() => _CameraScreenWidgetState();
}

class _CameraScreenWidgetState extends State<CameraScreenWidget>
    with WidgetsBindingObserver {
  late CameraController controller;

  /// true when inference is ongoing
  late bool predicting;

  /// Instance of [Classifier]
  late ObjectClassifier classifier;

  /// Instance of [IsolateUtils]
  late IsolateUtils isolateUtils;

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    WidgetsBinding.instance!.addObserver(this);

    // Spawn a new isolate
    isolateUtils = IsolateUtils();
    await isolateUtils.start();

    // Camera initialization
    initializeCamera();

    // Create an instance of classifier to load model and labels
    classifier = ObjectClassifier();

    // Initially predicting = false
    predicting = false;
  }

  void initializeCamera() async {
    // cameras[0] for rear-camera
    controller =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    controller.initialize().then((_) async {
      // Stream of image passed to [onLatestImageAvailable] callback
      await controller.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      ///
      /// 352x288 on iOS, 240p (320x240) on Android with ResolutionPreset.low
      final previewSize = controller.value.previewSize;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      final screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = screenSize.width / previewSize!.height;
    });
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (classifier.interpreter != null && classifier.labels != null) {
      // If previous inference has not completed then return
      if (predicting) {
        return;
      }

      setState(() {
        predicting = true;
      });

      final uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

      // Data to be passed to inference isolate
      final isolateData = IsolateData(
          cameraImage, classifier.interpreter!.address, classifier.labels);

      // We could have simply used the compute method as well however
      // it would be as in-efficient as we need to continuously passing data
      // to another isolate.

      /// perform inference in separate isolate
      final inferenceResults = await inference(isolateData);

      final uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

      // pass results to HomeView
      widget.resultsCallback(
          inferenceResults['recognitions'] as List<Recognition>);

      // pass stats to HomeView
      widget.statsCallback((inferenceResults['stats'] as Stats)
        ..totalElapsedTime = uiThreadInferenceElapsedTime);

      // set predicting to false to allow new frames
      setState(() {
        predicting = false;
      });
    }
  }

  /// Runs inference in another isolate
  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    final responsePort = ReceivePort();
    isolateUtils.sendPort!
        .send(isolateData..responsePort = responsePort.sendPort);
    final results = await responsePort.first as Map<String, dynamic>;
    return results;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        controller.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!controller.value.isStreamingImages) {
          await controller.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return const CardView(child: Text('No Camera to Preview'));
    }

    var tmp = MediaQuery.of(context).size;
    final screenH = math.max(tmp.height, tmp.width);
    final screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize!;
    final previewH = math.max(tmp.height, tmp.width);
    final previewW = math.min(tmp.height, tmp.width);
    final screenRatio = screenH / screenW;
    final previewRatio = previewH / previewW;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: OverflowBox(
          maxHeight: screenRatio > previewRatio
              ? screenH
              : screenW / previewW * previewH,
          maxWidth: screenRatio > previewRatio
              ? screenH / previewH * previewW
              : screenW,
          child: CameraPreview(
            controller,
          ),
        ),
      ),
    );
  }
}
