import 'dart:async';

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  void resetTimer() => setState(() {
        seconds = maxSeconds;
      });
  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color.fromARGB(255, 175, 97, 154), Colors.white])),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildtimer(),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: _startButton(),
          )
        ],
      ),
    ));
  }

  _startButton() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == maxSeconds || seconds == 0;
    return isRunning || !isCompleted
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    if (isRunning) {
                      stopTimer(reset: false);
                    } else {
                      startTimer(reset: false);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(isRunning ? "Pause" : "Resume"),
                  )),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () {
                    stopTimer();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("Cancel"),
                  )),
            ],
          )
        : ElevatedButton(
            onPressed: () {
              startTimer();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Start Timer",
                style: TextStyle(color: Colors.black, fontSize: 19),
              ),
            ),
          );
  }

  Widget _timer() {
    return Text(
      "$seconds",
      style: const TextStyle(
          fontSize: 60, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _buildtimer() {
    if (seconds == 0) {
      return const Icon(
        Icons.task_alt,
        size: 112,
        color: Color.fromARGB(255, 86, 11, 148),
      );
    } else {
      return SizedBox(
          height: 200,
          width: 200,
          child: Stack(fit: StackFit.expand, children: [
            CircularProgressIndicator(
              value: 1 - seconds / maxSeconds,
              strokeWidth: 12,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              backgroundColor: const Color.fromARGB(255, 86, 11, 148),
            ),
            Center(child: _timer())
          ]));
    }
  }
}
