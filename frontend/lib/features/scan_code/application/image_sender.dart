import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<String?> sendImageToBackend(File imageFile) async {
  try {
    final baseUrl = dotenv.env['API_BASE_URL'];
    final uri = Uri.parse('$baseUrl/explain-image');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      return data['explanation'];
    } else {
      print('Backend error: ${response.statusCode}');
      return 'Failed to get explanation.';
    }
  } catch (e) {
    print('Error sending image: $e');
    return 'Error communicating with backend.';
  }
}

Future<String> extractCodeOnly(File imageFile) async {
  final baseUrl = dotenv.env['API_BASE_URL'];
  final uri = Uri.parse('$baseUrl/extract-code');
  final request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  try {
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(responseBody);
      return jsonData['code'] ?? 'No code found';
    } else {
      return 'Error extracting code';
    }
  } catch (e) {
    return 'Error: $e';
  }
}
