import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:memory_cache/memory_cache.dart';

class Invoice {
  final int id;
  final String customerCode;
  final String customerName;
  final DateTime date;
  final int amount;
  final int invoiceCount;
  final Status status;

  Invoice(this.id, this.customerCode, this.customerName, this.date, this.amount,
      this.invoiceCount, this.status);

  factory Invoice.fromJson(Map<dynamic, dynamic> json) {
    return Invoice(
        json['Id'],
        json['CodeClient'],
        json['NomClient'],
        DateTime.parse(json['DateEditionBordereau']),
        json['Montant'],
        json['NombreDeFactures'],
        Status.values.byName(json['Decharge']));
  }
}

enum Status { Oui, Non }

Future<List<Invoice>> fetchInvoices(uri) async {
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    var parsed = json.decode(response.body);
    List jsonResponse = parsed["d"]["results"] as List;
    String next = parsed["d"]["__next"];
    MemoryCache.instance
        .create("next", next, expiry: const Duration(hours: 2));
    return jsonResponse.map((job) => Invoice.fromJson(job)).toList();
  } else {
    print('Error, Could not load Data.');
    throw Exception('Failed to load Data');
  }
}

Future<Result> fetchResult(Uri uri, [String? next]) async {
  if(next != null) {
    uri = uri.replace(queryParameters: {'url': next});
  }

  try{
    final response = await http.get(uri, headers: {"Accept": "application/json;odata=verbose"});
    var parsed = json.decode(response.body);
    return Result.fromJson(parsed["d"]);
  } catch (err) {
    print(err);
    throw Exception('Failed to load Data');
  }
}

class Result{
  late final String next;
  late final List<Invoice> invoices;

  Result(this.next, this.invoices);

  factory Result.fromJson(Map<String, dynamic> parsedJson){
    List response = parsedJson['results'] as List;
    List<Invoice> list = response.map((json) => Invoice.fromJson(json)).toList();
    return Result(
        parsedJson['__next'],
        list
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
