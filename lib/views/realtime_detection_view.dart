import 'package:flutter/material.dart';

import '../widget/camera_screen_widget.dart';

/// Widget showcasing Realtie Object Detection
class RealtimeDetectionView extends StatefulWidget {
  /// Constructor
  const RealtimeDetectionView({Key? key}) : super(key: key);

  @override
  _RealtimeDetectionViewState createState() => _RealtimeDetectionViewState();
}

class _RealtimeDetectionViewState extends State<RealtimeDetectionView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Detection'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Flexible(flex: 9, child: CameraScreenWidget()),
          const SizedBox(
            height: 15,
          ),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
