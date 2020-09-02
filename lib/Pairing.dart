import 'dart:async';

import 'package:flutter/material.dart';
import 'package:splashscreen02/mainMenu.dart';
import 'package:splashscreen02/styles.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import 'DiscoveryPage.dart';
import 'ChatPage.dart';

class Pairing extends StatefulWidget {
  @override
  _PairingState createState() => _PairingState();
}

bool isBluetoothOn = false;
int roboNumber = 1;
int roboAvailNumber = 2;
double opacityRobot1 = 0;
String robotName = "Robot ";

class _PairingState extends State<Pairing> {
  //bluetooth initiiation

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";

  Timer _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  bool _autoAcceptPairingRequests = false;

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  String _bluetoothCondition = 'Off';
  Color _color = Colors.red;

  void _showBluetoothConditionDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Peringatan"),
          content: new Text("Ups Bluetooth saya belum menyala"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double t_width = MediaQuery.of(context).size.width;
    double t_heigth = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Color(0xFF3594DD).withOpacity(0.9),
              Color(0xFF4563DB).withOpacity(0.9),
              Color(0xFF5036D5).withOpacity(0.9),
              Color(0xFF5B16D0).withOpacity(0.9),
            ],
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 65, left: 20),
                    child: RotatedBox(
                        quarterTurns: -1,
                        child: Text(
                          'Pairing',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Text('Lakukan', style: insideStyle),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Pairing dengan', style: insideStyle),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Robot yang Available', style: insideStyle),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  )),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text('Enable Bluetooth', style: insideStyle),
                        Text(
                          'Your Bluetooth is ' + _bluetoothCondition,
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 100)),
                        ClipOval(
                          child: Material(
                            color: _color,
                            child: InkWell(
                              splashColor: _color,
                              child: IconButton(
                                  icon: Icon(Icons.power_settings_new,),
                                  color: Colors.white,
                                  onPressed: () {
                                    bool value = _bluetoothState.isEnabled;
                                    future() async {
                                      if (value == false) {
                                        _bluetoothCondition = 'On';
                                        _color = Colors.green;
                                        await FlutterBluetoothSerial.instance
                                            .requestEnable();
                                        await FlutterBluetoothSerial.instance
                                            .requestEnable();
                                        final BluetoothDevice selectedDevice =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return DiscoveryPage();
                                            },
                                          ),
                                        );
                                        if (selectedDevice != null) {
                                          print('Discovery -> selected ' +
                                              selectedDevice.address);

                                          _startChat(context, selectedDevice);
                                        } else {
                                          print(
                                              'Discovery -> no device selected');
                                        }
                                      } else {
                                        _bluetoothCondition = 'Off';
                                        _color = Colors.red;
                                        await FlutterBluetoothSerial.instance
                                            .requestDisable();
                                      }
                                    }

                                    future().then((_) {
                                      setState(() {});
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
      /*floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainMenu()));
          },
          label: Text(
            'Mulai',
            style: TextStyle(color: Colors.blue),
          ),
          icon: Icon(Icons.play_arrow, color: Colors.blue),
          backgroundColor: Colors.white,
        )*/
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Robot Setting'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nama Robot'),
                      FlatButton(
                          onPressed: () {
                            editRoboName(context);
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> editRoboName(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Robot Setting'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                onChanged: (text) {
                  print("First text field: $text");
                  robotName = text;
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Tutup'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _startChat(BuildContext context, BluetoothDevice server) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        return ChatPage(server: server);
      },
    ),
  );
}
