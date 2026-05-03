import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_uts/main.dart';
import 'package:project_uts/game.dart';

class Hasil extends StatefulWidget {
  //variabel, menggunakan final supaya value nya tidak bisa dirubah
  final int score;
  final int correct;
  final int totalQuestions;

  const Hasil({
    //required: layar hasil MEMBUTUHKAN value variabel ini dari layar sebelumnya (game)
    super.key,
    required this.score,
    required this.correct,
    required this.totalQuestions,
  });

  @override
  State<Hasil> createState() => _HasilState();
}

class _HasilState extends State<Hasil> {
  String _gelar = "";

  @override
  void initState() {
    //memanggil function" saat awal muncul
    super.initState();
    _tentukanGelar();
    _saveHighScore();
  }

  void _tentukanGelar() {
    if (widget.correct == 5) {
      _gelar = "Maestro dell'Indovinello (Master of Riddles)";
    } else if (widget.correct == 4) {
      _gelar = "Esperto dell'Indovinello (Expert of Riddles)";
    } else if (widget.correct == 3) {
      _gelar = "Abile Indovinatore (Skillful Guesser)";
    } else if (widget.correct == 2) {
      _gelar = "Principiante dell'Indovinello (Riddle Beginner)";
    } else if (widget.correct == 1) {
      _gelar = "Neofita dell'Indovinello (Riddle Novice)";
    } else {
      _gelar = "Sfortunato Indovinatore (Unlucky Guesser)";
    }
  }

  void _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> topScores = prefs.getStringList('top_scores') ?? [];

    topScores.add("$active_user|${widget.score}");

    topScores.sort((a, b) {
      int scoreA = int.parse(a.split('|')[1]);
      int scoreB = int.parse(b.split('|')[1]);
      return scoreB.compareTo(scoreA);
    });

    if (topScores.length > 3) {
      topScores = topScores.sublist(0, 3);
    }

    prefs.setStringList('top_scores', topScores);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Permainan')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Skor Akhir: ${widget.score}",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Berhasil menjawab ${widget.correct} dari ${widget.totalQuestions} tebakan.",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text("Gelar Anda:", style: const TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                _gelar,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 40)),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Permainan()),
                );
              },
              child: const Text("Play Again"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 40)),
              onPressed: () {
                Navigator.pushNamed(context, 'highscore');
              },
              child: const Text("High Scores"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 40)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Main Menu"),
            ),
          ],
        ),
      ),
    );
  }
}
