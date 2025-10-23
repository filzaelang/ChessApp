import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'udp_services.dart';
import 'udp_server.dart';

Future<void> makeRooms(BuildContext context) async {
  context.goNamed('game');
  await inisiator();
}

// final udpServices = UdpServices();

// Future<void> makeRooms(BuildContext context) async {
//   await udpServices.startListening();

//   await udpServices.sendBroadcast('HOST_AVAILABLE:ChessRoom');

//   context.goNamed('game');

//   udpServices.onMessage.listen((msg) {
//     if (msg.startsWith('JOIN_REQUEST')) {
//       print('Ada pemain ingin bergabung!');
//     }
//   });
// }

// Future<void> searchRooms() async {
//   await udpServices.startListening();

//   udpServices.onMessage.listen((msg) {
//     if (msg.contains('HOST_AVAIABLE')) {
//       print('Host ditemukan!');
//     }
//   });
// }

// Future<void> joinRoom(String hostIp) async {
//   await udpServices.sendDirect(hostIp, 'JOIN_REQUEST:Player');
// }

// makeRooms(BuildContext context) async {
//   context.goNamed('game');
//   await sendUdpBroadcast();
// }

// Future<void> sendUdpBroadcast() async {
//   // Membuat client UDP
//   var receiver = await UDP.bind(Endpoint.any(port: Port(12345)));

//   // Tentukan alamat broadcast lokal
//   String broadcastAddress = '255.255.255.255'; // Broadcast di jaringan lokal
//   var endpoint = Endpoint.unicast(
//     InternetAddress(broadcastAddress),
//     port: Port(12345),
//   );

//   // Pesan yang dikirim melalui broadcast
//   String message = 'Hello from Chess Room!';

//   // Kirim broadcast
//   await receiver.send(message.codeUnits, endpoint);
//   print('Broadcast UDP terkirim ke $broadcastAddress di port 12345');

//   // CLose receiver setelah selesai
//   receiver.close();
// }

// Future<void> listenForUdpMessages() async {
//   var receiver = await UDP.bind(
//     Endpoint.any(port: Port(12345)),
//   ); // Bind ke port yang sama

//   receiver.asStream(timeout: Duration(seconds: 20)).listen((datagram) {
//     var message = String.fromCharCodes(datagram!.data);
//     print('Pesan diterima: $message');
//   });
// }
