import 'package:flutter/material.dart';
import 'lobby_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tic-Tac-Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Local Game
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(local: true)),
                );
              },
              child: Text('Play Local'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Multiplayer Lobby
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LobbyScreen()),
                );
              },
              child: Text('Multiplayer'),
            ),
          ],
        ),
      ),
    );
  }
}
