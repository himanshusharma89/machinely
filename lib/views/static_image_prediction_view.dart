import 'package:flutter/material.dart';
import '../models_list.dart';
import '../widget/image_picker_widget.dart';

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
          const Flexible(
              flex: 7, fit: FlexFit.tight, child: ImagePickerWidget()),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 3,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: models
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: OutlinedButton(
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(models[models.indexOf(e)]),
                          )),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
