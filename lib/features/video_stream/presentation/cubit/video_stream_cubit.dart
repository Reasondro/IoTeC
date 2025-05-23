import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iotec/features/video_stream/domain/repositories/video_stream_service.dart';

part 'video_stream_state.dart';

class VideoStreamCubit extends Cubit<VideoStreamState> {
  final VideoStreamService _videoStreamService;
  StreamSubscription? _framesSubscription;
  StreamSubscription? _disconnectSubscription;

  // ? example url
  // final String _wsUrl = "ws://10.0.2.2:8000/ws/client";
  // final String _wsUrl = "ws://10.0.2.2:8001/ws/client_dummy";
  final String _wsUrl = "ws://10.0.2.2:8000/ws/client";
  // ? exmplae: "ws://192.168.1.100:8000/ws/client"

  VideoStreamCubit(this._videoStreamService) : super(VideoStreamInitial()) {
    _disconnectSubscription = _videoStreamService.disconnectStream.listen((
      message,
    ) {
      emit(VideoStreamDisconnected(message: message ?? "Stream ended."));
    });
  }

  Future<void> connect() async {
    if (state is VideoStreamConnecting || state is VideoStreamStreaming) return;

    emit(VideoStreamConnecting());
    try {
      await _videoStreamService.connect(_wsUrl);
      // ? service  hanldes adding frames to its stream.
      _framesSubscription?.cancel();
      _framesSubscription = _videoStreamService.framesStream.listen(
        (frameData) {
          print(
            "VideoStreamCubit: Emitting VideoStreamStreaming with frameData length: ${frameData.length}",
          );
          emit(VideoStreamStreaming(frameData));
        },
        onError: (error) {
          emit(VideoStreamError(error.toString()));
        },
      );
      // ? If connect itself doesn't throw and frames start coming,
      // ? the first VideoStreamStreaming state will be emitted by the listener.
      // ? If the connection is established but no frames yet, it stays Connecting.
      // ? We might need an explicit "Connected" state if no frames arrive immediately.
      // ? For now, first frame will move it to Streaming.
    } catch (e) {
      emit(VideoStreamError(e.toString()));
    }
  }

  void disconnect() {
    _framesSubscription?.cancel();
    _videoStreamService.disconnect();
    // ? The disconnectStream listener in the constructor will handle emitting VideoStreamDisconnected
  }

  @override
  Future<void> close() {
    _framesSubscription?.cancel();
    _disconnectSubscription?.cancel();
    _videoStreamService.dispose();
    return super.close();
  }
}
