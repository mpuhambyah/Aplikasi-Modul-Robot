import 'package:flutter/material.dart';
import 'package:control_pad/control_pad.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
class CommandMode extends StatefulWidget {
  @override
  _CommandModeState createState() => _CommandModeState();
}

class _CommandModeState extends State<CommandMode> {
  @override
  Widget build(BuildContext context) {
    JoystickDirectionCallback onDirectionChanged(
        double degrees, double distance) {
      String data =
          "Degree : ${degrees.toStringAsFixed(2)}, distance : ${distance.toStringAsFixed(2)}";
      print(data);
        //DATA INI ADALAH DATA CODE DEGREE DAN DISTANCE UNTUK DIKIRIMKAN LEWAT BLUETOOTH
    }


    return Scaffold(
      appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF3594DD),
        backgroundColorEnd: Color(0xFF5B16D0),
        title: Text('Command Mode'),
      ),
      body: Center(
          child: Container(
        color: Colors.white,
        child: JoystickView(
          iconsColor: Color(0xFF3594DD),
          innerCircleColor: Colors.white,
          backgroundColor: Colors.white,          
          onDirectionChanged: onDirectionChanged,
        ),
      )),
    );
  }
}
