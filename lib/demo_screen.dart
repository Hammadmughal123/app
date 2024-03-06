import 'package:flutter/material.dart';

class AnimatedSwitcherExample extends StatefulWidget {
  @override
  _AnimatedSwitcherExampleState createState() => _AnimatedSwitcherExampleState();
}

class _AnimatedSwitcherExampleState extends State<AnimatedSwitcherExample> {
  bool _isFirstWidget = true;

  void _toggleWidget() {
    setState(() {
      _isFirstWidget = !_isFirstWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AnimatedSwitcher Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: _isFirstWidget
                  ? Container(
                      key: ValueKey(1),
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: Text(
                        'First Widget',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  : Container(
                      key: ValueKey(2),
                      width: 200,
                      height: 200,
                      color: Colors.green,
                      alignment: Alignment.center,
                      child: Text(
                        'Second Widget',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleWidget,
              child: Text('Toggle Widget'),
            ),
          ],
        ),
      ),
    );
  }
}