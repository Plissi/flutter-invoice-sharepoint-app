import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:transmission_facture_client/main.dart';

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

  Map<String, dynamic> toJson(){
    return {
      'Id' : id,
      'CodeClient' : customerCode,
      'NomClient' : customerName,
      'DateEditionBordereau' : date,
      'Montant' : amount,
      'NombreDeFactures' : invoiceCount,
      'Decharge' : status
    };
  }

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
String errorMessage = "Impossible de charger les bodereaux";

Future<Result> fetchResult(Uri uri, [String? next]) async {
  var token = sharedPreferences.getString("token");

  if(next != null) {
    uri = uri.replace(queryParameters: {'url': next});
  }

  try{
    http.Response response;
    //print(token);
    if(token != null){
      response = await http.get(uri, headers: <String, String>{
        "Accept": "application/json;odata=verbose",
        'Authorization': 'Bearer ' + token
      });
    } else {
      response = await http.get(uri, headers: {"Accept": "application/json;odata=verbose"});
    }
    var parsed = json.decode(response.body);
    return Result.fromJson(parsed["d"]);
  } catch (err) {
    throw Exception({
      "message": errorMessage,
      "erreur": err
    });
  }
}

class Result{
  late final String next;
  late final List<Invoice> invoices;

  Result(this.next, this.invoices);

  factory Result.fromJson(Map<String, dynamic> parsedJson){
    List response = [];

    if(parsedJson['results']!= null){
      response = parsedJson['results'] as List;
    }else{
      response.add(parsedJson);
    }
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
