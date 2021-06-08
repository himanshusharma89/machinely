import 'dart:math';

import 'package:image/image.dart' as imageLib;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'recognition.dart';
import 'stats.dart';

/// ObjectClassifier
class ObjectClassifier {
  /// Instance of Interpreter
  Interpreter? _interpreter;

  /// Labels file loaded as list
  List<String>? _labels;

  static const String MODEL_FILE_NAME = 'detect.tflite';
  static const String LABEL_FILE_NAME = 'labelmap.txt';

  /// Input size of image (height = width = 300)
  static const int INPUT_SIZE = 300;

  /// Result score threshold
  static const double THRESHOLD = 0.5;

  /// [ImageProcessor] used to pre-process the image
  ImageProcessor? imageProcessor;

  /// Padding the image to transform into square
  late int padSize;

  /// Shapes of output tensors
  late List<List<int>> _outputShapes;

  /// Types of output tensors
  late List<TfLiteType> _outputTypes;

  /// Number of results to show
  static const int NUM_RESULTS = 10;

  ObjectClassifier() {
    loadModel();
    loadLabels();
  }

  /// Loads interpreter from asset
  void loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        MODEL_FILE_NAME,
        options: InterpreterOptions()..threads = 4,
      );

      final outputTensors = _interpreter!.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
    } catch (e) {
      print('Error while creating interpreter: $e');
    }
  }

  /// Loads labels from assets
  void loadLabels() async {
    try {
      _labels = await FileUtil.loadLabels('assets/$LABEL_FILE_NAME');
    } catch (e) {
      print('Error while loading labels: $e');
    }
  }

  /// Pre-process the image
  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize, padSize))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
          .build();
    }
    inputImage = imageProcessor!.process(inputImage);
    return inputImage;
  }

  /// Runs object detection on the input image
  Map<String, dynamic>? predict(imageLib.Image? image) {
    final predictStartTime = DateTime.now().millisecondsSinceEpoch;

    if (_interpreter == null) {
      print('Interpreter not initialized');
      return null;
    }

    final preProcessStart = DateTime.now().millisecondsSinceEpoch;

    // Create TensorImage from image
    var inputImage = TensorImage.fromImage(image!);

    // Pre-process TensorImage
    inputImage = getProcessedImage(inputImage);

    final preProcessElapsedTime =
        DateTime.now().millisecondsSinceEpoch - preProcessStart;

    // TensorBuffers for output tensors
    final TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
    final TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
    final TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
    final TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);

    // Inputs object for runForMultipleInputs
    // Use [TensorImage.buffer] or [TensorBuffer.buffer] to pass by reference
    final inputs = <Object>[inputImage.buffer];

    // Outputs map
    final outputs = <int, Object>{
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };

    final inferenceTimeStart = DateTime.now().millisecondsSinceEpoch;

    // run inference
    _interpreter!.runForMultipleInputs(inputs, outputs);

    final inferenceTimeElapsed =
        DateTime.now().millisecondsSinceEpoch - inferenceTimeStart;

    // Maximum number of results to show
    final resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    // Using labelOffset = 1 as ??? at index 0
    final labelOffset = 1;

    // Using bounding box utils for easy conversion
    //of tensorbuffer to List<Rect>
    final locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    final recognitions = <Recognition>[];

    for (var i = 0; i < resultsCount; i++) {
      // Prediction score
      final score = outputScores.getDoubleValue(i);

      // Label string
      final labelIndex = outputClasses.getIntValue(i) + labelOffset;
      final label = _labels!.elementAt(labelIndex);

      if (score > THRESHOLD) {
        // inverse of rect
        // [locations] corresponds to the image size 300 X 300
        // inverseTransformRect transforms it our [inputImage]
        final transformedRect = imageProcessor!
            .inverseTransformRect(locations[i], image.height, image.width);

        recognitions.add(
          Recognition(i, label, score, transformedRect),
        );
      }
    }

    final predictElapsedTime =
        DateTime.now().millisecondsSinceEpoch - predictStartTime;

    return <String, dynamic>{
      'recognitions': recognitions,
      'stats': Stats(
          totalPredictTime: predictElapsedTime,
          inferenceTime: inferenceTimeElapsed,
          preProcessingTime: preProcessElapsedTime)
    };
  }

  /// Gets the interpreter instance
  Interpreter? get interpreter => _interpreter;

  /// Gets the loaded labels
  List<String>? get labels => _labels;
}
