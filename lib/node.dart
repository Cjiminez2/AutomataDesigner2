import 'package:flutter/material.dart';

class Node extends StatefulWidget {
  final double top;
  final double left;

  const Node({
    super.key,
    required this.top,
    required this.left
  });

  @override
  State<Node> createState() => _NodeState();
}

class _NodeState extends State<Node> {
  late double top = widget.top;
  late double left = widget.left;
  late Color borderColor = Colors.black;
  final focusNode = FocusNode();

  //Changes the appearance for selected nodes
  void _enabler() {
    setState(() {
      borderColor = Colors.lightBlueAccent;
      focusNode.requestFocus();
    });
  }

  //Disables selected node appearance
  void _disabler() {
    setState(() {
      borderColor = Colors.black;
      focusNode.unfocus();
    });
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.dispose();
  }

  //TODO: Make this useful later
  List<double> getPosition () {
    return [top, left];
  }

  @override
  void initState() {
    super.initState();
    _enabler();
    focusNode.addListener(_loseFocus);
  }

  void _loseFocus() {
    if (!focusNode.hasFocus) {
      _disabler();
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
          child: Stack(
            children: [
              Center(
                child: TextField(
                  style:
                  TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: borderColor),
                  textAlign: TextAlign.center,
                  focusNode: focusNode,
                  onEditingComplete: () => _disabler(),
                  onTapOutside: (PointerDownEvent event) => _disabler(),
                  onTap: () => _enabler(),
                  decoration: null, //Removes textfield designs
                ),
              ),
              //Accept state extra circle
              Center(
                  child: Visibility(
                    visible: false, //TODO: add accept state toggelability
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                          width: 4.0,
                        ),
                      ),
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
