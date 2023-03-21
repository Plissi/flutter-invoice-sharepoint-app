import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:transmission_facture_client/environment.dart';

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
    List jsonResponse = parsed["results"] as List;
    String next = parsed["__next"];
    print(next);

    return jsonResponse.map((job) => Invoice.fromJson(job)).toList();
  } else {
    print('Error, Could not load Data.');
    throw Exception('Failed to load Data');
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
