import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iotec/features/video_stream/domain/repositories/video_stream_service.dart';
import 'package:iotec/features/video_stream/presentation/cubit/video_stream_cubit.dart';

// class VideoStreamPage extends StatelessWidget {
//   const VideoStreamPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create:
//           (context) =>
//               VideoStreamCubit(VideoStreamService()), // Provide the service
//       child: const VideoStreamView(),
//     );
//   }
// }

class VideoStreamView extends StatelessWidget {
  const VideoStreamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Security Feed')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: BlocConsumer<VideoStreamCubit, VideoStreamState>(
            listener: (context, state) {
              if (state is VideoStreamError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text('Error: ${state.error}')),
                  );
              } else if (state is VideoStreamDisconnected) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(state.message ?? 'Disconnected')),
                  );
              }
            },
            builder: (context, state) {
              if (state is VideoStreamInitial) {
                return const Text('Press connect to start stream.');
              } else if (state is VideoStreamConnecting) {
                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Connecting...'),
                  ],
                );
              } else if (state is VideoStreamStreaming) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Image.memory(
                    //       state.frameData,
                    //       gaplessPlayback: true, // For smoother frame transitions
                    //       fit: BoxFit.contain,
                    //       errorBuilder: (context, error, stacktrace) {
                    //         // This can happen if frameData is corrupted
                    //         print("Image.memory error: $error");
                    //         return const Center(
                    //           child: Text('Error displaying frame'),
                    //         );
                    //       },
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey[300],
                      child: Image.memory(
                        state.frameData,
                        gaplessPlayback: true,
                        fit: BoxFit.contain,
                        // width: double.infinity, //? explicit
                        // height: 100, // ? explicit
                        errorBuilder: (context, error, stacktrace) {
                          print("Image.memory FAILED to render: $error");
                          return const Center(
                            child: Text(
                              'Error',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Streaming Live...",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              } else if (state is VideoStreamDisconnected) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.orange,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message ?? 'Stream disconnected.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<VideoStreamCubit>().connect(),
                      child: const Text('Reconnect'),
                    ),
                  ],
                );
              } else if (state is VideoStreamError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Error: ${state.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => context.read<VideoStreamCubit>().connect(),
                      child: const Text('Retry Connection'),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink(); // ? should not happen lol
            },
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<VideoStreamCubit, VideoStreamState>(
        builder: (context, state) {
          if (state is VideoStreamStreaming || state is VideoStreamConnecting) {
            return FloatingActionButton(
              onPressed: () => context.read<VideoStreamCubit>().disconnect(),
              tooltip: 'Disconnect Stream',
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
              onPressed: () => context.read<VideoStreamCubit>().connect(),
              tooltip: 'Connect Stream',
              child: const Icon(Icons.play_arrow),
            );
          }
        },
      ),
    );
  }
}
