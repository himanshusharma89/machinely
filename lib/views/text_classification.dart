import 'package:flutter/material.dart';
import '../classifiers/text_classifier/text_classifier.dart';

/// Widget showcasing Text Classification
class TextClassification extends StatefulWidget {
  /// Constructor
  const TextClassification({Key? key}) : super(key: key);

  @override
  _TextClassificationState createState() => _TextClassificationState();
}

class _TextClassificationState extends State<TextClassification> {
  late TextEditingController _controller;
  late TextClassifier _classifier;
  late List<Widget> _children;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = TextClassifier();
    _children = [];
    _children.add(Container());
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
                  onPressed: () {
                    final text = _controller.text;
                    final prediction = _classifier.classify(text);
                    setState(() {
                      _children.add(Dismissible(
                        key: GlobalKey(),
                        onDismissed: (direction) {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: prediction[1] > prediction[0]
                                  ? Colors.lightGreen
                                  : Colors.redAccent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Input: $text',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Text('Output:'),
                                Text('   Positive: ${prediction[1]}'),
                                Text('   Negative: ${prediction[0]}'),
                              ],
                            ),
                          ),
                        ),
                      ));
                      _controller.clear();
                    });
                  },
                ),
              ]),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _children.length,
              itemBuilder: (_, index) {
                return _children[index];
              },
            )),
          ],
        ),
      ),
    );
  }
}
