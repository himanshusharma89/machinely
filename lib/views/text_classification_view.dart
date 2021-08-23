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
import '../classifiers/text_classifier/text_classifier.dart';

/// Widget showcasing Text Classification
class TextClassificationView extends StatefulWidget {
  /// Constructor
  const TextClassificationView({Key? key}) : super(key: key);

  @override
  _TextClassificationViewState createState() => _TextClassificationViewState();
}

class _TextClassificationViewState extends State<TextClassificationView> {
  late TextEditingController _controller;
  late TextClassifier _classifier;
  late List<Widget> _list;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _classifier = TextClassifier();
    _list = [];
    _list.add(const SizedBox());
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
                      _list.add(Padding(
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
                      ));
                      _controller.clear();
                    });
                  },
                ),
              ]),
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (_, index) {
                return _list[index];
              },
            )),
          ],
        ),
      ),
    );
  }
}
