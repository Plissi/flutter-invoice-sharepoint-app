import 'dart:io';

import 'package:flutter/material.dart';

class InvoicePage extends StatelessWidget {
  const InvoicePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = "Decharge App";
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: InvoiceForm(),
          ),
        ),
      ),
    );
  }
}

class InvoiceForm extends StatefulWidget {
  const InvoiceForm({Key? key}) : super(key: key);

  @override
  InvoiceFormState createState() {
    return InvoiceFormState();
  }
}

class InvoiceFormState extends State<InvoiceForm> {
  @override
  Widget build(BuildContext context) {
    const title = "Enregitrement de decharge";
    const importButton = "Importer un fichier";
    const cameraButton = "Prendre une photo";

    return Padding(
      padding: const EdgeInsets.all(128),
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
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text(importButton),
                onPressed: () {},
              )
          ),
          Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ElevatedButton(
                child: const Text(cameraButton),
                onPressed: () {},
              )),
        ],
      ),
    );
  }
}
