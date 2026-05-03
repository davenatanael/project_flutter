import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final int correctGuesses;
  final int totalGuesses;

  const ResultScreen({
    super.key,
    required this.score,
    required this.correctGuesses,
    required this.totalGuesses,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String title = "";
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _determineTitle();
    _checkAndSaveHighScore();
  }

  void _determineTitle() {
    switch (widget.correctGuesses) {
      case 5:
        title = "Maestro dell'Indovinello (Master of Riddles)";
        break;
      case 4:
        title = "Esperto dell'Indovinello (Expert of Riddles)";
        break;
      case 3:
        title = "Abile Indovinatore (Skillful Guesser)";
        break;
      case 2:
        title = "Principiante dell'Indovinello (Riddle Beginner)";
        break;
      case 1:
        title = "Neofita dell'Indovinello (Riddle Novice)";
        break;
      case 0:
      default:
        title = "Sfortunato Indovinatore (Unlucky Guesser)";
        break;
    }
  }

  Future<void> _checkAndSaveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> highscores = prefs.getStringList("highscores") ?? [];
    
    // langsung tambahkan setiap skor ke daftar di menu high score
    highscores.add("$active_user|${widget.score}");
    await prefs.setStringList("highscores", highscores);

    if (mounted) {
      setState(() {
        highScore = widget.score;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layar Hasil'),
        automaticallyImplyLeading: false, 
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Permainan Selesai!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Text(
                "Skor Anda: ${widget.score}",
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 10),
              Text(
                "Tebakan Benar: ${widget.correctGuesses} dari ${widget.totalGuesses}",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 30),
              const Text(
                "Gelar Anda:",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 5),
              // animasi popping waktu gelar muncul
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.5, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, scale, child) {
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, 'game');
                },
                child: const Text("Play Again", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () {
                  Navigator.pushNamed(context, 'highscore');
                },
                child: const Text("High Scores", style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text("Main Menu", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
