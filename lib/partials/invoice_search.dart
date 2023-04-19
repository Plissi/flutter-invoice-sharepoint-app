import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';

import '../environment.dart';
import '../models/Invoice.dart';

class InvoiceSearch extends StatefulWidget {
  final String cacheKey;
  const InvoiceSearch({Key? key, required this.cacheKey}) : super(key: key);

  @override
  State<InvoiceSearch> createState() => _InvoiceSearchState();
}

class _InvoiceSearchState extends State<InvoiceSearch> {
  String hint = "Numéro du bordereau";
  String _searchResult = '';
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            _searchResult = controller.value.text;
            print(_searchResult);
            var data = await fetchInvoices(Environment().getUriSearch(_searchResult));
            setState(() {
              MemoryCache.instance.update(widget.cacheKey, data);
            });
          },
        ),
        title: TextFormField(
          controller: controller,
          decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none
          ),
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
    );
  }
}
