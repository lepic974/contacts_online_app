import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycontactonline/constants/chargement.dart';

class Connexion extends StatefulWidget {

  final Function basculation;
  Connexion({ this.basculation });

  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  String email ='';
  String motDePasse ='';

  bool chargement = false;

  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return chargement ? Chargement() : Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Form(
            key: _keyForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10.0),
                Image.asset('assets/logo.png', height: 100, width: 100,),
                const SizedBox(height: 20.0),
                Center(
                  child: Text('Bienvenue sur Contacts Online App',
                  style: Theme.of(context).textTheme.subtitle1,),
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder()
                  ),
                  validator: (val) => val.isEmpty ? 'Entrez un email.' : null,
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

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    if(_keyForm.currentState.validate()) {

                      setState(() => chargement = true);
                      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: motDePasse);
                      if(result == null) {
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 1,
                    primary: Colors.amber,
                    onPrimary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),),),
                  child: Text("Connexion"),
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
                  child: Text("Inscription"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
