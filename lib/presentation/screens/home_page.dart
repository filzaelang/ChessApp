import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/board_model.dart';
import '../widgets/chess_board.dart';

class ChessHomePage extends StatelessWidget {
  const ChessHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final boardModel = Provider.of<BoardModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catur — Chess Board UI'),
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: () => boardModel.reset(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: const SafeArea(child: Center(child: ChessBoard())),
    );
  }
}
