import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/board_model.dart';
import 'presentation/chess_home_page.dart';

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
