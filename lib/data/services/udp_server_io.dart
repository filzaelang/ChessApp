import 'dart:io';
import 'dart:convert';

Future<void> inisiator() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8082);
  print("UDP listening on ${socket.address.address}:${socket.port}");

  socket.broadcastEnabled = true;

  socket.listen((RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final dg = socket.receive();
      if (dg == null) return;
      final message = String.fromCharCodes(dg.data);

      if (message == "ping") {
        socket.send(utf8.encode("ping ack"), dg.address, dg.port);
      }

      if (message == 'room_discovery') {
        // Reply with room info
        final reply = 'room:MyRoom:${dg.address.address}';
        socket.send(utf8.encode(reply), dg.address, dg.port);
        print("Sent room info to ${dg.address.address}");
      }

      if (message == 'join_room') {
        final reply = 'enter_room';
        socket.send(utf8.encode(reply), dg.address, dg.port);
        print("Game started");
      }
    }
  });
}
