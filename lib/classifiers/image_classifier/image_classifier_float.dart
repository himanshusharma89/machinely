import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'image_classifier.dart';

/// Classifier for floating point models
class ImageClassifierFloat extends ImageClassifier {
  /// Constructor
  ImageClassifierFloat({int? numThreads}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(127.5, 127.5);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 1);
}
