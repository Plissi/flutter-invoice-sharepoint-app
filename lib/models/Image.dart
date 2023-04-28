import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:transmission_facture_client/environment.dart';

class Picture {
  String imagePath;
  String imageName;

  Picture(this.imagePath, this.imageName);

  factory Picture.fromJson(Map<String, dynamic> json){
    return Picture(json['imagePath'], json['imagePath']);
  }
}

/*Future<http.Response> sendPicture(Picture image) async{
  Uri uri = Environment.uriUploadImage;

  final response = await http.post(
    uri,
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'imagePath': image.imagePath,
      'imageName': image.imageName
    }),
  );

  return response;
}*/

void uploadPicture(XFile imageFile, int invoiceID) async {
  String digest = await getDigest();

  var stream = http.ByteStream(imageFile.openRead());
  stream.cast();
  var length = await imageFile.length();

  var filePath = imageFile.path;
  var fileName = path.basename(filePath);
  var fileExtension = path.extension(filePath);

  Uri uri = Environment().getUriUploadImage(invoiceID!, digest, filePath, fileName);

  var request = http.MultipartRequest("POST", uri);
  var multipartFile = http.MultipartFile('imageFile', stream, length,
      filename: fileName, contentType: MediaType('image', fileExtension)
  );

  request.files.add(multipartFile);
  var response = await request.send();
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}

Future<String> getDigest() async {
  Uri uri = Environment.uriDigest;

  final response = await http.post(uri);

  if (response.statusCode == 200) {
    var parsed = json.decode(response.body);
    return parsed;
  } else {
    print(response.statusCode);
    throw Exception('Failed to get Data');
  }
}