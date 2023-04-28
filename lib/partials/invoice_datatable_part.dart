import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:memory_cache/memory_cache.dart';
import 'package:transmission_facture_client/environment.dart';
import 'package:transmission_facture_client/models/Image.dart';
import 'package:transmission_facture_client/models/Invoice.dart';

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
  late Uri searchUri;
  late Uri fetchUri;
  String next = "";

  String cacheKey = "";

  List<Invoice> invoices = [];

  final _scrollController = ScrollController();
  TextEditingController textController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchUri = widget.uri;

      if (!widget.received) {
        cacheKey = "invoices";
      } else {
        cacheKey = "received";
      }
    });

    if(!MemoryCache.instance.contains(cacheKey)) {
      fetchResult(fetchUri).then((value) => {
            setState(() {
              invoices.addAll(value.invoices);
              MemoryCache.instance
                  .create(cacheKey, invoices, expiry: const Duration(hours: 2));
              next = value.next;
            }),
          });
    } else {
      invoices.addAll(MemoryCache.instance.read(cacheKey) as List<Invoice>);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });

        fetchResult(fetchUri, next).then((value) => {
          setState((){
            isLoading = false;
            invoices.addAll(value.invoices);
            MemoryCache.instance.update(cacheKey, invoices, expiry: const Duration(hours: 2));
            next = value.next;
          }),
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (invoices.isNotEmpty){
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 5),
                        getSearchBar(),
                        const SizedBox(height: 10),
                        invoices.isNotEmpty?Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12.0),
                            ),
                          ),
                          child: createDatatable(invoices),
                        ):loading(),
                        (isLoading && invoices.isNotEmpty)?loading():const Text("")
                      ],
                    ),
                  )),
            ],
          )
      );
    }
    return loading();
    /*

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
     */
  }

  /// Get from Camera
  _getFromCamera(int id) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(imagePath);
        uploadPicture(pickedFile, id);
        var path = pickedFile.path.split('/');
        var imageNameIndex = path.length - 1;

        imageName = path[imageNameIndex];
      });
    }
  }

  DataCell createDataCell(String data){
    return DataCell(SizedBox(
      child: Text(
        data,
        style:
        const TextStyle(),
      ),
    ));
  }

  DataColumn createDataColumn(String col){
    return DataColumn(
      label: Text(
        col,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }
  
  Widget createDatatable(List<Invoice> data) {
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

    List<DataRow> rows = [];

    rows.addAll(data.map((invoice) =>
        createRow(invoice))
        .toList());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
          columns: [
            createDataColumn(cols[0]),
            createDataColumn(cols[1]),
            createDataColumn(cols[2]),
            createDataColumn(cols[3]),
            createDataColumn(cols[4]),
            createDataColumn(cols[5]),
            createDataColumn(cols[6]),
            (cacheKey == "invoices")?createDataColumn(cols[7]):createDataColumn(""),
          ],
          rows: data.map((invoice) =>
              createRow(invoice))
              .toList()),
    );
  }

  DataRow createRow(Invoice invoice){
    return DataRow(cells: [
      createDataCell(
        invoice.id.toString(),
      ),
      createDataCell(
        invoice.customerCode.toString(),
      ),
      createDataCell(
        invoice.customerName.toString(),
      ),
      createDataCell(
        DateFormat('dd/MM/yy').format(invoice.date),
      ),
      createDataCell(
        invoice.amount.toString(),
      ),
      createDataCell(
          invoice.invoiceCount.toString()
      ),
      createDataCell(
          invoice.status.toString().split('.').last
      ),
      (cacheKey == "invoices")
          ?DataCell(
          Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _getFromCamera(invoice.id);
                },
              )
          )
      ):const DataCell(Text("")),

    ]);
  }

  Widget loading(){
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Chargement...')
          ]
      ),
    );
  }

  Widget getSearchBar(){
    String hintText = "Code Client";

    return TextField(
      onSubmitted: (value) {
        //print(value);
        performResearch(value);
      },
      controller: textController,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            performResearch(textController.value.text);
          },
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(25.0))),
        suffixIcon: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              textController.clear();
              _searchResult = '';
              //usersFiltered = users;
            });
            performResearch(textController.value.text);
          },
        ),
      ),
    );
  }

  void performResearch(value){
    _searchResult = value;
    
    if(_searchResult.isEmpty){
      searchUri = fetchUri;
    } else {
      searchUri = Environment().getUriSearch(_searchResult);
    }

    setState(() {
      isLoading = true;
      invoices = [];
      fetchResult(searchUri).then((value) => {
        setState((){
          invoices.addAll(value.invoices);
          isLoading = false;
        }),
        MemoryCache.instance.update(cacheKey, invoices)
      });
      //print(searchUri);
    });
  }
}
