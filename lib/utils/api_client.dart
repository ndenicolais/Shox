import 'dart:convert' show json;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class ApiClient {
  Future<String> _getApiKey() async {
    String jsonString = await rootBundle.loadString('config.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap['removeBgApiKey'];
  }

  Future<Uint8List> removeBgApi(String imagePath) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse("https://api.remove.bg/v1.0/removebg"));
    request.files
        .add(await http.MultipartFile.fromPath("image_file", imagePath));
    String apiKey = await _getApiKey();
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
