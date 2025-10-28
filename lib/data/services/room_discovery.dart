import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:chess/data/models/board_model.dart';
import 'package:chess/data/services/udp_server_io.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final int PORT = 8085;
final serverIp = InternetAddress('192.168.47.122');
final int serverPort = 8082;

Future<List<String>> discoverRooms() async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, PORT);
  socket.broadcastEnabled = true;

  final String message = 'room_discovery';
  socket.send(utf8.encode(message), serverIp, serverPort);

  final List<String> foundRooms = [];

  final completer = Completer<List<String>>();
  socket.listen((event) {
    if (event == RawSocketEvent.read) {
      final dg = socket.receive();
      if (dg != null) {
        final data = utf8.decode(dg.data);
        if (data.startsWith('room:')) {
          foundRooms.add(data);
        }
      }
    }
  });

  // Timeout setelah 3 detik
  Future.delayed(const Duration(seconds: 3), () {
    socket.close();
    completer.complete(foundRooms);
  });

  return completer.future;
}

Future<void> joinRoom(BuildContext context) async {
  final board = Provider.of<BoardModel>(context, listen: false);
  registerBoard(
    board,
    serverMode: false,
    targetIp: '192.168.47.122',
  ); // IP server
  await startUdpListener();

  context.goNamed('game');
}
