// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
// import 'package:video_player/video_player.dart';

// class streamPlayer extends StatefulWidget {
//   const streamPlayer({super.key});

//   @override
//   State<streamPlayer> createState() => _streamPlayerState();
// }

// class _streamPlayerState extends State<streamPlayer> {
//   late VideoPlayerController _controller;

//   Future<void> initializePlayer() async {}
//   Size _playerSize = Size(0, 0);
//   GlobalKey _videoPlayer = GlobalKey();
//   late VlcPlayerController _videoPlayerController;
//   double _IconSize = 60.0;
//   bool _isPlaying = false;

//   void _playAndPause() {
//     setState(() {
//       _isPlaying = !_isPlaying;
//       if (_isPlaying) {
//         _videoPlayerController.play();
//       } else {
//         _videoPlayerController.pause();
//       }
//     });
//   }

//   Size _getPlayerSize(GlobalKey key) {
//     if (key.currentContext != null) {
//       final RenderBox renderBox =
//           key.currentContext!.findRenderObject() as RenderBox;
//       Size size = renderBox.size;
//       return size;
//     } else {
//       return Size(0, 0);
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _playerSize = _getPlayerSize(_videoPlayer);
//       setState(() {});
//     });
//     _controller = VideoPlayerController.networkUrl(Uri.parse(
//         'https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8'))
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//     super.initState();
//   }

//   @override
//   Future<void> dispose() async {
//     // TODO: implement dispose
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(children: [
//       AspectRatio(
//         aspectRatio: _controller.value.aspectRatio,
//         child: VideoPlayer(_controller),
//       ),
//       ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//           child: Container(
//             width: _playerSize.width,
//             height: _playerSize.height,
//             color: Colors.white.withOpacity(0.3),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.skip_previous_rounded,
//                         size: _IconSize,
//                         color: Colors.white,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: _playAndPause,
//                       icon: Icon(
//                         _isPlaying
//                             ? Icons.pause_circle_outline_outlined
//                             : Icons.play_circle_outlined,
//                         size: _IconSize,
//                         color: Colors.white,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () {},
//                       icon: Icon(
//                         Icons.skip_next_rounded,
//                         size: _IconSize,
//                         color: Colors.white,
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     ]);
//   }
// }
