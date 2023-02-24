import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transmission_facture_client/pages/home.dart';
import 'package:transmission_facture_client/pages/update.dart';

// Create a Form widget.
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() {
    return LoginState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginState extends State<Login> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<LoginState>.
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const buttonText = "Connexion";
    const validationMessage = "Veuillez entrer du texte";
    const processingMessage = "Traitement en cours";
    const hintLogin = "Email";
    const hintPass = "Mot de passe";
    const title = "Bienvenu !";
    const subtitle = "Connectez-vous";

    return Padding(
      padding: const EdgeInsets.all(64),
      child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    title,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    subtitle,
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  // The validator receives the text that the user has entered.
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validationMessage;
                    }
                    return null;
                  },*/
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: hintLogin,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  /*validator: (value) {
                    if (value == null || value.isEmpty) {
                      return validationMessage;
                    }
                    return null;
                  },*/
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: hintPass,
                  ),
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ElevatedButton(
                    child: const Text(buttonText),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);

                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        //sendItem(item.Name,item.IsComplete);
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        /*
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(processingMessage)),
                        );*/
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Home();
                          }),
                        );
                      }
                    },
                  )
              ),
            ],
          )
      ),
    );
  }
}