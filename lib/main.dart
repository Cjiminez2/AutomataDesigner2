import 'package:flutter/material.dart';

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
  MovableNodeScreen({
    super.key
  });

  List<String> nodesWords = [];
  List<MovableNode> nodes = [];
  List<String> nodesIndex = [];
  List<List<double>> positions = [];
  List<bool> select = [];


  @override
  State<MovableNodeScreen> createState() => _MovableNodeScreenState();
}

class _MovableNodeScreenState extends State<MovableNodeScreen> {

  //late List<Widget> nodes = [];
  @override
  Widget build(BuildContext context) {
    //Might be needed for screen size
    //double screen_width = MediaQuery.of(context).size.width;    // Screen width
    //double screen_height = MediaQuery.of(context).size.height;  // Screen height
    return Scaffold(
      appBar: AppBar(
        title: const Text("MovableNode"),
      ),
      body: Stack(
        children: [
          GestureDetector(
              onDoubleTapDown: (details) {
                var position = details.localPosition;
                widget.nodes.add(
                  MovableNode(
                    top: position.dy-50,
                    left: position.dx-50
                  )
                );
                setState(() {});
              }
          ),
          Stack(
            children: widget.nodes,
          ),
          IgnorePointer(
            ignoring: true,
            child:
              GestureDetector(
                onTapDown: (details) {
                  var position = details.localPosition;
                  var x = position.dx;
                  var y = position.dy;
                  for (int i = 0; i < widget.nodesWords.length; i++) {
                    if ((widget.positions[i][0] - y).abs() < 50 &&
                        ((widget.positions[i][1] - x).abs() < 50)) {
                      widget.select[i] = !widget.select[i];
                    }
                  }
                  setState(() {});
                  //print("tapped");
                }
              ),
          ),
        ],
      ),
    );
  }
}

class MovableNode extends StatefulWidget {
  final double top;
  final double left;
  late bool selected = true;

  MovableNode({
    super.key,
    required this.top,
    required this.left
  });

  void unselect() {
    selected = false;
  }

  void select() {
    selected = true;
  }

  @override
  State<MovableNode> createState() => _MovableNodeState();
}

class _MovableNodeState extends State<MovableNode> {
  late double top = widget.top;
  late double left = widget.left;
  final focusNode = FocusNode();
  late Color borderColor = Colors.black;

  void enabler() {
    borderColor = Colors.lightBlueAccent;
    focusNode.requestFocus();
    setState(() {});
  }

  void disable() {
    borderColor = Colors.black;
    focusNode.unfocus();
    setState(() {});
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  List<double> getPosition () {
    return [top, left];
  }

  @override
  void initState() {
    super.initState();
    enabler();
    focusNode.addListener(_loseFocus);
  }

  void _loseFocus() {
    if (!focusNode.hasFocus) {
      disable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            top += details.delta.dy;
            left += details.delta.dx;
          });
        },
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: borderColor,
              width: 4.0,
            ),
          ),

          child: Center(
            child: TextField(
              focusNode: focusNode,
              onEditingComplete: () => disable(),
              onTapOutside: (PointerDownEvent event) => disable(),
              onTap: () => enabler(),
              decoration: const InputDecoration(labelText: "Type")
            )
          ),

        ),
      ),
    );
  }
}
