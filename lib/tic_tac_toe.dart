import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => TicTacToe();
}

class TicTacToe extends State<Game> {
  List<String> gridState = List.filled(9, "");
  List<List<int>> winningCombinations = [
    [0, 1, 2], // Ligne du haut
    [3, 4, 5], // Ligne du milieu
    [6, 7, 8], // Ligne du bas
    [0, 3, 6], // Colonne de gauche
    [1, 4, 7], // Colonne centrale
    [2, 5, 8], // Colonne de droite
    [0, 4, 8], // Diagonale de gauche à droite
    [2, 4, 6], // Diagonale de droite à gauche
  ];
  String currentPlayer = "X";
  List<int> winningCells = [];
  bool isGameOver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              resetGame();
            },
            tooltip: "Rejouer",
          ),
          IconButton(
            icon: const Icon(Icons.gamepad),
            onPressed: () {
              // Ajouter un événement personnalisé ici
            },
            tooltip: "Paramètres du jeu",
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Vous pouvez ouvrir les paramètres du jeu ici
            },
            tooltip: "Réglages",
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Titre dynamique
              if (!isGameOver)
                Text(
                  "C'est à ${currentPlayer} de jouer",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              if (isGameOver)
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    winningCells.isNotEmpty
                        ? "$currentPlayer a gagné 🎉"
                        : "Match nul 😐",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              // Grille de jeu avec padding ajouté
              Padding(
                padding: const EdgeInsets.all(16.0), // Ajout du padding
                child: Container(
                  width: 300,
                  height: 300,  // Limiter la hauteur ici
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: GridView.builder(
                    itemCount: 9,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          if (gridState[index] == "" && !isGameOver) {
                            setState(() {
                              gridState[index] = currentPlayer;
                              if (checkWinner(currentPlayer)) {
                                isGameOver = true;
                                Future.delayed(const Duration(seconds: 3), resetGame);
                              } else if (checkDraw()) {
                                isGameOver = true;
                                Future.delayed(const Duration(seconds: 3), resetGame);
                              } else {
                                currentPlayer = (currentPlayer == "X") ? "O" : "X";
                              }
                            });
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: winningCells.contains(index)
                                ? Colors.greenAccent.shade400
                                : Colors.transparent,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              gridState[index] == "X"
                                  ? Icons.cancel
                                  : gridState[index] == "O"
                                  ? Icons.radio_button_unchecked
                                  : null,
                              size: 70,
                              color: gridState[index] == "X"
                                  ? Colors.white
                                  : Colors.amberAccent,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }

  bool checkWinner(String player) {
    for (var combination in winningCombinations) {
      if (gridState[combination[0]] == player &&
          gridState[combination[1]] == player &&
          gridState[combination[2]] == player) {
        winningCells = combination; // Enregistrer les cases gagnantes
        return true;
      }
    }
    return false;
  }

  bool checkDraw() {
    return gridState.every((element) => element.isNotEmpty) && winningCells.isEmpty;
  }

  void resetGame() {
    setState(() {
      gridState = List.filled(9, ""); // Réinitialiser la grille
      currentPlayer = "X"; // Recommencer avec X
      winningCells = []; // Réinitialiser les cases gagnantes
      isGameOver = false; // Réinitialiser l'état de jeu
    });
  }
}
