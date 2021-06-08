import 'dart:math';

import 'package:flutter/cupertino.dart';
import '../../widget/camera_view_singleton.dart';

/// Represents the recognition output from the model
class Recognition {
  /// Index of the result
  final int _id;

  /// Label of the result
  final String _label;

  /// Confidence [0.0, 1.0]
  final double _score;

  /// Location of bounding box rect
  ///
  /// The rectangle corresponds to the raw input image
  /// passed for inference
  final Rect? _location;

  /// Constructor
  Recognition(this._id, this._label, this._score, [this._location]);

  int get id => _id;

  String get label => _label;

  double get score => _score;

  Rect? get location => _location;

  /// Returns bounding box rectangle corresponding to the
  /// displayed image on screen
  ///
  /// This is the actual location where rectangle is rendered on
  /// the screen
  Rect get renderLocation {
    // ratioX = screenWidth / imageInputWidth
    // ratioY = ratioX if image fits screenWidth with aspectRatio = constant

    final ratioX = CameraViewSingleton.ratio;
    final ratioY = ratioX;

    final transLeft = max(0.1, location!.left * ratioX);
    final transTop = max(0.1, location!.top * ratioY);
    final transWidth = min(
        location!.width * ratioX, CameraViewSingleton.actualPreviewSize.width);
    final transHeight = min(location!.height * ratioY,
        CameraViewSingleton.actualPreviewSize.height);

    final transformedRect =
        Rect.fromLTWH(transLeft, transTop, transWidth, transHeight);
    return transformedRect;
  }

  @override
  String toString() {
    return '''Recognition(id: $id, label: $label, score: $score, location: $location)''';
  }
}
