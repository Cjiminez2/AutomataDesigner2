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
      positions = [];
    });
  }

  List<Node> nodes = [];
  List<List<double>> positions = [];

  void _buildScreen() {
    nodes = [];
    for (int i = 0; i < positions.length; i++) {
      nodes.add(Node(top: positions[i][0], left: positions[i][1]));
    }
  }

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    _buildScreen();
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
                positions.add([position.dy-50, position.dx-50]);
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
            ignoring: false,
            child: GestureDetector(
              //TODO: Implement Line Drawing
              //Select which nodes is dragged
              onPanStart: (details) {
                var position = details.localPosition;
                var y = position.dy - 50;
                var x = position.dx - 50;
                for (int i = 0; i < positions.length; i++) {
                  if (nodes[i].containsPoint(x, y)) {
                    selectedIndex = i;
                    break;
                  }
                }
              },
              //Deselect when stopped dragging
              onPanEnd: (details) {
                selectedIndex = -1;
              },
              //Drag node
              onPanUpdate: (details) {
                if (selectedIndex != -1) {
                  positions[selectedIndex][0] += details.delta.dy;
                  positions[selectedIndex][1] += details.delta.dx;
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}