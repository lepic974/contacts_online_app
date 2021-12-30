import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycontactonline/pageAuth/controlAuth.dart';
import 'package:mycontactonline/pageCrud/ajoutContact.dart';
import 'package:provider/provider.dart';

class Accueil extends StatefulWidget {

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {

  String nomUtil, emailUtil;

  Widget _boiteDeDialog(BuildContext, String nom, String email) {
    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Padding(
            padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                '$nom',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                '$email',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              SizedBox(height: 10),
              Wrap(
                children: [
                  FlatButton(
                    onPressed: () async {
                      FirebaseAuth _auth = FirebaseAuth.instance;
                      await _auth.signOut();
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('DECONNEXION'),
                    color: Colors.amber,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ANNULER'),
                    color: Colors.amber,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);

    GetCurrentUserData(idUtil: utilisateur.idUtil).donneesUtil.forEach((snapshot) {
      this.nomUtil = snapshot.nomComplet;
      this.emailUtil = snapshot.email;
    });

    return Scaffold(
        appBar: AppBar(
          title: Text("Contacts Online"),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
            ),

            IconButton(
              onPressed: () {},
              icon: Icon(Icons.person),
            ),
          ],
        ),
        body: Center(
          child: Text('Accueil'),
        ),
        floatingActionButton : FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AjoutContact()),);
          },
          backgroundColor: Colors.amber,
          child: Icon(Icons.add),
        ),

    );
  }
}
