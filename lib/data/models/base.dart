enum PieceColor { white, black }

enum PieceType { king, queen, rook, bishop, knight, pawn }

class Piece {
  final PieceType type;
  final PieceColor color;
  final String symbol;

  const Piece({required this.type, required this.color, required this.symbol});
}

class Square {
  final int file; // 0..7 (a..h)
  final int rank; // 0..7 (1..8)
  Piece? piece;

  Square({required this.file, required this.rank, this.piece});
}
