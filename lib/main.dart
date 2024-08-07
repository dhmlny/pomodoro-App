// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: PomodoroApp(),
    );
  }
}

class PomodoroApp extends StatefulWidget {
  const PomodoroApp({super.key});

  @override
  State<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends State<PomodoroApp> {
  Timer? repeated;
  Duration duration = Duration(minutes: 25);
  bool isRunning = false;

  startTimer() {
    repeated = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        int newSecond = duration.inSeconds - 1;
        duration = Duration(seconds: newSecond);
        if (duration.inSeconds == 0) {
          timer.cancel();
          setState(() {
            duration = Duration(minutes: 25);
            isRunning = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 33, 40, 43),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 40, 43),
        title: Text(
          "Pomodoro App",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        shadowColor: Colors.white,
        elevation: 0.5,
      ),
      body: SizedBox(
        height: double.maxFinite,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  center: Text(
                    "${duration.inMinutes.remainder(60).toString().padLeft(2, "0")}:${duration.inSeconds.remainder(60).toString().padLeft(2, "0")} ",
                    style: TextStyle(
                      fontSize: 75,
                      color: Colors.white,
                    ),
                  ),
                  radius: 120,
                  progressColor: Colors.red[500],
                  lineWidth: 7,
                  percent: duration.inMinutes/25,
                  animation: true,
                  animateFromLastPercent: true,
                  animationDuration: 1000,
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            isRunning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red[500]),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(15)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: () {
                          setState(() {
                            if (repeated!.isActive) {
                              repeated!.cancel();
                            } else {
                              startTimer();
                            }
                          });
                        },
                        child: Text(
                          (repeated!.isActive) ? "Stop" : "Resume",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 22,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.red[500]),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(15)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: () {
                          repeated!.cancel();
                          setState(() {
                            duration = Duration(minutes: 25);
                            isRunning = false;
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.blue),
                      padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    onPressed: () {
                      startTimer();
                      setState(() {
                        isRunning = true;
                      });
                    },
                    child: Text(
                      "Start Studying",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
