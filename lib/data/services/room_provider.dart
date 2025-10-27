import 'package:flutter/material.dart';
import '../models/room_model.dart';

class RoomProvider extends ChangeNotifier {
  final List<Room> _rooms = [];

  List<Room> get rooms => List.unmodifiable(_rooms);

  void addRoom(Room room) {
    _rooms.add(room);
    notifyListeners();
  }

  void clearRooms() {
    _rooms.clear();
    notifyListeners();
  }
}
