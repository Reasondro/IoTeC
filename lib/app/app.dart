import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iotec/features/video_stream/domain/repositories/video_stream_service.dart';
import 'package:iotec/features/video_stream/presentation/cubit/video_stream_cubit.dart';
import 'package:iotec/features/video_stream/presentation/screens/video_stream_screen.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoTeC',
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: const VideoStreamPage(), // ? Or main navigation structure
      home: MultiBlocProvider(
        providers: [
          BlocProvider<VideoStreamCubit>(
            create: (context) => VideoStreamCubit(VideoStreamService()),
          ),
        ],
        child: VideoStreamView(),
      ),
    );
  }
}
