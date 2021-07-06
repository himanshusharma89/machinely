/// Copyright (c) 2021 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to
/// deal in the Software without restriction, including without limitation the
/// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
/// sell copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge,
/// publish, distribute, sublicense, create a derivative work, and/or sell
/// copies of the Software in any work that is designed, intended, or marketed
/// for pedagogical or instructional purposes related to programming, coding,
/// application development, or information technology.  Permission for such
/// use, copying, modification, merger, publication, distribution, sublicensing,
/// creation of derivative works, or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
/// IN THE SOFTWARE.

import 'dart:isolate';
import 'dart:math' as math;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../classifiers/object_classifier/object_classifier.dart';
import '../helpers/camera_view_singleton.dart';
import '../helpers/isolate_data.dart';
import '../helpers/recognition.dart';
import '../helpers/stats.dart';
import '../main.dart';
import '../utils/isolate_utils.dart';
import 'card_view_widget.dart';

/// [CameraView] sends each frame for inference
class CameraView extends StatefulWidget {
  /// Callback to pass results after inference to [RealtimeDetectionView]
  final Function(List<Recognition> recognitions) resultsCallback;

  /// Callback to inference stats to [RealtimeDetectionView]
  final Function(Stats stats) statsCallback;

  /// Constructor
  const CameraView(this.resultsCallback, this.statsCallback, {Key? key})
      : super(key: key);
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  /// Controller
  CameraController? cameraController;

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

  /// Initializes the camera by setting [cameraController]
  void initializeCamera() async {
    // cameras[0] for rear-camera
    cameraController =
        CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

    cameraController!.initialize().then((_) async {
      // Stream of image passed to [onLatestImageAvailable] callback
      await cameraController!.startImageStream(onLatestImageAvailable);

      /// previewSize is size of each image frame captured by controller
      final previewSize = cameraController!.value.previewSize!;

      /// previewSize is size of raw input image to the model
      CameraViewSingleton.inputImageSize = previewSize;

      // the display width of image on screen is
      // same as screenWidth while maintaining the aspectRatio
      final screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = screenSize.width / previewSize.height;
    });
  }

  /// Callback to receive each frame [CameraImage] perform inference on it
  void onLatestImageAvailable(CameraImage cameraImage) async {
    if (classifier.interpreter != null && classifier.labels != null) {
      // If previous inference has not completed then return
      if (predicting) {
        return;
      }

      if (mounted) {
        setState(() {
          predicting = true;
        });
      }

      final uiThreadTimeStart = DateTime.now().millisecondsSinceEpoch;

      // Data to be passed to inference isolate
      final isolateData = IsolateData(
          cameraImage, classifier.interpreter!.address, classifier.labels);

      // You could have simply used the compute method as well however
      // it would be as in-efficient as you need to continuously pass data
      // to another isolate.

      /// perform inference in separate isolate
      final inferenceResults = await (inference(isolateData));

      final uiThreadInferenceElapsedTime =
          DateTime.now().millisecondsSinceEpoch - uiThreadTimeStart;

      // pass results to HomeView
      widget.resultsCallback(inferenceResults['recognitions']);

      // pass stats to HomeView
      widget.statsCallback((inferenceResults['stats'] as Stats)
        ..totalElapsedTime = uiThreadInferenceElapsedTime);

      if (mounted) {
        // set predicting to false to allow new frames
        setState(() {
          predicting = false;
        });
      }
    }
  }

  /// Runs inference in another isolate
  Future<Map<String, dynamic>> inference(IsolateData isolateData) async {
    final responsePort = ReceivePort();
    isolateUtils.sendPort!
        .send(isolateData..responsePort = responsePort.sendPort);
    final results = await responsePort.first;
    return results;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.paused:
        cameraController!.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (cameraController!.value.isInitialized) {
          if (!cameraController!.value.isStreamingImages) {
            await cameraController!.startImageStream(onLatestImageAvailable);
          }
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return empty container while the camera is not initialized
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const CardView(
        child: Text('No camera to preview'),
      );
    }
    var tmp = MediaQuery.of(context).size;
    final screenH = math.max(tmp.height, tmp.width);
    final screenW = math.min(tmp.height, tmp.width);
    tmp = cameraController!.value.previewSize!;
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
            cameraController!,
          ),
        ),
      ),
    );
  }
}
