import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/board_model.dart';

BoardModel? globalBoard;
bool isServer = true;
String opponentIp = '192.168.47.122';

void registerBoard(
  BoardModel board, {
  required bool serverMode,
  required String targetIp,
}) {
  globalBoard = board;
  isServer = serverMode;
  opponentIp = targetIp;
}

Future<void> startUdpListener() async {
  final int listenPort = isServer ? 8082 : 8085;
  final socket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    listenPort,
  );
  socket.broadcastEnabled = true;
  print(
    "UDP ${isServer ? 'SERVER' : 'CLIENT'} listening on ${socket.address.address}:$listenPort",
  );

  socket.listen((RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final dg = socket.receive();
      if (dg == null) return;
      final message = utf8.decode(dg.data);

      if (listenPort == 8082) {
        if (message == 'room_discovery') {
          // Reply with room info
          final reply = 'room:MyRoom:${dg.address.address}';
          socket.send(utf8.encode(reply), dg.address, dg.port);
          print("Sent room info to ${dg.address.address}");
        }
      }

      if (message.startsWith("move:")) {
        final parts = message.replaceFirst("move:", "").split(',');
        if (parts.length == 4) {
          final fFile = int.parse(parts[0]);
          final fRank = int.parse(parts[1]);
          final tFile = int.parse(parts[2]);
          final tRank = int.parse(parts[3]);

          debugPrint("Gerakan lawan: $fFile,$fRank → $tFile,$tRank");
          globalBoard?.applyRemoteMove(fFile, fRank, tFile, tRank);
        }
      }
    }
  });
}

void sendMove(int fromFile, int fromRank, int toFile, int toRank) async {
  final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  final target = InternetAddress(opponentIp);
  final targetPort = isServer ? 8085 : 8082;
  final message = 'move:$fromFile,$fromRank,$toFile,$toRank';
  socket.send(utf8.encode(message), target, targetPort);
  socket.close();

  debugPrint("Send move to $opponentIp:$targetPort -> $message");
}
