import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscore extends StatefulWidget {
  const Highscore({super.key});

  @override
  State<Highscore> createState() => _HighscoreState();
}

class _HighscoreState extends State<Highscore> {
  List<String> _topScores = [];

  @override
  void initState() {
    super.initState();
    loadHighscore();
  }

  void loadHighscore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _topScores = prefs.getStringList('top_scores') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('High Score')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _topScores.isEmpty
            ? const Center(
                child: Text(
                  'Belum ada data High Score',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: _topScores.length,
                itemBuilder: (context, index) {
                  List<String> data = _topScores[index].split('|');
                  String nama = data[0];
                  String skor = data[1];

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Image.asset(
                        'assets/images/rank${index + 1}.png',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.emoji_events,
                          size: 40,
                          color: index == 0
                              ? Colors.amber
                              : index == 1
                                  ? Colors.grey
                                  : Colors.brown,
                        ),
                      ),
                      title: Text(
                        nama,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        skor,
                        style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}