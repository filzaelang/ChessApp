import 'dart:io';
import 'dart:convert';

Future<void> inisiator() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 8082);
  print("UDP listening on ${socket.address.address}:${socket.port}");

  socket.listen((RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final dg = socket.receive();
      if (dg == null) return;
      final recvd = String.fromCharCodes(dg.data);
      if (recvd == "ping") {
        socket.send(Utf8Encoder().convert("ping ack"), dg.address, dg.port);
      }
    }
  });
}
