// import 'dart:async';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'filament_controller.dart';
// import 'filament_widget.dart';

// enum GestureType { RotateCamera, PanCamera, PanBackground }

// class AvatarGestureDetector extends StatefulWidget {
//   final AvatarInstance controller;
//   final bool showControls;

//   const AvatarGestureDetector({
//     Key? key,
//     required this.controller,
//     this.showControls = false,
//   }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _AvatarGestureDetectorState();
// }

// class _AvatarGestureDetectorState extends State<AvatarGestureDetector> {
//   GestureType gestureType = GestureType.PanCamera;

//   final _icons = {
//     GestureType.PanBackground: Icons.image,
//     GestureType.PanCamera: Icons.pan_tool,
//     GestureType.RotateCamera: Icons.rotate_90_degrees_ccw
//   };

//   // to avoid duplicating code for pan/rotate (panStart, panUpdate, panEnd, rotateStart, rotateUpdate etc)
//   // we have only a single function for start/update/end.
//   // when the gesture type is changed, these properties are updated to point to the correct function.
//   late Future Function(double x, double y) _functionStart;
//   late Future Function(double x, double y) _functionUpdate;
//   late Future Function() _functionEnd;

//   double _lastScale = 0;

//   @override
//   void initState() {
//     _setFunction();
//     super.initState();
//   }

//   void _setFunction() {
//     switch (gestureType) {
//       case GestureType.RotateCamera:
//         _functionStart = widget.controller.rotateStart;
//         _functionUpdate = widget.controller.rotateUpdate;
//         _functionEnd = widget.controller.rotateEnd;
//         break;
//       case GestureType.PanCamera:
//         _functionStart = widget.controller.panStart;
//         _functionUpdate = widget.controller.panUpdate;
//         _functionEnd = widget.controller.panEnd;
//         break;
//       // TODO
//       case GestureType.PanBackground:
//         _functionStart = (x, y) async {};
//         _functionUpdate = (x, y) async {};
//         _functionEnd = () async {};
//     }
//   }

//   @override
//   void didUpdateWidget(AvatarGestureDetector oldWidget) {
//     if (widget.showControls != oldWidget.showControls) {
//       setState(() {});
//     }

//     super.didUpdateWidget(oldWidget);
//   }

//   Timer? _scrollTimer;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       Positioned.fill(
//           // pinch zoom on mobile
//           // couldn't find any equivalent for pointerCount in Listener so we use two widgets:
//           // - outer is a GestureDetector only for pinch zoom
//           // - inner is a Listener for all other gestures
//           child: GestureDetector(
//               // onScaleStart: (d) async {
//               //   if (d.pointerCount == 2) {
//               //     await widget.controller.zoomEnd();
//               //     await widget.controller.zoomBegin();
//               //   }
//               // },
//               // onScaleEnd: (d) async {
//               //   if (d.pointerCount == 2) {
//               //     _lastScale = 0;
//               //     await widget.controller.zoomEnd();
//               //   }
//               // },
//               // onScaleUpdate: (d) async {
//               //   if (d.pointerCount == 2) {
//               //     if (_lastScale != 0) {
//               //       await widget.controller
//               //           .zoomUpdate(100 * (_lastScale - d.scale));
//               //     }
//               //   }
//               //   _lastScale = d.scale;
//               // },
//               child: Listener(
//                   onPointerSignal: (pointerSignal) async {
//                     // scroll-wheel zoom on desktop
//                     if (pointerSignal is PointerScrollEvent) {
//                       _scrollTimer?.cancel();
//                       await widget.controller.zoomBegin();
//                       await widget.controller.zoomUpdate(
//                           pointerSignal.scrollDelta.dy > 0 ? 10 : -10);
//                       _scrollTimer = Timer(Duration(milliseconds: 100), () {
//                         widget.controller.zoomEnd();
//                         _scrollTimer = null;
//                       });
//                     } else {
//                       print(pointerSignal);
//                     }
//                   },
//                   onPointerPanZoomStart: (pzs) {},
//                   onPointerDown: (d) async {
//                     await _functionStart(
//                         d.localPosition.dx, d.localPosition.dy);
//                   },
//                   onPointerMove: (d) async {
//                     await _functionUpdate(
//                         d.localPosition.dx, d.localPosition.dy);
//                   },
//                   onPointerUp: (d) async {
//                     await _functionEnd();
//                   },
//                   child: widget.child))),
//       widget.showControls
//           ? Align(
//               alignment: Alignment.bottomRight,
//               child: GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     var curIdx = GestureType.values.indexOf(gestureType);
//                     var nextIdx = curIdx == GestureType.values.length - 1
//                         ? 0
//                         : curIdx + 1;
//                     gestureType = GestureType.values[nextIdx];
//                     _setFunction();
//                   });
//                 },
//                 child: Container(
//                     padding: const EdgeInsets.all(50),
//                     child: Icon(_icons[gestureType], color: Colors.green)),
//               ))
//           : Container()
//     ]);
//   }
// }