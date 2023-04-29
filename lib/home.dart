import 'dart:async';

import 'package:bird_game/barriers.dart';
import 'package:bird_game/bird.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birYaxis = 0;
  double time = 0;
  double height = 0;
  late int score = 0;
  late int bestScore = 0;
  double initialHeight = birYaxis;
  bool gameHasSrated = false;
  static double barriersXone = 2;
  double barriersXtwo = barriersXone + 1.5;

  void jump() {
    setState(() {
      time = 0;
      score += 1;
      initialHeight = birYaxis;
    });
    if (score >= bestScore) {
      bestScore = score;
    }
  }

  void startGame() {
    gameHasSrated = true;
    score = 0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birYaxis = initialHeight - height;

        setState(() {
          if (barriersXone < -1.1) {
            barriersXone += 2.2;
          } else {
            barriersXone -= 0.05;
          }
        });
        bool BirdIsDead() {
          if (birYaxis > 1 || birYaxis < -1) {
            return true;
          }
          return false;
        }

        setState(() {
          if (barriersXtwo < -1.1) {
            barriersXtwo += 2.2;
          } else {
            barriersXtwo -= 0.05;
          }
        });
        if (BirdIsDead()) {
          timer.cancel();
          _showDialog();
        }
      });
      if (birYaxis > 1) {
        timer.cancel();
        gameHasSrated = false;
      }
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birYaxis = 0;
      gameHasSrated = false;
      time = 0;
      initialHeight = birYaxis;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Center(
              child: Image.asset(
                'assets/images/game-over.png',
                width: 190,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.white,
                    child: const Text(
                      '   Start Again  ',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasSrated) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.lightBlueAccent,
                    child: const Bird(),
                  ),
                  Container(
                    alignment: const Alignment(0, -0.59),
                    child: gameHasSrated
                        ? const Text('')
                        : Image.asset('assets/images/play.png'),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barriersXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barriersXone, -1.3),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barriersXtwo, 1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barriersXtwo, -1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 250.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.amberAccent,
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Image.asset(
                          'assets/images/score.png',
                          width: 80,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const Text(
                          'SCORE',
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          score.toString(),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Image.asset(
                          'assets/images/top.png',
                          width: 78,
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          bestScore.toString(),
                          style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
