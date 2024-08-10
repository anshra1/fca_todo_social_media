//  WidgetsBinding.instance.addPostFrameCallback((_) {

//       });

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension FunctionExt on VoidCallback {
  void executeAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this();
    });
  }
}

// First, let's define the extension

class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using the extension in the build method
    (() {
      print('This will be executed after the frame is drawn');
    }).executeAfterFrame();

    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Press Me'),
          onPressed: () {
            // Using the extension with a button press
            (() {
              print('Button pressed, this executes after the frame');
              // Perform any operation here
            }).executeAfterFrame();
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: ExampleWidget()));
}
