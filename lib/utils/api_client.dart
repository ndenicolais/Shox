import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<String> _loadApiKey() async {
    final file = File('config.json');
    final contents = await file.readAsString();
    final json = jsonDecode(contents);
    return json['removeBgApiKey'];
  }

  Future<Uint8List> removeBgApi(String imagePath) async {
    var apiKey = await _loadApiKey();
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.remove.bg/v1.0/removebg"));
    request.files
        .add(await http.MultipartFile.fromPath("image_file", imagePath));
    request.headers.addAll({"X-API-Key": apiKey});
    final response = await request.send();
    if (response.statusCode == 200) {
      http.Response imgRes = await http.Response.fromStream(response);
      return imgRes.bodyBytes;
    } else {
      throw Exception("Error occurred with response ${response.statusCode}");
    }
  }
}
