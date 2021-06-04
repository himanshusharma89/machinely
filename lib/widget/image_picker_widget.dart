import 'package:flutter/material.dart';
import 'card_view_widget.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Expanded(
          child: CardView(
            child: Text('No Image is picked'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {},
              heroTag: 'camera',
              child: const Icon(Icons.add_a_photo),
            ),
            FloatingActionButton(
              onPressed: () {},
              heroTag: 'gallery',
              child: const Icon(Icons.photo),
            )
          ],
        )
      ],
    );
  }
}
