import 'package:flutter/material.dart';
import 'package:transmission_facture_client/models/Invoice.dart';
import 'package:transmission_facture_client/partials/datatable_part1.dart';
import 'package:transmission_facture_client/partials/datatable_part2.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = "Decharge App";

    String title1 = 'Décharges en cours';
    String title2 = 'Décharges effectuées';

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text(appTitle),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: DefaultTabController(
            length: 2,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(
                              child: Center(
                            child: Text(
                              title1,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                          )),
                          Tab(
                              child: Center(
                            child: Text(
                              title2,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 32),
                            ),
                          )),
                        ],
                      ),
                    ),
                    body: const TabBarView(
                      children: [DataTablePart1(), DataTablePart2()],
                    )),
              ),
            ),
          )),
    );
  }
}

List<Invoice> getInvoiceData() {
  return [
    Invoice(1, "112113", "RAZEL CAMEROUN", DateTime(2023, 11, 23), 1100000, 4,
        Status.Oui),
    Invoice(2, "112113", "RAZEL CAMEROUN", DateTime(2023, 11, 23), 11000000, 12,
        Status.Non),
  ];
}
