import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:splashscreen02/decoBox.dart';

class SyntaxMode extends StatefulWidget {
  @override
  _SyntaxModeState createState() => _SyntaxModeState();
}

String perintah=""; // SIMPAN TEKS PERINTAH

class _SyntaxModeState extends State<SyntaxMode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: GradientAppBar(
        backgroundColorStart: Color(0xFF3594DD),
        backgroundColorEnd: Color(0xFF5B16D0),
        title: Text('Syntax Mode'),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ketikkan perintah yang akan dijalankan pada robot',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Perintah',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: FlatButton(                  
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    onPressed: () {
                      //CODINGAN UNTUK MENGIRIM DATA KE BLUETOOTH
                    },
                    child: Text(
                      'Kirim',
                      style: TextStyle(color: Colors.white),
                    ),
                      
                  ),
                  decoration: boxDecorationStyle ,
              ),
            ],
          ),
        ));
  }
}
