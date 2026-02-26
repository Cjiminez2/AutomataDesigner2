import 'package:flutter/material.dart';
import "node.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MovableNodeScreen(),
    );
  }
}

class MovableNodeScreen extends StatefulWidget {
  const MovableNodeScreen({super.key});

  @override
  State<MovableNodeScreen> createState() => _MovableNodeScreenState();
}

class _MovableNodeScreenState extends State<MovableNodeScreen> {

  void _reset() {
    setState(() {
      nodes = [];
    });
  }

  List<Node> nodes = [];
  @override
  Widget build(BuildContext context) {
    //Might be needed for screen size
    //double screen_width = MediaQuery.of(context).size.width;    // Screen width
    //double screen_height = MediaQuery.of(context).size.height;  // Screen height
    return Scaffold(
      appBar: AppBar(
        title: const Text("Autamata Designer"),
      ),
      body: Stack(
        children: [
          GestureDetector(
            //Add node on double tap
            onDoubleTapDown: (details) {
              setState(() {
                var position = details.localPosition;
                nodes.add(
                  Node(
                      //-50 is for the center of the cursor
                      top: position.dy-50,
                      left: position.dx-50
                  )
                );
              });
            },
            onLongPress: () => _reset(),
          ),
          Stack(
            children: nodes,
          ),
          /*
          TODO:
          Rework this to be toggles on
          by a floating point button.
          Useless as of current
           */
          IgnorePointer(
            ignoring: true,
            child: GestureDetector(
              //TODO: Implement Line Drawing
            ),
          ),
        ],
      ),
    );
  }
}