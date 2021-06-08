import 'dart:ui';

/// Singleton to record size related data
class CameraViewSingleton {
  /// Aspect Ratio of data
  static late double ratio;

  /// Screen size
  static late Size screenSize;

  /// Input image size
  static Size? inputImageSize;

  /// Actual size of image preview
  static Size get actualPreviewSize =>
      Size(screenSize.width, screenSize.width * ratio);
}
