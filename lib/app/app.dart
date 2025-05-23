import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iotec/app/themes/light_mode.dart';
import 'package:iotec/features/video_stream/domain/repositories/video_stream_service.dart';
import 'package:iotec/features/video_stream/presentation/cubit/video_stream_cubit.dart';

class App extends StatelessWidget {
  const App({super.key, required this.router});

  final GoRouter router;
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
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: "IoTeC",
          theme: iotecLightTheme,
          routerConfig: router,
        ),
      ),
    );
  }
}
