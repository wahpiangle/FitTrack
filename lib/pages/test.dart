import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_project/constants/apple_watch_methods_enums.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int _counter = 0;
  final channel = const MethodChannel('com.example.fittrack');

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
    channel.invokeMethod(AppleWatchMethods.flutterToWatch,
        {"method": "sendCounterToNative", "data": _counter});
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
        title: const Text("Title"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
