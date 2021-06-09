import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/realtime_detection_view.dart';
import 'views/static_image_prediction_view.dart';
import 'views/text_classification.dart';

/// List of cameras
List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

/// Root of the app
class MyApp extends StatelessWidget {
  /// Constructor
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

/// MyHomePage widget consisting of buttons to navigate to
/// Text Classification, Image Prediction and Object Detection.
class MyHomePage extends StatefulWidget {
  /// Constructor
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  /// App title
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
                          builder: (_) => const TextClassification()));
                },
                child: const Text(
                  'Text Classification',
                )),
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
                )),
          ],
        ),
      ),
    );
  }
}
