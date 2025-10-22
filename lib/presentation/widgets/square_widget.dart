import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/board_model.dart';
import 'piece_widget.dart';

class SquareWidget extends StatelessWidget {
  final int file;
  final int rank;

  const SquareWidget({required this.file, required this.rank, super.key});

  Color _squareBaseColor(int file, int rank, BuildContext context) {
    final isLight = ((file + rank) % 2 == 0);
    final dark = Theme.of(context).colorScheme.primary.withOpacity(0.12);
    final light = Theme.of(context).colorScheme.surfaceVariant;
    return isLight ? light : dark;
  }

  @override
  Widget build(BuildContext context) {
    final board = Provider.of<BoardModel>(context);
    final sq = board.squareAt(file, rank);
    final selected = board.selected;
    final isSelected =
        selected != null && selected.file == file && selected.rank == rank;

    // highlight candidate destination (simple: highlight if selected exists and target is different)
    final isPotentialDestination =
        selected != null && !(selected.file == file && selected.rank == rank);

    return GestureDetector(
      onTap: () => board.tapSquare(file, rank),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _squareBaseColor(file, rank, context),
          border: isSelected
              ? Border.all(color: Colors.orangeAccent.shade700, width: 3)
              : null,
        ),
        child: Stack(
          children: [
            // optional subtle destination highlight
            if (isPotentialDestination)
              Positioned.fill(
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: 0.06,
                    duration: const Duration(milliseconds: 160),
                    child: Container(color: Colors.yellowAccent),
                  ),
                ),
              ),
            // coordinates label (small)
            Positioned(
              left: 4,
              bottom: 4,
              child: Text(
                '${String.fromCharCode('a'.codeUnitAt(0) + file)}${rank + 1}',
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ),
            // piece centered
            if (sq.piece != null) Center(child: PieceWidget(piece: sq.piece!)),
          ],
        ),
      ),
    );
  }
}
