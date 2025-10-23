import 'dart:io';
import 'dart:convert';

Future<void> challanger(List<String> args) async {
  final serverIp = InternetAddress('192.168.47.122');
  final serverPort = 8082;

  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

  //kirim pesan "ping"
  final message = 'ping';
  socket.send(Utf8Codec().encode(message), serverIp, serverPort);

  socket.listen((RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final dg = socket.receive();
      if (dg == null) return;
      final data = String.fromCharCodes(dg.data);

      print(data);
    }
  });
}
