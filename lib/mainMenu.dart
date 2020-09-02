import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:splashscreen02/Mode/commandMode.dart';
//import 'package:splashscreen02/Mode/syntaxMode.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:splashscreen02/Mode/syntaxMode.dart';
import 'package:splashscreen02/decoBox.dart';
import 'package:splashscreen02/Mode/autoMode.dart';
import 'SelectBondedDevicePage.dart';
import 'ChatPage.dart';

class MainMenu extends StatefulWidget {
  MainMenu({Key key, this.selectedDevice}) : super(key: key);
  final BluetoothDevice selectedDevice;
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  //bluetooth initiation
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

  final List<String> entries = <String>[
    'Automatic Mode',
    'Command Mode',
    'Syntax Mode'
  ];

  bool press1 = false;
  bool press2 = false;
  bool press3 = false;
  double opacityLevel = 0.0;

  final List<Tab> myTabs = <Tab>[
    Tab(
      icon: Icon(Icons.home),
      text: 'Mode',
    ),
    Tab(icon: Icon(Icons.help), text: 'Helps'),
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String text1 =
        "Automatic Mode adalah Mode robot dapat berjalan sendiri dan menghindari obstacle secara automatis";
    String isitext1 =
        "Robot telah dilengkapi dengan sensor ultrasonic untuk menghindari berbagai macam obstacle secara otomatis dan mencari jalan yang tidak memiliki obstacle";
    String text2 =
        "Syntax Mode adalah Mode robot yang dikendalikan dengan perintah/syntax khusus sesuai modul yang telah di berikan";
    String isitext2 =
        "Robot akan di kendalikan dengan perintah Khusus.\nContoh\nmaju(30) : Maju sejauh 30 miliseconds\nMundur(20) : Mundur Sejauh 20 miliseconds";
    String text3 =
        "Command Mode adalah Mode robot yang dikendalikan dengan Tombol Controller untuk mengendalikan robot ";
    String isitext3 =
        "Controll Button Memiliki Direction 360 Degree agar bisa mengendalikan robot ke segala arah";

    return DefaultTabController(
        length: myTabs.length,
        child: Scaffold(
          appBar: GradientAppBar(
            backgroundColorStart: Color(0xFF3594DD),
            backgroundColorEnd: Color(0xFF5B16D0),
            title:
                Text('connected to ' + widget.selectedDevice.name, textAlign: TextAlign.center),
            bottom: TabBar(
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 130,
                        height: 40,
                        child: FlatButton(
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AutoMode()));
                            },
                            child: Text(
                              'Automatic',
                              style: TextStyle(color: Colors.white),
                            )),
                        decoration: boxDecorationStyle),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 130,
                        height: 40,
                        child: FlatButton(
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CommandMode()));
                            },
                            child: Text(
                              'Command Mode',
                              style: TextStyle(color: Colors.white),
                            )),
                        decoration: boxDecorationStyle),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 130,
                        height: 40,
                        child: FlatButton(
                            textColor: Colors.white,
                            padding: EdgeInsets.all(8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SyntaxMode()));
                            },
                            child: Text(
                              'Syntax Mode',
                              style: TextStyle(color: Colors.white),
                            )),
                        decoration: boxDecorationStyle),
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "AutoMatic Mode",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down_circle),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                opacityLevel = 1;
                                press1 = true;
                                press2 = false;
                                press3 = false;
                              });
                            },
                          ),
                        ],
                      ),
                      press1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                isi(context, text1, isitext1),
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height < 700
                                  ? 20
                                  : 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Syntax Mode",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down_circle),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                opacityLevel = 1;
                                press1 = false;
                                press2 = true;
                                press3 = false;
                              });
                            },
                          ),
                        ],
                      ),
                      press2
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                isi(context, text2, isitext2),
                                Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Image.network(
                                        'https://raw.githubusercontent.com/Fradip11/dipwebv10.github.io/master/assets/images/141496.jpg')),
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height < 700
                                  ? 20
                                  : 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              "Command Mode",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_drop_down_circle),
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                opacityLevel = 1;
                                press1 = false;
                                press2 = false;
                                press3 = true;
                              });
                            },
                          ),
                        ],
                      ),
                      press3
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                isi(context, text3, isitext3),
                                Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Image.network(
                                        'https://raw.githubusercontent.com/Fradip11/dipwebv10.github.io/master/assets/images/141493.jpg')),
                              ],
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height < 700
                                  ? 20
                                  : 30),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

Widget isi(BuildContext context, String title, String isi) {
  double width = MediaQuery.of(context).size.width;
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: width * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        Text(isi,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: width * 0.03,
                fontWeight: FontWeight.bold,
                color: Colors.black))
      ],
    ),
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