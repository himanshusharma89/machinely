import 'package:flutter/material.dart';

class CardView extends StatelessWidget {
  const CardView({required this.child, Key? key})
      : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.5),
            borderRadius: BorderRadius.circular(22)),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
