import 'package:flutter/material.dart';
import 'base.dart';

class BoardModel extends ChangeNotifier {
  // 8x8 board: board[file][rank] -> file across, rank up (0 bottom)
  final List<List<Square>> board = List.generate(
    8,
    (file) => List.generate(8, (rank) => Square(file: file, rank: rank)),
  );

  // selected position
  Square? _selected;
  Square? get selected => _selected;

  BoardModel() {
    _setupInitialPosition();
  }

  void _setupInitialPosition() {
    // Clear first
    for (var f = 0; f < 8; f++) {
      for (var r = 0; r < 8; r++) {
        board[f][r].piece = null;
      }
    }

    // Helper to place
    void placeRow(int rank, PieceColor color, List<PieceType> types) {
      for (var file = 0; file < 8; file++) {
        board[file][rank].piece = Piece(
          type: types[file],
          color: color,
          symbol: _symbolFor(types[file], color),
        );
      }
    }

    // Pawns
    for (var f = 0; f < 8; f++) {
      board[f][1].piece = Piece(
        type: PieceType.pawn,
        color: PieceColor.white,
        symbol: _symbolFor(PieceType.pawn, PieceColor.white),
      );
      board[f][6].piece = Piece(
        type: PieceType.pawn,
        color: PieceColor.black,
        symbol: _symbolFor(PieceType.pawn, PieceColor.black),
      );
    }

    // Other pieces
    placeRow(0, PieceColor.white, [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ]);
    placeRow(7, PieceColor.black, [
      PieceType.rook,
      PieceType.knight,
      PieceType.bishop,
      PieceType.queen,
      PieceType.king,
      PieceType.bishop,
      PieceType.knight,
      PieceType.rook,
    ]);

    // Note: ranks 2..5 remain empty (indexes 2..5)
    notifyListeners();
  }

  String _symbolFor(PieceType t, PieceColor c) {
    // Unicode chess glyphs
    const white = {
      PieceType.king: '♔',
      PieceType.queen: '♕',
      PieceType.rook: '♖',
      PieceType.bishop: '♗',
      PieceType.knight: '♘',
      PieceType.pawn: '♙',
    };
    const black = {
      PieceType.king: '♚',
      PieceType.queen: '♛',
      PieceType.rook: '♜',
      PieceType.bishop: '♝',
      PieceType.knight: '♞',
      PieceType.pawn: '♟',
    };
    return (c == PieceColor.white) ? white[t]! : black[t]!;
  }

  // Select or move logic:
  void tapSquare(int file, int rank) {
    final tapped = board[file][rank];
    if (_selected == null) {
      // select if there's a piece
      if (tapped.piece != null) {
        _selected = tapped;
        notifyListeners();
      }
    } else {
      // if same square => deselect
      if (_selected!.file == file && _selected!.rank == rank) {
        _selected = null;
        notifyListeners();
        return;
      }
      // Attempt move (simple: allow move to empty or capture opposite color)
      final from = _selected!;
      final to = tapped;
      if (from.piece != null) {
        final movingPiece = from.piece!;
        final targetPiece = to.piece;
        // simple rule: can't capture same color
        if (targetPiece == null || targetPiece.color != movingPiece.color) {
          to.piece = movingPiece;
          from.piece = null;
        }
      }
      _selected = null;
      notifyListeners();
    }
  }

  // Utility to get square
  Square squareAt(int file, int rank) => board[file][rank];

  // Reset board
  void reset() {
    _setupInitialPosition();
  }
}
