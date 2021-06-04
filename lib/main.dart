import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/realtime_detection_view.dart';
import 'views/static_image_prediction_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Machinely',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            textTheme:
                GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
          ),
          textTheme:
              GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme)),
      home: const MyHomePage(title: 'Machinely'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<StatefulWidget>(
                          builder: (_) => const StatiImagePredictionView()));
                },
                child: const Text(
                  'Static Image Prediction',
                )),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<StatefulWidget>(
                          builder: (_) => const RealtimeDetectionView()));
                },
                child: const Text(
                  'Real Time Detection',
                ))
          ],
        ),
      ),
    );
  }
}
