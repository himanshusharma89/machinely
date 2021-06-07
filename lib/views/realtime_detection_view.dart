import 'package:flutter/material.dart';
import 'package:machinely/classifiers/object_classifier/recognition.dart';
import 'package:machinely/classifiers/object_classifier/stats.dart';

import '../models_list.dart';
import '../widget/camera_screen_widget.dart';

class RealtimeDetectionView extends StatefulWidget {
  const RealtimeDetectionView({Key? key}) : super(key: key);

  @override
  _RealtimeDetectionViewState createState() => _RealtimeDetectionViewState();
}

class _RealtimeDetectionViewState extends State<RealtimeDetectionView> {
  /// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Stats? stats;

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    setState(() {
      this.results = results;
    });
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    setState(() {
      this.stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Detection'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 8,
              child: CameraScreenWidget(
                resultsCallback: resultsCallback,
                statsCallback: statsCallback,
              )),
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
