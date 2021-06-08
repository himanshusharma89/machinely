import 'package:flutter/material.dart';

import '../classifiers/object_classifier/recognition.dart';
import '../classifiers/object_classifier/stats.dart';
import '../widget/box_widget.dart';
import '../widget/camera_screen_widget.dart';
import '../widget/camera_view_singleton.dart';
import '../widget/stats_row.dart';

/// Widget showcasing Realtime Object Detection
class RealtimeDetectionView extends StatefulWidget {
  /// Constructor
  const RealtimeDetectionView({Key? key}) : super(key: key);

  @override
  _RealtimeDetectionViewState createState() => _RealtimeDetectionViewState();
}

class _RealtimeDetectionViewState extends State<RealtimeDetectionView> {
  //// Results to draw bounding boxes
  List<Recognition>? results;

  /// Realtime stats
  Stats? stats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Realtime Detection')),
      body: Column(
        children: [
          Flexible(
            flex: 9,
            child: Stack(
              children: <Widget>[
                // Camera View
                CameraView(resultsCallback, statsCallback),
                // Bounding boxes
                boundingBoxes(results),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          // Bottom Sheet
          Flexible(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                (stats != null)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            StatsRow('Inference time:',
                                '${stats!.inferenceTime} ms'),
                            StatsRow('Total prediction time:',
                                '${stats!.totalElapsedTime} ms'),
                            StatsRow('Pre-processing time:',
                                '${stats!.preProcessingTime} ms'),
                            StatsRow('Frame',
                                '''${CameraViewSingleton.inputImageSize?.width} X ${CameraViewSingleton.inputImageSize?.height}'''),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Returns Stack of bounding boxes
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

  /// Callback to get inference results from [CameraView]
  void resultsCallback(List<Recognition> results) {
    if (mounted) {
      setState(() {
        this.results = results;
      });
    }
  }

  /// Callback to get inference stats from [CameraView]
  void statsCallback(Stats stats) {
    if (mounted) {
      setState(() {
        this.stats = stats;
      });
    }
  }
}
