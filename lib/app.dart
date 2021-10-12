import 'package:flutter/material.dart';
import 'package:orb/app.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool showChat = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showChat) {
      return OrbApp();
    } else {
      return MaterialApp(
          title: 'Orb Demo',
          home: Scaffold(
              appBar: AppBar(
                title: const Text("Home"),
              ),
              body: Center(
                child: ElevatedButton(
                  child: const Text('Open chat'),
                  onPressed: () {
                    setState(() {
                      showChat = true;
                    });
                  },
                ),
              )));
    }
  }
}
