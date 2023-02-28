import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lab2_quadratic_equation/advanced_solution.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Лаб 2 Сивков',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '[РМиМП-1] Лаб 2 Сивков'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double a = 0;
  double b = 0;
  double c = 0;
  String solution = '';
  String answer = '';
  bool isSolved = false;

  /// Разрешает вводить отрицательные и положительные вещественные числа. Запрещает вводить невалидные символы.
  /// К примеру, ввести "-5.123.456" не удастся из-за второй точки.
  final decimalInputFormatter = FilteringTextInputFormatter.allow(RegExp(r'^-|-?\d+\.?\d*'));

  /// Символ квадрата (в степени 2)
  static const sup2 = '\u00B2';

  /// Субскрипт единички (индекс 1)
  static const sub1 = '\u2081';

  /// Субскрипт двойки (индекс 2)
  static const sub2 = '\u2082';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Решение квадратных уравнений',
                  style: TextStyle(fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
                ),
                TextField(
                  inputFormatters: [decimalInputFormatter],
                  decoration: const InputDecoration(labelText: 'Коэффициент a'),
                  onChanged: (value) {
                    setState(() {
                      isSolved = false;
                      if (value.isEmpty) {
                        a = 0;
                      } else {
                        a = double.parse(value);
                      }
                    });
                  },
                ),
                TextField(
                  inputFormatters: [decimalInputFormatter],
                  decoration: const InputDecoration(labelText: 'Коэффициент b'),
                  onChanged: (value) {
                    setState(() {
                      isSolved = false;
                      if (value.isEmpty) {
                        b = 0;
                      } else {
                        b = double.parse(value);
                      }
                    });
                  },
                ),
                TextField(
                  inputFormatters: [decimalInputFormatter],
                  decoration: const InputDecoration(labelText: 'Коэффициент c'),
                  onChanged: (value) {
                    setState(() {
                      isSolved = false;
                      if (value.isEmpty) {
                        c = 0;
                      } else {
                        c = double.parse(value);
                      }
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${[
                    if (a != 0) '${a == 1 ? '' : a.toShortestString()}x$sup2',
                    if (b != 0) '${b == 1 ? '' : b.toShortestString()}x',
                    if (c != 0) c.toShortestString(),
                  ].join(' + ').replaceAll("+ -", "- ").ifEmpty('0')} = 0'),
                ),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      isSolved = true;

                      if (a == 0 && b == 0) {
                        if (c == 0) {
                          solution =
                              'При данных коэффициентах подходят любые иксы (так как 0 = 0 -- верное равенство).';
                          answer = 'Ответ: x ∈ ℝ';
                        } else {
                          solution =
                              'При данных коэффициентах не подходит ни один икс (так как ${c.toShortestString()} = 0 -- всегда неверное равенство).';
                          answer = 'Ответ: x ∈ ∅';
                        }
                        return;
                      }

                      if (a == 0) {
                        final x = -c / b;
                        solution = 'Данное уравнение является линейным.'
                            '\n\nx = -c / b = ${c.toShortestStringWithFlippedSign()} / ${b.toShortestString()} = ${x.toShortestString()}';
                        answer = 'Ответ: x = ${x.toShortestString()}';
                        return;
                      }

                      final d2 = b * b - 4 * a * c;

                      if (d2 < 0) {
                        solution = 'D$sup2 = b^2 - 4ac = '
                            '${b.toShortestString()} ^ 2 - 4 * ${a.toShortestString()} * ${c.toShortestString()} = '
                            '${d2.toShortestString()}';
                        solution += '\nКвадрат дискриминанта равен ${d2.toShortestString()}. '
                            'Корень из отрицательного числа не определен в действительных числах.';
                        answer = 'Ответ: нет корней';
                        return;
                      }

                      final d = sqrt(d2);
                      solution = 'D = sqrt(b^2 - 4ac) = '
                          'sqrt(${b.toShortestString()} ^ 2 - 4 * ${a.toShortestString()} * ${c.toShortestString()}) = '
                          'sqrt(${d2.toShortestString()}) = ${d.toShortestString()}';

                      if (d2 == 0) {
                        final x12 = -b / (2 * a);
                        solution += '\n\nДискриминант равен нулю:'
                            '\n\nx$sub1 = x$sub2 = -b / 2a = ${b.toShortestStringWithFlippedSign()} / (2 * ${a.toShortestString()}) = '
                            '${x12.toShortestString()}';
                        answer = 'Ответ: x$sub1 = x$sub2 = ${x12.toShortestString()}';
                      } else {
                        final x1 = (-b - d) / (2 * a);
                        final x2 = (-b + d) / (2 * a);
                        solution += '\n\nДискриминант больше нуля:'
                            '\n\nx$sub1 = (-b - sqrt(D)) / 2a = (${b.toShortestStringWithFlippedSign()} - sqrt($d2)) / (2 * ${a.toShortestString()}) = '
                            '${x1.toShortestString()}'
                            '\n\nx$sub2 = (-b + sqrt(D)) / 2a = (${b.toShortestStringWithFlippedSign()} + sqrt($d2)) / (2 * ${a.toShortestString()}) = '
                            '${x2.toShortestString()}';
                        answer = 'Ответ: x$sub1 = ${x1.toShortestString()}, x$sub2 = ${x2.toShortestString()}';
                      }
                    });
                  },
                  child: const Text('Решить уравнение'),
                ),
                if (isSolved)
                  Text(
                    answer,
                    style: const TextStyle(fontSize: 20),
                  ),
                if (isSolved)
                  MaterialButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AdvancedSolution(
                              solution: solution,
                              answer: answer,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text('Показать детализацию решения'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension DoubleExtensions on double {
  String toShortestString() {
    return NumberFormat().format(this == 0 ? 0 : this); // Костыль чтобы избежать "-0"
  }

  String toShortestStringWithFlippedSign() {
    return (-this).toShortestString().replaceFirst('--', '');
  }
}

extension StringExtensions on String {
  String ifEmpty(String string) {
    if (isEmpty) return string;
    return this;
  }
}
