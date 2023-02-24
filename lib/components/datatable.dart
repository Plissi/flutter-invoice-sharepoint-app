import 'package:flutter/material.dart';
import 'package:transmission_facture_client/pages/update.dart';

class DataTablePart extends StatefulWidget {
  const DataTablePart({Key? key}) : super(key: key);

  @override
  State<DataTablePart> createState() => _DataTablePartState();
}

class _DataTablePartState extends State<DataTablePart> {
  List<Invoice> _invoices = <Invoice>[];

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    _invoices = getInvoiceData();
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
    List<Invoice> data = _invoices;
    String title = 'Décharge en cours';
    List<String> cols = ["ID", "Code Client", "Client", "Date", "Montant", "Nombre de factures", "Statut", "Actions"];
    return Scaffold(
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
                                        invoice.status.toString(),
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
                                        child: const Icon(Icons.camera),
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
    );
  }
}

class Invoice {
  Invoice(this.id, this.customerCode, this.customerName, this.date, this.amount, this.invoiceCount, this.status);
  final int id;
  final String customerCode;
  final String customerName;
  final DateTime date;
  final int amount;
  final int invoiceCount;
  final Status status;
}

enum Status{
  Oui,
  Non
}

List<Invoice> getInvoiceData() {
  return [
    Invoice(1, "112113", "RAZEL CAMEROUN", DateTime(2023, 11, 23), 11000000, 4, Status.Non),
    Invoice(1, "112113", "RAZEL CAMEROUN", DateTime(2023, 11, 23), 11000000, 4, Status.Non),
  ];
}
