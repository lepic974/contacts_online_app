import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';

class Chargement extends StatefulWidget {
  @override
  _ChargementState createState() => _ChargementState();
}

class _ChargementState extends State<Chargement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200),
            Image.asset('assets/logo.png', height: 200, width: 200,),
            SizedBox(height: 10),
            SpinKitChasingDots(
              color: Colors.amber,
              size: 50,
            )
          ],
        ),
      );
  }
}
