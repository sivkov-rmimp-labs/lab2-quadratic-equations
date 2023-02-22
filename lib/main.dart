import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

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
  bool isSolutionValid = true;

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
                  'Калькулятор квадратных уравнений',
                  style: TextStyle(fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize),
                ),
                TextField(
                  inputFormatters: [decimalInputFormatter],
                  decoration: const InputDecoration(labelText: 'Коэффициент a'),
                  onChanged: (value) {
                    setState(() {
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
                      if (value.isEmpty) {
                        c = 0;
                      } else {
                        c = double.parse(value);
                      }
                    });
                  },
                ),
                Text('${[
                  if (a != 0) '${a == 1 ? '' : a.toShortestString()}x$sup2',
                  if (b != 0) '${b == 1 ? '' : b.toShortestString()}x',
                  if (c != 0) c.toShortestString(),
                ].join(' + ').replaceAll("+ -", "- ").ifEmpty('0')} = 0'),
                MaterialButton(
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    setState(() {
                      if (a == 0 && b == 0) {
                        isSolutionValid = false;
                        if (c == 0) {
                          solution = 'Введенные коэффициенты не позволяют решить данное квадратное уравнение.'
                              '\nПри данных коэффициентах подходят любые иксы (так как 0 = 0 -- верное равенство).';
                        } else {
                          solution = 'Введенные коэффициенты не позволяют решить данное квадратное уравнение.'
                              '\nПри данных коэффициентах не подходит ни один икс (так как ${c.toShortestString()} = 0 -- всегда неверное равенство).';
                        }
                        return;
                      }

                      final d2 = b * b - 4 * a * c;

                      if (d2 < 0) {
                        isSolutionValid = false;
                        solution =
                            'Введенные коэффициенты не позволяют решить данное квадратное уравнение в действительных числах.'
                            '\nКвадрат дискриминанта равен ${d2.toShortestString()}. '
                            'Корень из отрицательного числа не определен в действительных числах.';
                        return;
                      }

                      isSolutionValid = true;
                      final d = sqrt(d2);
                      solution = 'Решение:';
                      solution += '\nD = sqrt(b^2 - 4ac) = '
                          'sqrt(${b.toShortestString()} ^ 2 - 4 * ${a.toShortestString()} * ${c.toShortestString()}) = '
                          'sqrt(${d2.toShortestString()}) = ${d.toShortestString()}';

                      if (d2 == 0) {
                        final x12 = -b / (2 * a);
                        solution += '\n\nДискриминант равен нулю, значит корень один:'
                            '\n\nx$sub1$sub2 = -b / 2a = ${b.toShortestStringWithFlippedSign()} / (2 * ${a.toShortestString()}) = '
                            '${x12.toShortestString()}';
                        answer = 'Ответ: x$sub1$sub2 = ${x12.toShortestString()}';
                      } else {
                        final x1 = (-b - d) / (2 * a);
                        final x2 = (-b + d) / (2 * a);
                        solution += '\n\nДискриминант не равен нулю, значит корня два:'
                            '\n\nx$sub1 = (-b - sqrt(D)) / 2a = (${b.toShortestStringWithFlippedSign()} - sqrt($d2)) / (2 * ${a.toShortestString()}) = '
                            '${x1.toShortestString()}'
                            '\n\nx$sub2 = (-b + sqrt(D)) / 2a = (${b.toShortestStringWithFlippedSign()} + sqrt($d2)) / (2 * ${a.toShortestString()}) = '
                            '${x2.toShortestString()}';
                        answer = 'Ответ: x$sub1 = ${x1.toShortestString()}, x$sub2 = ${x2.toShortestString()}';
                      }
                    });
                  },
                  child: const Text('Рассчитать решение'),
                ),
                Text(
                  solution,
                  style: isSolutionValid ? null : const TextStyle(color: Colors.red),
                ),
                Text(
                  isSolutionValid ? answer : '',
                  style: const TextStyle(fontSize: 20),
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
