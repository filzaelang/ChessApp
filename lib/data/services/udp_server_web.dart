import 'dart:html';

// 192.168.47.122
Future<void> inisiator() async {
  final ws = WebSocket('ws://192.168.47.122:8082');

  ws.onOpen.listen((event) {
    print("WebSocket connected to ws://192.168.47.122:8082");
    ws.send("ping");
  });

  ws.onMessage.listen((MessageEvent event) {
    print("Received: ${event.data}");
  });

  ws.onError.listen((event) {
    print("WebSocket error: $event");
  });

  ws.onClose.listen((event) {
    print("WebSocket connection closed");
  });
}
