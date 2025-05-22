import 'package:flutter/material.dart';
import 'package:iotec/features/video_stream/presentation/screens/video_stream_screen.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoTeC',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const VideoStreamPage(), // ? Or main navigation structure
    );
  }
}
