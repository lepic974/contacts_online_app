import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mycontactonline/constants/chargement.dart';


class Inscription extends StatefulWidget {

  final Function basculation;
  Inscription({ this.basculation });

  @override
  _InscriptionState createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUlil;

  // Collection Utilisateurs depuis firebase
  final CollectionReference collectionUtil = Firestore.instance.collection('utilisateurs');

  String nomComplet ='';
  String email ='';
  String motDePasse ='';
  String comfirmMDP ='';

  bool chargement = false;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    FirebaseAuth.instance.currentUser().then((FirebaseUser util) {
      setState(() {
        this.currentUlil = util;
      });
    });

    String _idUtil() {
      if(currentUlil != null) {
        return currentUlil.uid;

      } else {
        return "Pas d'utilisateur courant";
      }
    }

    return chargement ? Chargement() : Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20.0),
                Image.asset('assets/pic.png', height: 100.0, width: 100.0,),
                Center(
                  child: Text("Créer un compte sur Contacts Online", style: Theme.of(context).textTheme.subtitle1),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom complet',
                    border: OutlineInputBorder()
                  ),
                  validator: (val) => val.isEmpty ? 'Entrez votre nom.' : null,
                  onChanged: (val) => nomComplet = val,
                ),

                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder()
                  ),
                  validator: (val) => val.isEmpty ? 'Entrez un email valide.' : null,
                  onChanged: (val) => email = val,
                ),

                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Mot de passe',
                      border: OutlineInputBorder()
                  ),
                  validator: (val) => val.length < 6 ? 'Entrez un mot de passe avec 6 ou plus de caractères.' : null,
                  onChanged: (val) => motDePasse = val,
                  obscureText: true,
                ),

                const SizedBox(height: 10.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Comfirmez le mot de passe',
                      border: OutlineInputBorder()
                  ),
                  validator: (val) => comfirmMDP != motDePasse ? 'Le mot de passe ne correspond pas.' : null,
                  onChanged: (val) => comfirmMDP = val,
                  obscureText: true,
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if(_formkey.currentState.validate()) {
                      setState(() => chargement = true);
                      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: motDePasse);

                      await collectionUtil.document(_idUtil()).setData({
                        'idUtil' : _idUtil(),
                        'nomComplet' : nomComplet,
                        'emailUtil' : email
                      });
                      if(result == null) {
                        // rint error

                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    primary: Colors.amber,
                    onPrimary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),),),
                  child: Text("S'inscrire"),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    widget.basculation();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),),),
                  child: Text("Avez-vous déjà un compte ?"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
