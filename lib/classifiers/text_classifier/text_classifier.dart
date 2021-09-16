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

import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Text Classifier
class TextClassifier {
  // name of the model and label file
  final _modelFile = 'text_classification.tflite';
  final _labelFile = 'labels.txt';

  // Maximum length of sentence
  final int _sentenceLength = 256;

  /// Starting Label
  final String start = '<START>';

  /// Empty Space Label
  final String pad = '<PAD>';

  /// Unkown Word Label
  final String unknown = '<UNKNOWN>';

  late Map<String, int> _dictionary;

  // TensorFlow Lite Interpreter object
  late Interpreter _interpreter;

  /// Constructor
  TextClassifier() {
    // Load model & disctinoary when the classifier is initialized.
    _loadModel();
    _loadDictionary();
  }

  /// Load the model
  void _loadModel() async {
    // Creating the interpreter using Interpreter.fromAsset
    _interpreter = await Interpreter.fromAsset(_modelFile);
    print('Interpreter loaded successfully');
  }

  /// Load the pre-defined labels
  void _loadDictionary() async {
    final labels = await rootBundle.loadString('assets/$_labelFile');
    final dict = <String, int>{};
    final labelsList = labels.split('\n');
    for (var i = 0; i < labelsList.length; i++) {
      final entry = labelsList[i].trim().split(' ');
      dict[entry[0]] = int.parse(entry[1]);
    }
    _dictionary = dict;
    print('Dictionary loaded successfully');
  }

  /// Classify the text
  List<double> classify(String rawText) {
    // Tokenize the raw text and return List<List<double>>
    // of shape [1, 256].
    final input = tokenizeInputText(rawText);

    // Generate output of shape [1,2].
    final output = List<double>.filled(2, 0).reshape<double>([1, 2]);

    // Run inference and
    // store the resulting values in output.
    _interpreter.run(input, output);

    return [output[0][0] as double, output[0][1] as double];
  }

  /// Tokenize the text to convert it into a list of word
  List<List<double>> tokenizeInputText(String text) {
    // Whitespace tokenization of the text
    final tokens = text.split(' ');

    // List of _sentenceLength filled with the value <pad>(0)
    final vector =
        List<double>.filled(_sentenceLength, _dictionary[pad]!.toDouble());

    // Check whether the _dictionary conatains the start
    // If so, place the value in the vector list
    var index = 0;
    if (_dictionary.containsKey(start)) {
      vector[index++] = _dictionary[start]!.toDouble();
    }

    // For each word in the input, find corresponding index in _dictionary
    for (final token in tokens) {
      if (index > _sentenceLength) {
        break;
      }
      vector[index++] = _dictionary.containsKey(token)
          ? _dictionary[token]!.toDouble()
          : _dictionary[unknown]!.toDouble();
    }

    // returning List<List<double>>
    // as the interpreter input expects the shape [1,256]
    return [vector];
  }
}
