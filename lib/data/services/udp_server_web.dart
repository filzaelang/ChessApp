// import 'package:web/web.dart' as web;

// Future<void> inisiator() async {
//   // Membuat WebSocket JS bawaan browser
//   final ws = web.WebSocket('ws://192.168.47.122:8082');

//   // Event onopen
//   ws.addEventListener('open', (web.Event event) {
//     print("WebSocket connected to ws://192.168.47.122:8082");
//     ws.send("ping");
//   });

//   // Event onmessage
//   ws.addEventListener('message', (web.MessageEvent event) {
//     print("Received: ${event.data}");
//   });

//   // Event onerror
//   ws.addEventListener('error', (web.Event event) {
//     print("WebSocket error: $event");
//   });
// }
