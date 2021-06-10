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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../classifiers/image_classifier/image_classifier.dart';
import '../classifiers/image_classifier/image_classifier_float.dart';
import '../widget/card_view_widget.dart';

/// Widget showcasing Image Prediction
class StatiImagePredictionView extends StatefulWidget {
  /// Constructor
  const StatiImagePredictionView({Key? key}) : super(key: key);

  @override
  _StatiImagePredictionViewState createState() =>
      _StatiImagePredictionViewState();
}

class _StatiImagePredictionViewState extends State<StatiImagePredictionView> {
  File? _image;
  late ImageClassifier _classifier;
  Category? category;

  @override
  void initState() {
    super.initState();
    _classifier = ImageClassifierFloat();
  }

  Future getImageFromCamera() async {
    try {
      final image = ImagePicker();
      await image
          .getImage(source: ImageSource.camera)
          .then((value) => _image = File(value!.path));
      setState(() {});
    } catch (err) {
      print('No Image Selected');
    }
  }

  Future getImageFromGallery() async {
    try {
      final image = ImagePicker();
      await image
          .getImage(source: ImageSource.gallery)
          .then((value) => _image = File(value!.path));
      setState(() {});
    } catch (err) {
      print('No Image Selected');
    }
  }

  void _predict() async {
    final imageInput = img.decodeImage(_image!.readAsBytesSync())!;
    final pred = _classifier.predict(imageInput);

    setState(() {
      category = pred;
    });
    print(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Static Image Prediction')),
      body: Column(
        children: [
          Flexible(flex: 7, fit: FlexFit.tight, child: imagePicker()),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 3,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: _predict,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Predict'),
                      )),
                  predictionResult()
                ]),
          )
        ],
      ),
    );
  }

  Widget predictionResult() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category != null ? category!.label : '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            category != null
                ? 'Confidence: ${category!.score.toStringAsFixed(3)}'
                : '',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget imagePicker() {
    return Column(
      children: <Widget>[
        Expanded(
          child: CardView(
            child: _image != null
                ? Image.file(_image!)
                : const Text('No Image is picked'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: getImageFromCamera,
              heroTag: 'camera',
              child: const Icon(Icons.add_a_photo),
            ),
            FloatingActionButton(
              onPressed: getImageFromGallery,
              heroTag: 'gallery',
              child: const Icon(Icons.photo),
            )
          ],
        )
      ],
    );
  }
}
