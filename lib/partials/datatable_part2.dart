import 'dart:io';

import 'package:flutter/material.dart';
import 'package:transmission_facture_client/models/Invoice.dart';
import 'package:transmission_facture_client/pages/update.dart';

class DataTablePart2 extends StatefulWidget {
  const DataTablePart2({Key? key}) : super(key: key);

  @override
  State<DataTablePart2> createState() => _DataTablePartState();
}

class _DataTablePartState extends State<DataTablePart2> {
  //List<Invoice> _invoices = <Invoice>[];
  late Future<List<Invoice>> _invoices;

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    //_invoices = getInvoiceData();
    _invoices = fetchDeliveredInvoices();
    controller.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    //List<Invoice> data = _invoices;
    //Future<List<Invoice>> data = _invoices;

    TextEditingController controller = TextEditingController();
    String _searchResult = '';

    String title1 = 'Décharges en cours';
    String title2 = 'Décharges effectuées';

    List<String> cols = [
      "ID",
      "Code Client",
      "Client",
      "Date",
      "Montant",
      "Nombre de factures",
      "Statut",
      "Actions"
    ];
    /*return Scaffold(
        body: Center(
          child:Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: [
                                  DataColumn(
                                      label: Text(
                                        cols[0],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[1],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[2],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[3],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[4],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[5],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[6],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                  DataColumn(
                                      label: Text(
                                        cols[7],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ),
                                ],
                                rows: data.map((invoice) => DataRow(
                                    cells: [
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.id.toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.customerCode.toString(),
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.customerName.toString(),
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.date.toString(),
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.amount.toString(),
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            width: 50,
                                            child: Text(
                                              invoice.invoiceCount.toString(),
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                            child: Text(
                                              invoice.status.toString().split('.').last,
                                              style: const TextStyle(

                                              ),
                                            ),
                                          )
                                      ),
                                      DataCell(
                                          Container(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) {
                                                      return const InvoicePage();
                                                    }),
                                                  );
                                                },
                                                child: const Icon(Icons.camera_alt),
                                              )
                                          )
                                      ),
                                    ])
                                ).toList()
                            ),
                          ),
                        )
                    )
                  ],
                )
            ),
          ),

        )
    );*/
    return FutureBuilder<List<Invoice>>(
        future: _invoices,
        builder: (ctx, snap) {
          if (snap.hasData) {
            List<Invoice>? data = snap.data;
            if (data != null) {
              return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              children: [
                                Card(
                                  child: ListTile(
                                    leading: const Icon(Icons.search),
                                    title: TextField(
                                        controller: controller,
                                        decoration: const InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none),
                                        onChanged: (value) {
                                          setState(() {
                                            _searchResult = value;
                                            //usersFiltered = users.where((user) => user.name.contains(_searchResult) || user.role.contains(_searchResult)).toList();
                                          });
                                        }),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          controller.clear();
                                          _searchResult = '';
                                          //usersFiltered = users;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0),
                                    ),
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        columns: [
                                          DataColumn(
                                              label: Text(
                                                cols[0],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                          ),
                                          DataColumn(
                                              label: Text(
                                                cols[1],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                          ),
                                          DataColumn(
                                              label: Text(
                                                cols[2],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          DataColumn(
                                              label: Text(
                                                cols[3],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          DataColumn(
                                              label: Text(
                                                cols[4],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          DataColumn(
                                              label: Text(
                                                cols[5],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          DataColumn(
                                              label: Text(
                                                cols[6],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                          DataColumn(
                                              label: Text(
                                                cols[7],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )),
                                        ],
                                        rows: data
                                            .map((invoice) =>
                                            DataRow(cells: [
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.id.toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                ),
                                              )),
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.customerCode
                                                      .toString(),
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.customerName
                                                      .toString(),
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.date
                                                      .toString(),
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.amount
                                                      .toString(),
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                width: 50,
                                                child: Text(
                                                  invoice.invoiceCount
                                                      .toString(),
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                child: Text(
                                                  invoice.status
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                                  style:
                                                  const TextStyle(),
                                                ),
                                              )),
                                              DataCell(Container(
                                                  alignment:
                                                  Alignment.center,
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) {
                                                              return const InvoicePage();
                                                            }),
                                                      );
                                                    },
                                                    child: const Icon(
                                                        Icons
                                                            .camera_alt),
                                                  ))),
                                            ]))
                                            .toList()),
                                  ),
                                )
                              ],
                            ),
                          ))
                    ],
                  ));
            }
          } else if (snap.hasError) {
            return AlertDialog(
              title: const Text(
                'Une erreur est survenue!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
              content: Text(
                "${snap.error}",
                style: const TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text(
                    'Retour',
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
          // By default, show a loading spinner.
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Chargement...')
              ],
            ),
          );
        });
  }
}