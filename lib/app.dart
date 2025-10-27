import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/models/board_model.dart';
import 'data/services/room_provider.dart';
import 'presentation/screens/home_page.dart';
import 'presentation/screens/room_page.dart';
import 'package:go_router/go_router.dart';

class ChessApp extends StatelessWidget {
  const ChessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoardModel()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Chess Board UI',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home', // Optional
      path: '/',
      builder: (context, state) => RoomPage(),
    ),
    GoRoute(
      name: 'game',
      path: '/game',
      builder: (context, state) => ChessHomePage(),
    ),
  ],
);
