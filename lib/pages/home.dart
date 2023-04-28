import 'package:flutter/material.dart';
import 'package:transmission_facture_client/models/Invoice.dart';
import 'package:transmission_facture_client/partials/invoice_datatable_part.dart';

import '../environment.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = "Decharge App";

    String title1 = 'En cours';
    String title2 = 'Déchargées';

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
          ),
          body: DefaultTabController(
            length: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Scaffold(
                    appBar: AppBar(
                      title: TabBar(
                        tabs: [
                          Tab(
                              child: Center(
                            child: Text(
                              title1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )),
                          Tab(
                              child: Center(
                            child: Text(
                              title2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          )),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: [InvoiceDataTablePart(uri: Environment.uri1, received: false), InvoiceDataTablePart(uri: Environment.uri2, received: true)],
                    )),
              ),
            ),
          )),
    );
  }
}
