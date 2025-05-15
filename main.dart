import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '';

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        result = '';
      } else if (value == '=') {
        try {
          result = evaluateExpression(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  String evaluateExpression(String expr) {
    expr = expr.replaceAll('×', '*').replaceAll('÷', '/');
    List<String> operators = [];
    List<double> numbers = [];

    int i = 0;
    while (i < expr.length) {
      String char = expr[i];
      if ('+-*/'.contains(char)) {
        operators.add(char);
        i++;
      } else {
        int start = i;
        while (i < expr.length && !'+-*/'.contains(expr[i])) i++;
        numbers.add(double.parse(expr.substring(start, i)));
      }
    }

    double res = numbers[0];
    for (int j = 0; j < operators.length; j++) {
      if (operators[j] == '+') res += numbers[j + 1];
      if (operators[j] == '-') res -= numbers[j + 1];
      if (operators[j] == '*') res *= numbers[j + 1];
      if (operators[j] == '/') res /= numbers[j + 1];
    }

    return res.toString();
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '7',
      '8',
      '9',
      '/',
      '4',
      '5',
      '6',
      '*',
      '1',
      '2',
      '3',
      '-',
      'C',
      '0',
      '=',
      '+',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input,
                      style: TextStyle(fontSize: 36, color: Colors.white)),
                  SizedBox(height: 10),
                  Text(result,
                      style:
                          TextStyle(fontSize: 28, color: Colors.greenAccent)),
                ],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.all(12),
            itemCount: buttons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final button = buttons[index];
              final isOperator = "+-*/".contains(button);
              final isControl = button == '=' || button == 'C';

              return ElevatedButton(
                onPressed: () => buttonPressed(button),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isControl
                      ? Colors.redAccent
                      : isOperator
                          ? Colors.blueAccent
                          : Colors.grey[850],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(20),
                ),
                child: Text(
                  button,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
