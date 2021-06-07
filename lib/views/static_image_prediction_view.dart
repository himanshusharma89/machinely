import 'package:flutter/material.dart';
import '../widget/card_view_widget.dart';

class StatiImagePredictionView extends StatefulWidget {
  const StatiImagePredictionView({Key? key}) : super(key: key);

  @override
  _StatiImagePredictionViewState createState() =>
      _StatiImagePredictionViewState();
}

class _StatiImagePredictionViewState extends State<StatiImagePredictionView> {
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
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('Predict'),
                      )),
                ],
              ))
        ],
      ),
    );
  }

  Widget imagePicker() {
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
