import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Highscore extends StatefulWidget {
  const Highscore({super.key});

  @override
  State<Highscore> createState() => _HighscoreState();
}

class _HighscoreState extends State<Highscore> {
  List<Map<String, dynamic>> topScores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedScores = prefs.getStringList("highscores") ?? [];

    List<Map<String, dynamic>> parsedScores = [];

    for (String data in savedScores) {
      List<String> parts = data.split('|');
      if (parts.length == 2) {
        // simpan ke list skor pemain
        parsedScores.add({
          'name': parts[0],
          'score': int.tryParse(parts[1]) ?? 0,
        });
      }
    }

    parsedScores.sort((a, b) => b['score'].compareTo(a['score']));

    // ambil top 5 skor
    if (parsedScores.length > 5) {
      parsedScores = parsedScores.sublist(0, 5);
    }

    setState(() {
      topScores = parsedScores;
      isLoading = false;
    });
  }

  Widget _buildRankIcon(int index) {
    //ikon seperti medali emas perak perunggu buat peringkat 1 2 3
    if (index == 0) {
      return const CircleAvatar(
        backgroundColor: Colors.amber,
        child: Text('1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else if (index == 1) {
      return CircleAvatar(
        backgroundColor: Colors.grey[400],
        child: const Text('2', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    } else if (index == 2) {
      return const CircleAvatar(
        backgroundColor: Colors.brown,
        child: Text('3', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }
    return CircleAvatar(child: Text('${index + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 5 High Scores'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : topScores.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada skor yang tersimpan.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: topScores.length,
                    itemBuilder: (context, index) {
                      final item = topScores[index];
                      // animasi kartu top 5 sliding keatas
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: 1),
                        duration: Duration(milliseconds: 400 + (index * 200)),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 50 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: child,
                            ),
                          );
                        },
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: _buildRankIcon(index),
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              "${item['score']} Pts",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
