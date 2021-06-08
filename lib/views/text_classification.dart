import 'package:flutter/material.dart';

/// Widget showcasing Text Classification
class TextClassification extends StatefulWidget {
  /// Constructor
  const TextClassification({Key? key}) : super(key: key);

  @override
  _TextClassificationState createState() => _TextClassificationState();
}

class _TextClassificationState extends State<TextClassification> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Classification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: <Widget>[
                Expanded(
                  child: TextField(
                    showCursor: true,
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write some text here',
                        hintStyle: TextStyle(fontWeight: FontWeight.normal)),
                    controller: _controller,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                  child: const Text('Classify'),
                  onPressed: () {},
                ),
              ]),
            ),
            Expanded(child: ListView()),
          ],
        ),
      ),
    );
  }
}
