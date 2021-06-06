import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'image_classifier.dart';

class ImageClassifierQuant extends ImageClassifier {
  ImageClassifierQuant({int numThreads = 1}) : super(numThreads: numThreads);

  @override
  String get modelName => 'mobilenet_v1_1.0_224_quant.tflite';

  @override
  NormalizeOp get preProcessNormalizeOp => NormalizeOp(0, 1);

  @override
  NormalizeOp get postProcessNormalizeOp => NormalizeOp(0, 255);
}
