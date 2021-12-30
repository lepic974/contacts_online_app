import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mycontactonline/pageAuth/liaisonAuth.dart';
import 'package:mycontactonline/pageCrud/accueil.dart';
import 'package:provider/provider.dart';

class Utilisateur {
  String idUtil;

  Utilisateur({this.idUtil});
}

class DonneesUtil {
  String email;
  String nomComplet;

  DonneesUtil({this.email, this.nomComplet});
}

class StreamProviderAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Création d'objet utilisateur provenant de la class FirebaseUser
  Utilisateur _utilisateurDeFirebaseUser(FirebaseUser user) {
    return user != null ? Utilisateur(idUtil: user.uid) : null;
  }

  // La diffusion de l'auth de l'utilisateur
  Stream<Utilisateur> get utilisateur {
    return _auth.onAuthStateChanged.map(_utilisateurDeFirebaseUser);
  }
}

class Passerelle extends StatefulWidget {
  @override
  _PasserelleState createState() => _PasserelleState();
}

class _PasserelleState extends State<Passerelle> {
  @override
  Widget build(BuildContext context) {

    final utilisateur = Provider.of<Utilisateur>(context);

    // Si l'utilisateur existe on lui redirige à la page accueil si non il doit s'authentifier
    if(utilisateur == null) {
      return LiaisonAuth();
    }
    else {
      return Accueil();
    }
  }
}

class GetCurrentUserData {
  String idUtil;
  GetCurrentUserData({this.idUtil});

  final CollectionReference collectionUtil =
      Firestore.instance.collection('utilisateur');

  // La référence de la collection utilisateur
  DonneesUtil _donneesUtilDeSnapshot(DocumentSnapshot snapshot) {
    return DonneesUtil(
      nomComplet: snapshot['nomComplet'],
      email: snapshot['emailUtil'],
    );
  }
  // Obtention doc util en stream
  Stream<DonneesUtil> get donneesUtil {
    return collectionUtil.document(idUtil).snapshots().map(_donneesUtilDeSnapshot);
  }
}
