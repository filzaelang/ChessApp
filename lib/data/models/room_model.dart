class Room {
  final String name;
  final String ip;
  final int players;
  final int maxPlayers;

  Room({
    required this.name,
    required this.ip,
    this.players = 1,
    this.maxPlayers = 2,
  });

  bool get canJoin => players < maxPlayers;
}
