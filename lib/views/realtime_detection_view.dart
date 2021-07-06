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

import 'package:flutter/material.dart';

import '../helpers/camera_view_singleton.dart';
import '../helpers/recognition.dart';
import '../helpers/stats.dart';
import '../widget/box_widget.dart';
import '../widget/camera_view_widget.dart';
import '../widget/stats_row_widget.dart';

/// Widget showcasing Realtime Object Detection
class RealtimeDetectionView extends StatefulWidget {
  /// Constructor
  const RealtimeDetectionView({Key? key}) : super(key: key);

  @override
  _RealtimeDetectionViewState createState() => _RealtimeDetectionViewState();
}

class _RealtimeDetectionViewState extends State<RealtimeDetectionView> {
  /// Results to draw bounding boxes
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
