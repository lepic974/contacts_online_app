import 'package:flutter/material.dart';
import 'package:mycontactonline/pageAuth/connexion.dart';
import 'package:mycontactonline/pageAuth/inscription.dart';

class LiaisonAuth extends StatefulWidget {

  @override
  _LiaisonAuthState createState() => _LiaisonAuthState();
}

class _LiaisonAuthState extends State<LiaisonAuth> {
  bool affichePageConnexion = true;

  void basculation() {
    setState(() => affichePageConnexion = !affichePageConnexion);
  }

  @override
  Widget build(BuildContext context) {

    if(affichePageConnexion) {
      return Connexion(basculation: basculation);
    } else {
      return Inscription(basculation: basculation);
    }
    return Container();
  }
}
