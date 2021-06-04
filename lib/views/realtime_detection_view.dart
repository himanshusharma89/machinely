import 'package:flutter/material.dart';

import '../models_list.dart';
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
