import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int _counter = 0;
  final channel = MethodChannel('com.example.fittrack');

  @override
  void initState() {
    super.initState();
    _initFlutterChannel();
  }

  Future<void> _initFlutterChannel() async {
    channel.setMethodCallHandler((call) async {
      // Receive data from Native
      switch (call.method) {
        case "sendCounterToFlutter":
          _counter = call.arguments["data"]["counter"];
          _incrementCounter();
          break;
        default:
          break;
      }
    });
    channel.invokeMethod(
        "flutterToWatch", {"method": "sendCounterToNative", "data": _counter});
  }

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await channel.invokeMethod(
        "flutterToWatch", {"method": "sendCounterToNative", "data": _counter});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
