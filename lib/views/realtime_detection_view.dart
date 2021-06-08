import 'package:flutter/material.dart';
import '../classifiers/object_classifier/recognition.dart';
import '../classifiers/object_classifier/stats.dart';
import '../widget/box_widget.dart';
import '../widget/camera_view_singleton.dart';
import '../widget/stats_row.dart';

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
              flex: 9,
              child: Stack(
                children: [
                  CameraScreenWidget(
                    resultsCallback: resultsCallback,
                    statsCallback: statsCallback,
                  ),
                  boundingBoxes(results)
                ],
              )),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  StatsRow('Inference time:', '${stats?.inferenceTime} ms'),
                  StatsRow('Total prediction time:',
                      '${stats?.totalElapsedTime} ms'),
                  StatsRow(
                      'Pre-processing time:', '${stats?.preProcessingTime} ms'),
                  StatsRow('Frame',
                      '''${CameraViewSingleton.inputImageSize?.width} X ${CameraViewSingleton.inputImageSize?.height}'''),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget boundingBoxes(List<Recognition>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results
          .map((e) => BoxWidget(
                result: e,
              ))
          .toList(),
    );
  }
}
