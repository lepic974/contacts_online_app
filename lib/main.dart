import 'package:flutter/material.dart';
import 'package:mycontactonline/pageAuth/connexion.dart';
import 'package:mycontactonline/pageAuth/inscription.dart';
import 'package:mycontactonline/pageAuth/liaisonAuth.dart';

void main() => runApp(MonApp());

class MonApp extends StatelessWidget {
  get basculation => null;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Connexion(basculation: basculation),
    );
  }
}


