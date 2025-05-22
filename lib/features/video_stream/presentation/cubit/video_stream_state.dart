part of 'video_stream_cubit.dart';

sealed class VideoStreamState extends Equatable {
  const VideoStreamState();

  @override
  List<Object?> get props => [];
}

final class VideoStreamInitial extends VideoStreamState {}

final class VideoStreamConnecting extends VideoStreamState {}

final class VideoStreamStreaming extends VideoStreamState {
  final Uint8List frameData;

  const VideoStreamStreaming(this.frameData);

  @override
  List<Object?> get props => [frameData];
}

final class VideoStreamDisconnected extends VideoStreamState {
  final String? message;
  const VideoStreamDisconnected({this.message});

  @override
  List<Object?> get props => [message];
}

final class VideoStreamError extends VideoStreamState {
  final String error;

  const VideoStreamError(this.error);

  @override
  List<Object?> get props => [error];
}
