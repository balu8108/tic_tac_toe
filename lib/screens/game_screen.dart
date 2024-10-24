import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameScreen extends StatefulWidget {
  final bool local;
  final String? gameId;

  GameScreen({required this.local, this.gameId});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.generate(9, (_) => "");
  bool xTurn = true;
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    if (!widget.local && widget.gameId != null) {
      _startListeningToGame(widget.gameId!);
    }
  }

  void _startListeningToGame(String gameId) {
    FirestoreService().getGameStream(gameId).listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          board = List<String>.from(snapshot['board']);
          xTurn = snapshot['xTurn'];
        });

        if (snapshot['winner'] != null && snapshot['winner'] != "") {
          _showWinnerDialog(snapshot['winner']);
          gameEnded = true;
        } else if (_isDraw()) {
          _showWinnerDialog("No one");
          gameEnded = true;
        }
      }
    });
  }

  bool _isDraw() {
    return board.every((element) => element.isNotEmpty) && !gameEnded;
  }

  void playMove(int index) {
    if (board[index] == "" && !gameEnded) {
      setState(() {
        board[index] = xTurn ? "X" : "O";
        xTurn = !xTurn;
      });

      if (!widget.local && widget.gameId != null) {
        String? winner = _determineWinner();
        if (winner != null) {
          FirestoreService().declareWinner(widget.gameId!, winner);
        } else {
          FirestoreService().updateGame(widget.gameId!, board, xTurn);
        }

        if (_isDraw()) {
          FirestoreService().declareWinner(widget.gameId!, "No one");
        }
      } else if (widget.local) {
        _checkWinnerLocally();
      }
    }
  }

  void _checkWinnerLocally() {
    String? winner = _determineWinner();
    if (winner != null) {
      _showWinnerDialog(winner);
      gameEnded = true;
    } else if (_isDraw()) {
      _showWinnerDialog("No one");
      gameEnded = true;
    }
  }

  String? _determineWinner() {
    List<List<int>> winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (var pattern in winPatterns) {
      if (board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]] &&
          board[pattern[0]] != "") {
        return board[pattern[0]];
      }
    }

    return null;
  }

  void _showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(winner == "No one"
              ? 'It\'s a Draw!'
              : '$winner Wins!'),
          actions: [
            TextButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      board = List.generate(9, (_) => "");
      xTurn = true;
      gameEnded = false;
    });

    if (!widget.local && widget.gameId != null) {
      FirestoreService().updateGame(widget.gameId!, board, xTurn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.local ? 'Local Game' : 'Multiplayer Game')),
      body: Center(  // Center the entire board
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Board(board: board, onTileTap: playMove),
          ],
        ),
      ),
    );
  }
}
