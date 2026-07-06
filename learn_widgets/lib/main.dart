import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() {
    //print("create state");
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //print("initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //print("didChangaeDependency");
  }

  @override
  void didUpdateWidget(covariant MyApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    //print("Update Widgets");
  }

  @override
  void dispose() {
    super.dispose();
    //print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Wrap(
                        children: [
                          ListTile(
                            leading: Icon(Icons.share),
                            title: Text('Share'),
                          ),
                          ListTile(
                            leading: Icon(Icons.copy),
                            title: Text("Copy Link"),
                          ),
                          ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('edit'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  "Click hear",
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
