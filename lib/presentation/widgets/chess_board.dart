import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:web/web.dart';
import '../../data/models/board_model.dart';
import 'square_widget.dart';

class ChessBoard extends StatelessWidget {
  final bool isFlipped;

  const ChessBoard({super.key, this.isFlipped = false});

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<BoardModel>(context);
    // Responsive sizing: square size based on available width
    return LayoutBuilder(
      builder: (context, constraints) {
        final shortest = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        // Add a bit of padding for labels
        final boardSize = shortest * 0.95;
        final squareSize = boardSize / 8.0;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Board grid
            Container(
              width: boardSize,
              height: boardSize,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: _buildGrid(board, squareSize),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildGrid(BoardModel boardModel, double squareSize) {
    final ranks = List.generate(8, (i) => i);
    final files = List.generate(8, (i) => i);

    final rankList = isFlipped ? ranks : ranks.reversed.toList();
    final fileList = isFlipped ? files.reversed.toList() : files;

    return Column(
      children: rankList.map((rank) {
        return Row(
          children: fileList.map((file) {
            return SizedBox(
              width: squareSize,
              height: squareSize,
              child: SquareWidget(file: file, rank: rank),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
