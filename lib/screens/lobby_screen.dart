import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'game_screen.dart';

class LobbyScreen extends StatefulWidget {
  @override
  _LobbyScreenState createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  String? gameId;
  String playerName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Multiplayer Lobby')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter your name'),
              onChanged: (value) {
                playerName = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newGameId = await _firestoreService.createGame(playerName);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Game Created'),
                    content: Text('Share this Game ID with a friend: $newGameId'),
                    actions: [
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(local: false, gameId: newGameId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
              child: Text('Create Game'),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: 'Enter Game ID to join'),
              onChanged: (value) {
                gameId = value;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (gameId != null && gameId!.isNotEmpty) {
                  await _firestoreService.joinGame(gameId!, playerName);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(local: false, gameId: gameId!),
                    ),
                  );
                }
              },
              child: Text('Join Game'),
            ),
          ],
        ),
      ),
    );
  }
}
