import 'package:chess/data/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import '../widgets/alert.dart';
import '../../data/services/make_rooms.dart';
import '../../data/services/room_provider.dart';
import '../../data/services/room_discovery.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.watch<RoomProvider>();
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      onPressed: () async => await makeRooms(context),
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Buat Ruangan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final rooms = await discoverRooms();
                      for (final r in rooms) {
                        print("Found: $r");
                        final parts = r.split(':');
                        if (parts.length >= 3) {
                          final name = parts[1];
                          final ip = parts[2];
                          context.read<RoomProvider>().addRoom(
                            Room(name: name, ip: ip),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Cari Ruangan di LAN'),
                  ),
                  const Text(
                    'Ruangan Tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: roomProvider.rooms.isEmpty
                        ? const Center(child: Text('Belum ada ruangan.'))
                        : ListView.builder(
                            itemCount: roomProvider.rooms.length,
                            itemBuilder: (context, index) {
                              final room = roomProvider.rooms[index];
                              return _buildRoomItem(
                                room.name,
                                '${room.players}/${room.maxPlayers}',
                                room.canJoin,
                                room.ip,
                                context,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.blue[600],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Chess Waiting Room',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Siap bermain catur online?',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    ),
  );

  Widget _buildRoomItem(
    String roomName,
    String playerCount,
    bool canJoin, [
    String? ip,
    BuildContext? context,
  ]) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(roomName),
        subtitle: Text('IP: $ip\nPemain: $playerCount'),
        trailing: canJoin
            ? ElevatedButton(
                onPressed: () async {
                  await joinRoom(context!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text('Join'),
              )
            : const Chip(
                label: Text('Penuh'),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
