import 'dart:async';
import 'dart:typed_data';
import 'package:web_socket_channel/web_socket_channel.dart';

class VideoStreamService {
  WebSocketChannel? _channel;
  final StreamController<Uint8List> _framesController =
      StreamController.broadcast();
  final StreamController<String?> _disconnectController =
      StreamController.broadcast();

  Stream<Uint8List> get framesStream => _framesController.stream;
  Stream<String?> get disconnectStream => _disconnectController.stream;

  bool _isConnected = false;
  String? _currentWsUrl;

  Future<void> connect(String wsUrl) async {
    if (_isConnected && _currentWsUrl == wsUrl) {
      print("Already connected to $wsUrl");
      return;
    }

    _currentWsUrl = wsUrl;
    print("Connecting to $wsUrl...");
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _isConnected = true;

    _channel!.stream.listen(
      (data) {
        if (data is List<int>) {
          print(
            "VideoStreamService: Received bytes with length: ${data.length}",
          );
          _framesController.add(Uint8List.fromList(data));
        } else if (data is String) {
          print("Received string data: $data");
        } else {
          print("Received unexpected data type: ${data.runtimeType}");
        }
      },
      onDone: () {
        _isConnected = false;
        print("WebSocket connection closed.");
        _disconnectController.add("Connection closed by server.");
        // ? optional --> add automatic reconnection logic here or in  Cubit
      },
      onError: (error) {
        _isConnected = false;
        print("WebSocket error: $error");
        _framesController.addError(error);
        _disconnectController.add("Connection error: $error");
      },
      cancelOnError: false, // ?  true --> close on first error
    );
  }

  void disconnect() {
    if (_channel != null && _isConnected) {
      print("Disconnecting from WebSocket...");
      _channel!.sink.close();
      _isConnected = false;
      _currentWsUrl = null;
      // _disconnectController.add("Disconnected manually."); // Or let onDone handle it
    }
  }

  void dispose() {
    _framesController.close();
    _disconnectController.close();
    disconnect();
  }
}
