
import 'package:fbase/kullaniciekrani.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Hazir extends StatefulWidget {
   final docname; 
  Hazir({Key? mykey, this.docname}) : super(key: mykey);
  @override
  _HazirState createState() => _HazirState();
}

class _HazirState extends State<Hazir> {
  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_handleKeyPress);
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.keyA) {
      _showSnackBar('Order is ready.');
    }
  }

  void _showSnackBar(String message) {
    
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Go back to menu',
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Cafe(docname: widget.docname)));
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_handleKeyPress);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Preparing...'),
          ),
          body: Center(
            child: Text('Please wait'),
          ),
        ),
      ),
    );
  }
}
