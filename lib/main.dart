import 'package:flutter/material.dart';
import 'package:mycontactonline/pageAuth/connexion.dart';
import 'package:mycontactonline/pageAuth/controlAuth.dart';
import 'package:mycontactonline/pageAuth/inscription.dart';
import 'package:mycontactonline/pageAuth/liaisonAuth.dart';
import 'package:provider/provider.dart';

void main() => runApp(MonApp());

class MonApp extends StatelessWidget {
  get basculation => null;


  @override
  Widget build(BuildContext context) {
    return StreamProvider<Utilisateur>.value(
      value: StreamProviderAuth().utilisateur,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Passerelle(),
      ),
    );
  }
}


