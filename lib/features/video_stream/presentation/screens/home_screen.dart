import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iotec/features/video_stream/presentation/cubit/video_stream_cubit.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Live Security Feed')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: BlocConsumer<VideoStreamCubit, VideoStreamState>(
//             listener: (context, state) {
//               if (state is VideoStreamError) {
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     SnackBar(content: Text('Error: ${state.error}')),
//                   );
//               } else if (state is VideoStreamDisconnected) {
//                 ScaffoldMessenger.of(context)
//                   ..hideCurrentSnackBar()
//                   ..showSnackBar(
//                     SnackBar(content: Text(state.message ?? 'Disconnected')),
//                   );
//               }
//             },
//             builder: (context, state) {
//               if (state is VideoStreamInitial) {
//                 return const Text('Press connect to start stream.');
//               } else if (state is VideoStreamConnecting) {
//                 return const Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text('Connecting...'),
//                   ],
//                 );
//               } else if (state is VideoStreamStreaming) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: double.infinity,
//                       height: 150,
//                       color: Colors.grey[300],
//                       child: Image.memory(
//                         state.frameData,
//                         gaplessPlayback: true,
//                         fit: BoxFit.contain,
//                         // width: double.infinity, //? explicit
//                         // height: 100, // ? explicit
//                         errorBuilder: (context, error, stacktrace) {
//                           print("Image.memory FAILED to render: $error");
//                           return const Center(
//                             child: Text(
//                               'Error',
//                               style: TextStyle(color: Colors.red),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       "Streaming Live...",
//                       style: TextStyle(
//                         color: Colors.green,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 );
//               } else if (state is VideoStreamDisconnected) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.orange,
//                       size: 48,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(state.message ?? 'Stream disconnected.'),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed:
//                           () => context.read<VideoStreamCubit>().connect(),
//                       child: const Text('Reconnect'),
//                     ),
//                   ],
//                 );
//               } else if (state is VideoStreamError) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(Icons.error, color: Colors.red, size: 48),
//                     const SizedBox(height: 16),
//                     Text('Error: ${state.error}'),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed:
//                           () => context.read<VideoStreamCubit>().connect(),
//                       child: const Text('Retry Connection'),
//                     ),
//                   ],
//                 );
//               }
//               return const SizedBox.shrink(); // ? should not happen lol
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: BlocBuilder<VideoStreamCubit, VideoStreamState>(
//         builder: (context, state) {
//           if (state is VideoStreamStreaming || state is VideoStreamConnecting) {
//             return FloatingActionButton(
//               onPressed: () => context.read<VideoStreamCubit>().disconnect(),
//               tooltip: 'Disconnect Stream',
//               backgroundColor: Colors.red,
//               child: const Icon(Icons.stop),
//             );
//           } else {
//             return FloatingActionButton(
//               onPressed: () => context.read<VideoStreamCubit>().connect(),
//               tooltip: 'Connect Stream',
//               child: const Icon(Icons.play_arrow),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Expanded(
        //   child:
        Padding(
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
                      Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey[300],
                        child: Image.memory(
                          state.frameData,
                          gaplessPlayback: true,
                          fit: BoxFit.contain,
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
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<VideoStreamCubit, VideoStreamState>(
            builder: (context, state) {
              if (state is VideoStreamStreaming ||
                  state is VideoStreamConnecting) {
                return ElevatedButton.icon(
                  onPressed:
                      () => context.read<VideoStreamCubit>().disconnect(),
                  icon: const Icon(Icons.stop),
                  label: const Text('Disconnect Stream'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                );
              } else {
                return ElevatedButton.icon(
                  onPressed: () => context.read<VideoStreamCubit>().connect(),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Connect Stream'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
