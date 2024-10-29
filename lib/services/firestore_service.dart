import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a random 3-digit Game ID
  Future<String> _generateUniqueGameId() async {
    final random = Random();
    String gameId;
    bool isUnique = false;

    // Keep generating IDs until we find one that doesn't exist in Firestore
    do {
      gameId = (100 + random.nextInt(900)).toString(); // Generate 3-digit number
      final doc = await _firestore.collection('games').doc(gameId).get();
      isUnique = !doc.exists; // Check if the Game ID already exists
    } while (!isUnique);

    return gameId;
  }

  // Create a new game with a 3-digit Game ID
  Future<String> createGame(String playerX) async {
    String gameId = await _generateUniqueGameId();
    await _firestore.collection('games').doc(gameId).set({
      'board': List.generate(9, (index) => ""),
      'xTurn': true,
      'playerX': playerX,
      'playerO': "",
      'winner': null,
    });
    return gameId;
  }

  Future<String> resetGame(String gameId) async {
    await _firestore.collection('games').doc(gameId).update({
      'board': List.generate(9, (index) => ""),
      'xTurn': true,
      'playerO': "",
      'winner': null,
    });
    return gameId;
  }

  Future<void> joinGame(String gameId, String playerO) async {
    await _firestore.collection('games').doc(gameId).update({
      'playerO': playerO,
    });
  }

  Stream<DocumentSnapshot> getGameStream(String gameId) {
    return _firestore.collection('games').doc(gameId).snapshots();
  }

  Future<void> updateGame(String gameId, List<String> board, bool xTurn) async {
    await _firestore.collection('games').doc(gameId).update({
      'board': board,
      'xTurn': xTurn,
    });
  }

  Future<void> declareWinner(String gameId, String winner) async {
    await _firestore.collection('games').doc(gameId).update({
      'winner': winner,
    });
  }
}
