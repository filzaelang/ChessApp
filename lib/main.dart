import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ChessApp());
}

// ===== Models =====

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

// ===== BoardModel (Provider) =====

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

// ===== Widgets =====

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chess Board UI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const ChessHomePage(),
      ),
    );
  }
}

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
