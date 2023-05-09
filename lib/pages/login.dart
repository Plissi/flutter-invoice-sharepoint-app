import 'package:flutter/material.dart';
import 'package:transmission_facture_client/constants/colors.dart';
import 'package:transmission_facture_client/models/User.dart';
import 'package:transmission_facture_client/pages/home.dart';

import 'mainScreen.dart';

// Create a Form widget.
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() {
    return LoginState();
  }
}

const buttonText = "Connexion";
const validationMessage = "Champ obligatoire";
const processingMessage = "Connexion en cours";
const successMessage = "Connexion réussie";
const hintLogin = "Nom d'utilisateur";
const hintPass = "Mot de passe";
const title = "Bienvenu !";
const subtitle = "Connectez-vous";

User user = User("", "");
bool _isLoggingIn = false;

final _passwordFocusNode = FocusNode();

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
    //File img = File("assets/images/logo.png");
    return Padding(
        padding: const EdgeInsets.all(64),
        child: Form(
          key: _formKey,
          child: Container(/*
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),*/
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        title,
                        style: TextStyle(
                            color: AppColors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Image.asset(
                    "assets/images/logo.png",
                    scale: 0.1,
                    height: 100,
                  ),
                  /*Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              subtitle,
              style: TextStyle(fontSize: 20),
            )),*/
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return validationMessage;
                        }
                        user.username = value;
                        return null;
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: hintLogin,
                      ),
                      onEditingComplete: () {
                        _passwordFocusNode.requestFocus();
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return validationMessage;
                        }
                        user.password = value;
                        return null;
                      },
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: hintPass,
                      ),
                      onEditingComplete: _submit,
                      focusNode: _passwordFocusNode,
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: _isLoggingIn ? Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              CircularProgressIndicator(),
                            ]
                        ),
                      ): ElevatedButton(
                        child: const Text(buttonText),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: _isLoggingIn ? null : _submit,
                      )),
                ]
            ),
        ))
    );
  }

  Future<void> _submit() async {
    setState(() {
      _isLoggingIn = true;
    });

    _passwordFocusNode.unfocus();

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(processingMessage)),
      );
      var response = await login(user);
      setState(() {
        _isLoggingIn = false;
      });
      //print(MemoryCache.instance.contains("token") == true && DateTime.now().isBefore(DateTime.parse(MemoryCache.instance.read("expiration"))) == true);
      if (response["ok"] == true) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return const Home(child: MainScreen());
          }),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: const Color.fromRGBO(242, 5, 5, 0.8),
              content: Text(response["error"].toString())),
        );
      }
    }

    /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) {
          return const Home(child: MainScreen());
        })
    );*/

    setState(() {
      _isLoggingIn = false;
    });
  }
}
