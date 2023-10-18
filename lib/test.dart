import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  num _resultA = 0;

  num _resultD = 0;

  num _resultM = 0;

  num _resultS = 0;

  final number1 = TextEditingController();

  final number2 = TextEditingController();

  int? _addition(num a, num b) {
    setState(() {
      _resultA = a + b;
    });
    return null;
  }

  int? _subtraction(num a, num b) {
    setState(() {
      _resultS = a - b;
    });
    return null;
  }

  num? _division(num a, num b) {
    setState(() {
      if (b != 0) {
        _resultD = a / b;
      } else {
        _resultD = 0;
      }
    });
    return null;
  }

  int? _multiplication(num a, num b) {
    setState(() {
      _resultM = a * b;
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(width: 2.0),
        borderRadius: const BorderRadius.all(Radius.circular(10.0)
            //                 <--- border radius here

            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w900,
              fontSize: 20),
        ),
      ),

      body: Center(
        child: Column(
          children: [
            Center(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          maxLines: 1,
                          maxLength: 2,
                          controller: number1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'first number',
                            hintText: 'Enter first number',
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      width: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          obscureText: true,
                          controller: number2,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Second number',
                            hintText: 'Enter Second number',
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'the result of addition is : $_resultA',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'the result of Subtraction is :  $_resultS ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'the result of Multiplication is : $_resultM',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'the result of Division is :$_resultD ',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      child: TextButton(
                        onPressed: () {
                          var num1 = num.parse(number1.text);

                          var num2 = num.parse(number2.text);

                          _addition(num1, num2);
                        },
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),
                    ),

                    //Text('Add')),

                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      child: TextButton(
                        onPressed: () {
                          var num1 = num.parse(number1.text);

                          var num2 = num.parse(number2.text);

                          _subtraction(num1, num2);
                        },
                        child: const Text(
                          "-",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      child: TextButton(
                        onPressed: () {
                          var num1 = num.parse(number1.text);

                          var num2 = num.parse(number2.text);

                          _division(num1, num2);
                        },
                        child: const Text(
                          "/",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: myBoxDecoration(),
                      child: TextButton(
                        onPressed: () {
                          var num1 = num.parse(number1.text);

                          var num2 = num.parse(number2.text);
                          _multiplication(num1, num2);
                        },
                        child: const Text(
                          "*",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 40,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
