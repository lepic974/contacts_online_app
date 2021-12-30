import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mycontactonline/constants/chargement.dart';

class AjoutContact extends StatefulWidget {
  @override
  _AjoutContactState createState() => _AjoutContactState();
}

class _AjoutContactState extends State<AjoutContact> {
  String urlImage = '';
  String nomContact = '';
  String postNomCont = '';
  String emailContact = '';
  String numTelContact = '';

  bool _enProcessus = false;
  File _fichierSelectionne;
  bool chargement = false;

  final _formKey = GlobalKey<FormState>();

  // La référence de la collection utilisateur
  final CollectionReference collectionUtil =
      Firestore.instance.collection('utilisateur');

  FirebaseUser currentUser;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        this.currentUser = user;
      });
    });

    String _idUtil() {
      if (currentUser != null) {
        return currentUser.uid;
      } else {
        return "pas d'id";
      }
    }

    obtenirImage(ImageSource source) async {
      setState(() {
        _enProcessus = true;
      });

      File image = await ImagePicker.pickImage(source: source);
      if (image != null) {
        File croppe = await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.png,
            androidUiSettings: AndroidUiSettings(
              toolbarColor: Colors.white,
              toolbarTitle: 'Ronger l\'image',
              statusBarColor: Colors.amber,
              backgroundColor: Colors.black,
            ));
        this.setState(() {
          _fichierSelectionne = croppe;
          _enProcessus = false;
        });
      } else {
        this.setState(() {
          _enProcessus = false;
        });
      }
    }

    enregistrerContact() async {
      setState(() => chargement = true);

      if (_fichierSelectionne == null) {
        await collectionUtil
            .document(_idUtil())
            .collection('contacts')
            .document(numTelContact)
            .setData({
          'urlImage': '',
          'nomContact': nomContact,
          'postNomContact': postNomCont,
          'emailContact': emailContact,
          'numTel': numTelContact,
        });
        this.setState(() {
          Navigator.pop(context);
        });
      } else {
        // Enregistrement de l'image
        StorageReference reference = FirebaseStorage.instance
            .ref()
            .child('$nomContact$numTelContact.png');
        StorageUploadTask uploadTask = reference.putFile(_fichierSelectionne);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        this.urlImage = await taskSnapshot.ref.getDownloadURL();

        await collectionUtil
            .document(_idUtil())
            .collection('contacts')
            .document(numTelContact)
            .setData({
          'urlImage': urlImage,
          'nomContact': nomContact,
          'postNomContact': postNomCont,
          'emailContact': emailContact,
          'numTel': numTelContact,
        });
        this.setState(() {
          Navigator.pop(context);
        });
      }
    }

    return chargement
        ? Chargement()
        : Scaffold(
            appBar: AppBar(
              title: Text('Nouveau contact'),
              backgroundColor: Colors.white,
              actions: [
                RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      enregistrerContact();
                    }
                  },
                  color: Colors.blueAccent,
                  child: Text(
                    'Enregistrer',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  obtenirImage(ImageSource.gallery);
                                },
                                child: CircleAvatar(
                                  radius: 50.0,
                                  backgroundImage: _fichierSelectionne != null
                                      ? FileImage(_fichierSelectionne)
                                      : AssetImage('assets/icon.png'),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  obtenirImage(ImageSource.camera);
                                },
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Nom du contact',
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Entrez un nom' : null,
                            onChanged: (val) => nomContact = val,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Post-nom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Entrez un nom de post' : null,
                            onChanged: (val) => postNomCont = val,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Entrez un email' : null,
                            onChanged: (val) => emailContact = val,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'N° de Téléphone',
                              border: OutlineInputBorder(),
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Entrez un numéro' : null,
                            onChanged: (val) => numTelContact = val,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                (_enProcessus)
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.95,
                        child: Center(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          );
  }
}
