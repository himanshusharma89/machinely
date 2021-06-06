// import 'dart:math';

// import 'package:flutter/material.dart';

// import '../models.dart';

// class BndBox extends StatelessWidget {
//   final List? results;
//   final double? previewH;
//   final double? previewW;
//   final double screenH;
//   final double screenW;
//   final String model;

//   BndBox(
//       {this.results,
//       this.previewH,
//       this.previewW,
//       required this.screenH,
//       required this.screenW,
//       required this.model});

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> _renderBoxes() {
//       if (results == null) return [];
//       if (previewH == null || previewW == null) return [];

//       final factorX = screenW;
//       final factorY = previewH! / previewW! * screenW;
//       final blue = Color.fromRGBO(37, 213, 253, 1.0);
//       return results!.map((re) {
//         return Positioned(
//           left: double.parse(re['rect']['x'].toString()) * factorX,
//           top: double.parse(re['rect']['y'].toString()) * factorY,
//           width: double.parse(re['rect']['w'].toString()) * factorX,
//           height: double.parse(re['rect']['h'].toString()) * factorY,
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.all(Radius.circular(8.0)),
//               border: Border.all(
//                 color: blue,
//                 width: 2,
//               ),
//             ),
//             child: Text(
//               '''${re["detectedClass"]}
//${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%''',
//               style: TextStyle(
//                 background: Paint()..color = blue,
//                 color: Colors.white,
//                 fontSize: 12.0,
//               ),
//             ),
//           ),
//         );
//       }).toList();
//     }

//     Widget _renderStrings() {
//       return Center(
//         child: Column(
//             children: results != null
//                 ? results!.map((re) {
//                     return Text(
//                       '''${re["label"]}
//${(re["confidence"] * 100).toStringAsFixed(0)}%''',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     );
//                   }).toList()
//                 : []),
//       );
//     }

//     List<Widget> _renderKeypoints() {
//       if (results == null) return [];
//       if (previewH == null || previewW == null) return [];

//       final factorX = screenW;
//       final factorY = previewH! / previewW! * screenW;

//       final lists = <Widget>[];

//       results!.forEach((re) {
//         final color = Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
//             .withOpacity(1.0);
//         final list = re['keypoints'].values.map<Widget>((k) {
//           return Positioned(
//             left: double.parse(k['x'].toString()) * factorX - 6,
//             top: double.parse(k['y'].toString()) * factorY - 6,
//             width: 100,
//             height: 12,
//             child: Text(
//               "● ${k["part"]}",
//               style: TextStyle(
//                 color: color,
//                 fontSize: 12.0,
//               ),
//             ),
//           );
//         }).toList();

//         lists..addAll(list as List<Widget>);
//       });

//       return lists;
//     }

//     return Stack(
//       children: model == mobilenet
//           ? [_renderStrings()]
//           : model == posenet
//               ? _renderKeypoints()
//               : _renderBoxes(),
//     );
//   }
// }
