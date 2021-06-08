import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../classifiers/image_classifier/image_classifier.dart';
import '../classifiers/image_classifier/image_classifier_float.dart';
import '../widget/card_view_widget.dart';

class StatiImagePredictionView extends StatefulWidget {
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

  Future getImagefromCamera() async {
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

  Future getImagefromGallery() async {
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
              onPressed: getImagefromCamera,
              heroTag: 'camera',
              child: const Icon(Icons.add_a_photo),
            ),
            FloatingActionButton(
              onPressed: getImagefromGallery,
              heroTag: 'gallery',
              child: const Icon(Icons.photo),
            )
          ],
        )
      ],
    );
  }
}
