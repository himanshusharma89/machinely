import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'card_view_widget.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({required this.imagePickFn, Key? key})
      : super(key: key);
  final void Function(File pickedImage) imagePickFn;

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  Future getImagefromCamera() async {
    try {
      final image = ImagePicker();
      await image
          .getImage(source: ImageSource.camera)
          .then((value) => _image = File(value!.path));
      setState(() {
        widget.imagePickFn(_image!);
      });
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
      setState(() {
        widget.imagePickFn(_image!);
      });
    } catch (err) {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
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
