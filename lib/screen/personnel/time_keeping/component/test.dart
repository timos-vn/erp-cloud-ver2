import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollPhysics physics = const AlwaysScrollableScrollPhysics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        // Add the scroll physics controller here
        physics: physics,
        children: [
          for (int i = 0; i < 20; i++) ...[
            // Wrap the Widget with GestureDetector
            GestureDetector(
              // Disable the scroll behavior when users tap down
              onTapDown: (_) {
                setState(() {
                  physics = const NeverScrollableScrollPhysics();
                });
              },
              // Enable the scroll behavior when user leave
              onTapCancel: () {
                setState(() {
                  physics = const AlwaysScrollableScrollPhysics();
                });
              },
              onPanUpdate: (details) {
                // Catch the swip up action.
                if (details.delta.dy < 0) {
                  print('Swipping up the element $i');
                }
                // Catch the swip down action.
                if (details.delta.dy > 0) {
                  print('Swipping down the element $i');
                }
              },
              // Your image widget here
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.red,
                ),
              ),
            ),
            Center(child: Text('Element $i')),
          ],
        ],
      ),
    );
  }
}