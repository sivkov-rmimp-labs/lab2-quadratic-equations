import 'package:flutter/material.dart';

class AdvancedSolution extends StatelessWidget {
  final String solution;
  final String answer;

  const AdvancedSolution({Key? key, required this.solution, required this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Детализация решения'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              solution,
              style: const TextStyle(fontSize: 18),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                answer,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
