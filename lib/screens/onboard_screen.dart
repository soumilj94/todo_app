import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/screens/home_screen.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _onboardUI(),
            _text(),
            _button(context),
          ],
        ),
      ),
    );
  }

  Widget _onboardUI() {
    return Center(
      child: Lottie.asset(
        "assets/animation/hello.json",
        repeat: true,
        animate: true,
        reverse: true,
        height: 350,
        width: 350,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _text() {
    return const Text(
      "Welcome",
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w100,
      ),
    );
  }

  Widget _button(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: purple,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: IconButton(
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('seenOnboarding', true);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
          color: white,
          icon: const Icon(Icons.arrow_forward, size: 40),
        ),
      ),
    );
  }
}
