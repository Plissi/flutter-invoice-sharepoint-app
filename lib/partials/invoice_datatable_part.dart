import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:transmission_facture_client/environment.dart';
import 'package:transmission_facture_client/models/Image.dart';
import 'package:transmission_facture_client/models/Invoice.dart';
import 'package:transmission_facture_client/partials/invoice_datacell.dart';

class InvoiceDataTablePart extends StatefulWidget {
  final Uri uri;
  final bool received;
  const InvoiceDataTablePart(
      {Key? key, required this.uri, required this.received})
      : super(key: key);

  @override
  State<InvoiceDataTablePart> createState() => _DataTablePartState();
}

class _DataTablePartState extends State<InvoiceDataTablePart> {
  /// Variables
  File? imageFile;
  late String imagePath;
  late String imageName;
  String _searchResult = '';

  late Future<List<Invoice>> _invoices;

  final controller = ScrollController();
  double offset = 0;

  @override
  void initState() {
    super.initState();
    _invoices = fetchInvoices(widget.uri);

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
    TextEditingController controller = TextEditingController();
    String hintText = "Numéro du bordereau";

    //DataTable headers
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

    String cacheKey = "";
    if (!widget.received) {
      cacheKey = "invoices";
    } else {
      cacheKey = "received";
    }

    if (MemoryCache.instance.contains(cacheKey)) {
      List<Invoice>? data = MemoryCache.instance.read(cacheKey);
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
                              leading: IconButton(
                                icon: const Icon(Icons.search),
                                onPressed: () async {
                                  _searchResult = controller.value.text;
                                  print(_searchResult);
                                  var data = await fetchInvoices(Environment()
                                      .getUriSearch(_searchResult));
                                  setState(() {
                                    MemoryCache.instance.update(cacheKey, data);
                                  });
                                },
                              ),
                              title: TextFormField(
                                controller: controller,
                                decoration: const InputDecoration(
                                    hintText: 'Numéro du bordereau',
                                    border: InputBorder.none),
                              ),
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
                          TextField(
                            onSubmitted: (value) async {
                              _searchResult = controller.value.text;
                              print(_searchResult);
                              var data = await fetchInvoices(
                                  Environment().getUriSearch(_searchResult));
                              setState(() {
                                MemoryCache.instance.update(cacheKey, data);
                              });
                            },
                            controller: controller,
                            decoration: InputDecoration(
                                hintText: hintText,
                                prefixIcon: const Icon(Icons.search),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(25.0)))),
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
                                    )),
                                    DataColumn(
                                        label: Text(
                                      cols[1],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )),
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
                                    widget.received == true
                                        ? const DataColumn(label: Text(""))
                                        : DataColumn(
                                            label: Text(
                                            cols[7],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))
                                  ],
                                  rows: data
                                      .map((invoice) => DataRow(cells: [
                                            DataCell(
                                              Text(
                                                invoice.id.toString(),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                invoice.customerCode.toString(),
                                              ),
                                            ),
                                            DataCell(Text(
                                              invoice.customerName.toString(),
                                              style: const TextStyle(),
                                            )),
                                            DataCell(Text(
                                              invoice.date.toString(),
                                              style: const TextStyle(),
                                            )),
                                            DataCell(Text(
                                              invoice.amount.toString(),
                                              style: const TextStyle(),
                                            )),
                                            DataCell(SizedBox(
                                              width: 50,
                                              child: Text(
                                                invoice.invoiceCount.toString(),
                                                style: const TextStyle(),
                                              ),
                                            )),
                                            DataCell(Text(
                                              invoice.status
                                                  .toString()
                                                  .split('.')
                                                  .last,
                                              style: const TextStyle(),
                                            )),
                                            widget.received == true
                                                ? DataCell(Container())
                                                : DataCell(Container(
                                                    alignment: Alignment.center,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        _getFromCamera();
                                                      },
                                                      child: const Icon(
                                                          Icons.camera_alt),
                                                    ))),
                                          ]))
                                      .toList()),
                            ),
                          )
                        ],
                      ),
                    )),
                Container(
                    child: imageFile == null
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _getFromCamera();
                                  },
                                  child: Container(
                                    child: Text("PICK FROM CAMERA"),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            child: Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),
                          ))
              ],
            ));
      } else {
        return const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text("Pas de données"),
        );
      }
    } else {
      return FutureBuilder<List<Invoice>>(
          future: _invoices,
          builder: (ctx, snap) {
            if (snap.hasData) {
              List<Invoice>? data = snap.data;
              MemoryCache.instance
                  .create(cacheKey, data, expiry: const Duration(hours: 2));
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
                                            )),
                                            DataColumn(
                                                label: Text(
                                              cols[1],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )),
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
                                              .map((invoice) => DataRow(cells: [
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
                                                        DateFormat('dd/MM/yy')
                                                            .format(
                                                                invoice.date),
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
                                                            _getFromCamera();
                                                          },
                                                          child: const Icon(
                                                              Icons.camera_alt),
                                                        ))),
                                                  ]))
                                              .toList()),
                                    ),
                                  )
                                ],
                              ),
                            )),
                        Container(
                            child: imageFile == null
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        ElevatedButton(
                                          onPressed: () {
                                            _getFromCamera();
                                          },
                                          child: Container(
                                            child: Text("PICK FROM CAMERA"),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Image.file(
                                      imageFile!,
                                      fit: BoxFit.cover,
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
                  ElevatedButton(
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

  /// Get from Camera
  _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(imagePath);
        uploadPicture(pickedFile);
        var path = pickedFile.path.split('/');
        var imageNameIndex = path.length - 1;

        imageName = path[imageNameIndex];
      });
    }
  }
}
