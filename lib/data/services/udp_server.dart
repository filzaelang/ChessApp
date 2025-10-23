export 'udp_server_io.dart' if (dart.library.html) 'udp_server_web.dart';

// import 'dart:io';
// import 'dart:convert';

// String serverAddress = "ws://192.168.47.122";
// int port = 8082;

// Future<void> inisiator() async {
//   if (Platform.isAndroid || Platform.isWindows) {
//     final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);

//     // listen forever & send response
//     socket.listen((RawSocketEvent event) {
//       if (event == RawSocketEvent.read) {
//         Datagram? dg = socket.receive();
//         if (dg == null) return;
//         final recvd = String.fromCharCodes(dg.data);

//         /// send ack to anyone who sends ping
//         if (recvd == "ping") {
//           socket.send(Utf8Codec().encode("ping ack"), dg.address, dg.port);
//         }
//       }
//     });
//   } else {
//     // fallback ke WebSocket / HTTP
//     final ws = await WebSocket.connect('$serverAddress:$port');
//     ws.listen((msg) => print('Received: $msg'));
//     ws.add('ping');
//   }
// }
