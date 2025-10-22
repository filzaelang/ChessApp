import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:udp/udp.dart';

makeRooms(BuildContext context) async {
  context.goNamed('game');
  await sendUdpBroadcast();
}

Future<void> sendUdpBroadcast() async {
  // Membuat client UDP
  var receiver = await UDP.bind(Endpoint.any(port: Port(12345)));

  // Tentukan alamat broadcast lokal
  String broadcastAddress = '255.255.255.255'; // Broadcast di jaringan lokal
  var endpoint = Endpoint.unicast(
    InternetAddress(broadcastAddress),
    port: Port(12345),
  );

  // Pesan yang dikirim melalui broadcast
  String message = 'Hello from Chess Room!';

  // Kirim broadcast
  await receiver.send(message.codeUnits, endpoint);
  print('Broadcast UDP terkirim ke $broadcastAddress di port 12345');

  // CLose receiver setelah selesai
  receiver.close();
}

Future<void> listenForUdpMessages() async {
  var receiver = await UDP.bind(
    Endpoint.any(port: Port(12345)),
  ); // Bind ke port yang sama

  receiver.asStream(timeout: Duration(seconds: 20)).listen((datagram) {
    var message = String.fromCharCodes(datagram!.data);
    print('Pesan diterima: $message');
  });
}
