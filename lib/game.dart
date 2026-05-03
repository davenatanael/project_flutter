import 'package:flutter/material.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:project_uts/class/game_round.dart';
import 'package:project_uts/hasil.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  //variabel
  late Timer _timer;
  List<GameRound> _rounds = []; //list untuk tracking sudah berjalan berapa round
  
  bool memorizing = true; //(apakah sedang menghafalkan gambar) selalu dimulai true karena setiap mulai game akan menghafal gambar
  int _indexRound = 0;
  int _score = 0; //initial value score
  int _correct = 0; //initial value tebakan yang benar

  int _timeLeft = 3;
  int _maxTime = 3;

  @override
  void initState() {
    super.initState();
    
    _rounds.add(GameRound(
      'assets/images/bird_1.png',
      ['assets/images/bird_2.png', 'assets/images/bird_3.png', 'assets/images/bird_4.png', 'assets/images/bird_1.png'],
      'assets/images/bird_1.png'
    ));
    _rounds.add(GameRound(
      'assets/images/block_1.png',
      ['assets/images/block_2.png', 'assets/images/block_3.png', 'assets/images/block_1.png', 'assets/images/block_4.png'],
      'assets/images/block_1.png'
    ));
    _rounds.add(GameRound(
      'assets/images/metal_1.png',
      ['assets/images/metal_2.png', 'assets/images/metal_1.png', 'assets/images/metal_3.png', 'assets/images/metal_4.png'],
      'assets/images/metal_1.png'
    ));
    _rounds.add(GameRound(
      'assets/images/shield_01.png',
      ['assets/images/shield_01.png', 'assets/images/shield_02.png', 'assets/images/shield_03.png', 'assets/images/shield_04.png'],
      'assets/images/shield_01.png'
    ));
    _rounds.add(GameRound(
      'assets/images/wood_1.png',
      ['assets/images/wood_2.png', 'assets/images/wood_1.png', 'assets/images/wood_3.png', 'assets/images/wood_4.png'],
      'assets/images/wood_1.png'
    ));

    _rounds.shuffle();

    for (var round in _rounds) {
      round.options.shuffle();
    }

    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          if (memorizing == true) { //KALAU SEDANG MENGHAFAL GAMBAR
            if (_indexRound < _rounds.length - 1) {
              _indexRound++; //menambah index agar setelah gambar ke5 stop
              _timeLeft = 3; //SET TIMER 3 DETIK
            } else {
              memorizing = false; //setelah index 4 (setelah 5 round), set memorizing ke false agar tidak masuk ke if memorizing == true
              _indexRound = 0;
              _maxTime = 30;
              _timeLeft = 30;
            }
          } else {
            nextQuestion();
          }
        }
      });
    });
  }

  void nextQuestion() {
    if (_indexRound >= _rounds.length - 1) {
      endGame();
    } else {
      _indexRound++;
      _maxTime = 30;
      _timeLeft = 30;
    }
  }

  void checkAnswer(String selectedOption) {
    if (selectedOption == _rounds[_indexRound].correctAnswer) {
      _score += _timeLeft;
      _correct++;
    }
    nextQuestion();
  }

  void endGame() {
    _timer.cancel();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Hasil(
          score: _score,
          correct: _correct,
          totalQuestions: _rounds.length,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memorimage')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                memorizing == true 
                    ? "Hafalkan gambar ini! (${_indexRound + 1}/${_rounds.length})" 
                    : "Mana gambar yang benar? (${_indexRound + 1}/${_rounds.length})",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CircularPercentIndicator(
                radius: 60.0,
                lineWidth: 10.0,
                percent: _timeLeft / _maxTime,
                center: Text("$_timeLeft s", style: const TextStyle(fontSize: 20)),
                progressColor: memorizing ? Colors.blue : Colors.red,
              ),
              const SizedBox(height: 30),
              if (memorizing)
                Image.asset(
                  _rounds[_indexRound].targetImage,
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                )
              else
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  alignment: WrapAlignment.center,
                  children: _rounds[_indexRound].options.map((option) {
                    return GestureDetector(
                      onTap: () => checkAnswer(option),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            option,
                            height: 140,
                            width: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}