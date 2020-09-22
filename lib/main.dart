import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MainPage> {
  String firstNumber = '';
  String secondNumber = '';
  String operationString = '';
  Operation operation;
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Calculator')),
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 10),
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.centerRight,
                child: Text(
                  '$operationString',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 24),
                )),
            Container(
                margin: EdgeInsets.only(right: 10),
                height: MediaQuery.of(context).size.height * 0.1,
                alignment: Alignment.centerRight,
                child: Text(
                  '$result',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )),
          ],
        ),
        bottomSheet: Container(
            child: Table(children: <TableRow>[
          TableRow(children: [
            getButton(false, 'C', color: Colors.redAccent, onPress: onClear),
            getButton(false, '(', color: Colors.blueAccent, onPress: () {}),
            getButton(false, ')', color: Colors.blueAccent, onPress: () {}),
            getButton(false, '⌫', color: Colors.lightBlueAccent, onPress: onClearLast),
          ]),
          TableRow(children: [
            getButton(true, '7'),
            getButton(true, '8'),
            getButton(true, '9'),
            getButton(false, '+', color: Colors.blueAccent, onPress: () {
              onOperatorClicked(Operation.ADDITION);
            }),
          ]),
          TableRow(children: [
            getButton(true, '4'),
            getButton(true, '5'),
            getButton(true, '6'),
            getButton(false, '-', color: Colors.blueAccent, onPress: () {
              onOperatorClicked(Operation.SUBTRACTION);
            }),
          ]),
          TableRow(children: [
            getButton(true, '1'),
            getButton(true, '2'),
            getButton(true, '3'),
            getButton(false, '×', color: Colors.blueAccent, onPress: () {
              onOperatorClicked(Operation.MULTIPLICATION);
            }),
          ]),
          TableRow(children: [
            getButton(false, '.', onPress: onDotClicked),
            getButton(false, '0', onPress: onZeroClicked),
            getButton(false, '=', onPress: onEqualsClicked),
            getButton(false, '÷', color: Colors.blueAccent, onPress: () {
              onOperatorClicked(Operation.DIVISION);
            }),
          ])
        ])));
  }

  Widget getButton(bool appender, String text, {Color color = Colors.grey, Function onPress}) {
    return Padding(
        padding: EdgeInsets.all(1),
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: FlatButton(
              child: Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: appender
                  ? () {
                      setState(() {
                        if (operation == null) {
                          firstNumber += text;
                        } else {
                          secondNumber += text;
                          evaluateOperation();
                        }
                        operationString += text;
                      });
                    }
                  : onPress,
              color: color,
              shape: BeveledRectangleBorder(),
            )));
  }

  void onClear() {
    setState(() {
      operationString = '';
      result = '';
      firstNumber = '';
      secondNumber = '';
      operation = null;
    });
  }

  void onClearLast() {
    setState(() {
      operationString = operationString.substring(0, operationString.length - 1);
      if (operation == null && firstNumber.length > 0) {
        firstNumber = firstNumber.substring(0, firstNumber.length - 1);
      } else {
        if (secondNumber != '') {
          if (secondNumber.length == 1) {
            String secondNumberBefore = secondNumber;
            secondNumber = secondNumber.substring(0, secondNumber.length - 1);
            if (operation == Operation.ADDITION) {
              result = (double.parse(result) - double.parse(secondNumberBefore)).toString();
            } else if (operation == Operation.SUBTRACTION) {
              result = (double.parse(result) + double.parse(secondNumberBefore)).toString();
            } else if (operation == Operation.MULTIPLICATION) {
              result = (double.parse(result) / double.parse(secondNumberBefore)).toString();
            } else if (operation == Operation.DIVISION) {
              result = (double.parse(result) * double.parse(secondNumberBefore)).toString();
            }
          } else {
            String secondNumberBefore = secondNumber;
            secondNumber = secondNumber.substring(0, secondNumber.length - 1);
            if (operation == Operation.ADDITION) {
              result = (double.parse(result) - double.parse(secondNumberBefore)).toString();
              result = (double.parse(result) + double.parse(secondNumber)).toString();
            } else if (operation == Operation.SUBTRACTION) {
              result = (double.parse(result) + double.parse(secondNumberBefore)).toString();
              result = (double.parse(result) - double.parse(secondNumber)).toString();
            } else if (operation == Operation.MULTIPLICATION) {
              result = (double.parse(result) / double.parse(secondNumberBefore)).toString();
              result = (double.parse(result) * double.parse(secondNumber)).toString();
            } else if (operation == Operation.DIVISION) {
              result = (double.parse(result) * double.parse(secondNumberBefore)).toString();
              result = (double.parse(result) / double.parse(secondNumber)).toString();
            }
          }
        }
      }
      if (firstNumber == '' && secondNumber == '') onClear();
    });
  }

  void onZeroClicked() {
    setState(() {
      if (operation == null && firstNumber != '0')
        firstNumber += '0';
      else if (secondNumber.contains('0')) secondNumber += '0';
      operationString += '0';
    });
  }

  void onDotClicked() {
    setState(() {
      if (operation == null) {
        if (firstNumber == '') {
          firstNumber += '0.';
          operationString += '0.';
        } else if (!firstNumber.contains('.')) {
          firstNumber += '.';
          operationString += '.';
        }
      } else {
        if (secondNumber == '') {
          secondNumber += '0.';
          operationString += '0.';
        } else if (!secondNumber.contains('.')) {
          secondNumber += '.';
          operationString += '.';
        }
      }
    });
  }

  void evaluateOperation() {
    setState(() {
      if (operation == Operation.DIVISION)
        result = (double.parse(firstNumber) / double.parse(secondNumber)).toString();
      else if (operation == Operation.MULTIPLICATION)
        result = (double.parse(firstNumber) * double.parse(secondNumber)).toString();
      else if (operation == Operation.ADDITION) {
        result = (double.parse(firstNumber) + double.parse(secondNumber)).toString();
      } else if (operation == Operation.SUBTRACTION)
        result = (double.parse(firstNumber) - double.parse(secondNumber)).toString();
      firstNumber = result;
    });
  }

  void onEqualsClicked() {
    setState(() {
      operation = null;
      firstNumber = result;
      secondNumber = '';
      operationString = result;
      result = '';
    });
  }

  void onOperatorClicked(Operation operation) {
    setState(() {
      if (operationString != '') {
        this.operation = operation;
        secondNumber = '';
        operationString += getOperatorString(operation);
      }
    });
  }
}

enum Operation { ADDITION, SUBTRACTION, MULTIPLICATION, DIVISION }

getOperatorString(Operation operation) {
  if (operation == Operation.ADDITION) return '+';
  if (operation == Operation.SUBTRACTION) return '-';
  if (operation == Operation.MULTIPLICATION) return '×';
  if (operation == Operation.DIVISION) return '÷';
}
