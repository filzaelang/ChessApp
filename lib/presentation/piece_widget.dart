import 'package:flutter/material.dart';
import '../data/models/base.dart';

class PieceWidget extends StatelessWidget {
  final Piece piece;
  const PieceWidget({required this.piece, super.key});

  @override
  Widget build(BuildContext context) {
    // Scale text relative to device pixel ratio / screen
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        piece.symbol,
        semanticsLabel: '${piece.color} ${piece.type}',
        style: TextStyle(
          fontSize: 40,
          height: 1,
          // white pieces dark text, black pieces lighter text for contrast
          color: (piece.color == PieceColor.white)
              ? Colors.black87
              : Colors.black,
          shadows: const [
            Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 1)),
          ],
        ),
      ),
    );
  }
}
