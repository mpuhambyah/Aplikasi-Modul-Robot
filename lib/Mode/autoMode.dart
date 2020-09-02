import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
class AutoMode extends StatefulWidget {
  @override
  _AutoModeState createState() => _AutoModeState();
}


class _AutoModeState extends State<AutoMode> {
  bool switchControl = false;
  var textHolder = 'Automatic is OFF';

   void toggleSwitch(bool value) {
 
      if(switchControl == false)
      {
        setState(() {
          switchControl = true;
          textHolder = 'Automatic is ON';
        });
        print('Automatic is ON');
        // Put your code here which you want to execute on Switch ON event.
 
      }
      else
      {
        setState(() {
          switchControl = false;
           textHolder = 'Automatic is OFF';
        });
        print('Automatic is OFF');
        // Put your code here which you want to execute on Switch OFF event.
      }
      print(switchControl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
            backgroundColorStart: Color(0xFF3594DD),
            backgroundColorEnd: Color(0xFF5B16D0),
            title: Text('Automatic Mode'),
            
          ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                  onChanged: toggleSwitch,
                  value: switchControl,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.blueAccent.withOpacity(0.5),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey,
                ),
               Text('$textHolder', style: TextStyle(fontSize: 24),)
            ],
          ),
            
            
        )
        );
  }
}
