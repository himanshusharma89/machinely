import 'package:flutter/material.dart';

import '../widget/camera_screen_widget.dart';

class RealtimeDetectionView extends StatefulWidget {
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
          const Flexible(flex: 8, child: CameraScreenWidget()),
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
                      child: Text('Detect'),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
