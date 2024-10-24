import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  final List<String> board;
  final Function(int) onTileTap;

  Board({required this.board, required this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Fixed width for a minimalist look
      height: 300, // Fixed height for a minimalist look
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTileTap(index),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  board[index],
                  style: TextStyle(fontSize: 40, color: Colors.black), // Minimalist text styling
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
