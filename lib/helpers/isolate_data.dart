import 'dart:isolate';

import 'package:camera/camera.dart';

/// Bundles data to pass between Isolate
class IsolateData {
  /// Image data
  CameraImage cameraImage;

  /// Address to create interpreter
  int interpreterAddress;

  /// Labels data
  List<String>? labels;

  /// Send respone to ReceivePort
  late SendPort responsePort;

  /// Constructor
  IsolateData(
    this.cameraImage,
    this.interpreterAddress,
    this.labels,
  );
}
