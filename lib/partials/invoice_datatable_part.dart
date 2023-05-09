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

  String _searchStatement = '';
  late Uri _searchUri;
  late Uri _fetchUri;
  String _next = "";

  String _cacheKey = "";

  List<Invoice> _invoices = [];

  final _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchUri = widget.uri;

      if (!widget.received) {
        _cacheKey = "invoices";
      } else {
        _cacheKey = "received";
      }
    });

    _load();

    _scrollController.addListener(() {
      _loadMore();
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_invoices.isNotEmpty){
      return RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
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
                            _invoices.isNotEmpty?Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: createDatatable(_invoices),
                            ):loading(),
                            (_isLoading && _invoices.isNotEmpty)?loading():const Text("")
                          ],
                        ),
                      )),
                ],
              )
          )
      );
    }
    return loading();
  }

  Future<void> _refresh() async{
    MemoryCache.instance.delete(_cacheKey);
    _invoices = [];
    setState(() {
      _isLoading = true;
    });
    _load();
  }

  void _load(){
    if(!MemoryCache.instance.contains(_cacheKey)) {
      fetchResult(_fetchUri).then((value) => {
        setState(() {
          _invoices.addAll(value.invoices);
          MemoryCache.instance
              .create(_cacheKey, _invoices, expiry: const Duration(hours: 2));
          _next = value.next;
          _isLoading =  false;
        }),
      });
    } else {
      _invoices.addAll(MemoryCache.instance.read(_cacheKey) as List<Invoice>);
    }
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
        uploadPicture(pickedFile, id);
        _updateInvoices();
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
            (_cacheKey == "invoices")?createDataColumn(cols[7]):createDataColumn(""),
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
      (_cacheKey == "invoices")
          ?DataCell(
          Container(
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _getFromCamera(invoice.id);
                  _updateInvoices();
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
    String hintText = "Numéro de bordereau";

    return TextField(
      onSubmitted: (value) {
        //print(value);
        _performResearch(value);
      },
      controller: _textController,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            _performResearch(_textController.value.text);
          },
        ),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(25.0))),
        suffixIcon: IconButton(
          icon: const Icon(Icons.cancel),
          onPressed: () {
            setState(() {
              _textController.clear();
              _searchStatement = '';
              //usersFiltered = users;
            });
            _performResearch(_textController.value.text);
          },
        ),
      ),
    );
  }

  void _performResearch(value){
    _searchStatement = value;
    
    _updateInvoices();
  }
  
  void _updateInvoices(){
    if(_searchStatement.isEmpty){
      _searchUri = _fetchUri;
    } else {
      _searchUri = Environment().getUriSearchForId(_searchStatement);
    }

    setState(() {
      _isLoading = true;
      _invoices = [];
      fetchResult(_searchUri).then((value) => {
        setState((){
          _invoices.addAll(value.invoices);
          _isLoading = false;
        }),
        MemoryCache.instance.update(_cacheKey, _invoices, expiry: const Duration(hours: 2))
      });
    });
  }

  void _loadMore(){
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      setState(() {
        _isLoading = true;
      });

      fetchResult(_fetchUri, _next).then((value) => {
        setState((){
          _isLoading = false;
          _invoices.addAll(value.invoices);
          MemoryCache.instance.update(_cacheKey, _invoices, expiry: const Duration(hours: 2));
          _next = value.next;
        }),
      });
    }
  }
}
