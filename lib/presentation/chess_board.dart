import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/board_model.dart';
import 'square_widget.dart';

class ChessBoard extends StatelessWidget {
  const ChessBoard({super.key});

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
            // Simple legend / hints
            const Text(
              'Tap a piece to select, then tap a destination to move (no rule enforcement).',
            ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(BoardModel boardModel, double squareSize) {
    // We want ranks 7..0 top to bottom to show white at bottom (rank 0)
    return Column(
      children: List.generate(8, (rankIndexFromTop) {
        final rank = 7 - rankIndexFromTop; // convert to 0..7 bottom-up
        return Row(
          children: List.generate(8, (file) {
            return SizedBox(
              width: squareSize,
              height: squareSize,
              child: SquareWidget(file: file, rank: rank),
            );
          }),
        );
      }),
    );
  }
}
