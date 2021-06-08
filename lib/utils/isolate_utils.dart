import 'dart:io';
import 'dart:isolate';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../classifiers/object_classifier/object_classifier.dart';
import 'image_utils.dart';

/// Manages separate Isolate instance for inference
class IsolateUtils {
  static const String debugName = 'InferenceIsolate';

  Isolate? _isolate;
  ReceivePort _receivePort = ReceivePort();
  SendPort? _sendPort;

  SendPort? get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(
      entryPoint,
      _receivePort.sendPort,
      debugName: debugName,
    );

    _sendPort = await (_receivePort.first);
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final IsolateData isolateData in port) {
      final classifier = ObjectClassifier(
          interpreter:
              Interpreter.fromAddress(isolateData.interpreterAddress),
          labels: isolateData.labels);
      var image =
          ImageUtils.convertCameraImage(isolateData.cameraImage);
      if (Platform.isAndroid) {
        image = image_lib.copyRotate(image!, 90);
      }
      final results = classifier.predict(image);
      isolateData.responsePort.send(results);
    }
  }
}

/// Bundles data to pass between Isolate
class IsolateData {
  CameraImage cameraImage;
  int interpreterAddress;
  List<String>? labels;
  late SendPort responsePort;

  /// Constructor
  IsolateData(
    this.cameraImage,
    this.interpreterAddress,
    this.labels,
  );
}
