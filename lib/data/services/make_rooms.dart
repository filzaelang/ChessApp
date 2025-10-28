import 'package:chess/data/models/board_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room_model.dart';
import '../services/room_provider.dart';
import 'package:go_router/go_router.dart';
import 'udp_server.dart';

Future<void> makeRooms(BuildContext context) async {
  final board = Provider.of<BoardModel>(context, listen: false);
  registerBoard(
    board,
    serverMode: true,
    targetIp: '192.168.47.122',
  ); // IP server
  await startUdpListener();

  // Simpan room yang dibuat
  final roomProvider = Provider.of<RoomProvider>(context, listen: false);
  roomProvider.addRoom(
    Room(name: 'Room ${roomProvider.rooms.length + 1}', ip: '192.168.47.122'),
  );

  context.goNamed('game');
}
