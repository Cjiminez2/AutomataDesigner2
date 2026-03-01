import 'package:flutter/material.dart';
import "node.dart";
import "line.dart";

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
      lineIndices = [];
    });
  }

  List<Node> nodes = [];
  List<List<double>> positions = [];

  List<CustomPaint> lines = [];
  List<List<int>> lineIndices = [];

  //List<Widget> nodesAndLines = [];

  void _buildScreen() {
    nodes = [];
    lines = [];
    for (int i = 0; i < positions.length; i++) {
      nodes.add(Node(left: positions[i][0], top: positions[i][1]));
    }

    for (int i = 0; i < lineIndices.length; i++) {
      lines.add(
        CustomPaint(
          painter: Line(
            topA: positions[lineIndices[i][0]][1] + 50,
            topB: positions[lineIndices[i][1]][1] + 50,
            leftA: positions[lineIndices[i][0]][0] + 50,
            leftB: positions[lineIndices[i][1]][0] + 50,
          ),
        )
      );
    }
  }

  int selectedIndex = -1;
  int selectedIndex2 = -1;

  void resetSelected() {
    selectedIndex = -1;
    selectedIndex2 = -1;
  }

  bool lineMode = false;

  void toggleLineMode() {
    lineMode = !lineMode;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _buildScreen();
    //Might be needed for screen size
    //double screen_width = MediaQuery.of(context).size.width;    // Screen width
    //double screen_height = MediaQuery.of(context).size.height;  // Screen height
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        toggleLineMode();
      }),
      appBar: AppBar(
        title: const Text("Automata Designer"),
      ),
      body: Stack(
        children: [
          GestureDetector(
            //Add node on double tap
            onDoubleTapDown: (details) {
              setState(() {
                var position = details.localPosition;
                positions.add([position.dx-50, position.dy-50]);
              });
            },
            onLongPress: () => _reset(),
          ),

          Stack(
            children: lines,
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
                resetSelected();
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
                if (lineMode) {
                  var position = details.localPosition;
                  var y = position.dy - 50;
                  var x = position.dx - 50;
                  for (int i = 0; i < positions.length; i++) {
                    if (nodes[i].containsPoint(x, y)) {
                      selectedIndex2 = i;
                      break;
                    }
                  }
                  if (selectedIndex != -1 && selectedIndex2 != -1) {
                    lineIndices.add([selectedIndex, selectedIndex2]);
                    setState(() {});
                  }
                }
                //resetSelected();
              },
              //Drag node
              onPanUpdate: (details) {
                if (selectedIndex != -1 && !lineMode) {
                  positions[selectedIndex][0] += details.delta.dx;
                  positions[selectedIndex][1] += details.delta.dy;
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