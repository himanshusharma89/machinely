import 'package:flutter/material.dart';

import 'card_view_widget.dart';

class CameraScreenWidget extends StatefulWidget {
  const CameraScreenWidget({Key? key}) : super(key: key);
  @override
  _CameraScreenWidgetState createState() => _CameraScreenWidgetState();
}

class _CameraScreenWidgetState extends State<CameraScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return const CardView(child: Text('No Camera to Preview'));
  }
}
