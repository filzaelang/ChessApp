import 'package:flutter/material.dart';
// import '../widgets/alert.dart';
import '../../data/services/make_rooms.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
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
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Create Room Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        makeRooms(context);
                      },
                      icon: Icon(Icons.add, size: 18),
                      label: Text('Buat Ruangan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(fontSize: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  // Available Rooms Section
                  Text(
                    'Ruangan Tersedia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 12),

                  // Room List
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        _buildRoomItem('Room 1', 'Pemain: 1/2', true),
                        _buildRoomItem('Room 2', 'Pemain: 2/2', false),
                      ],
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

  Widget _buildRoomItem(String roomName, String playerCount, bool canJoin) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        title: Text(roomName),
        subtitle: Text(playerCount),
        trailing: canJoin
            ? ElevatedButton(
                onPressed: () {},
                child: Text('Join'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              )
            : Chip(
                label: Text('Penuh'),
                backgroundColor: Colors.red,
                labelStyle: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';

// class RoomPage extends StatelessWidget {
//   const RoomPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // AppBar
//       appBar: AppBar(title: const Text('Hello World Page')),

//       // Body (Berisi konten utama)
//       body: Center(
//         child: Text(
//           'Hello World',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//       ),

//       // Floating action button (Opsional)
//     );
//   }
// }

