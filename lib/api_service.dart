import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "http://127.0.0.1:8000/api/ecg-data/"; // Replace with actual API URL

  static Future<List<Map<String, double>>> fetchECGData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      } else {
        print("API Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  static List<Map<String, double>> _parseResponse(String body) {
    final data = jsonDecode(body);

    if (data == null || data["timestamps"] == null || data["ecg_values"] == null) {
      print("Empty API Response");
      return [];
    }

    final List<dynamic> timestamps = data["timestamps"];
    final List<dynamic> values = data["ecg_values"];

    if (timestamps.isEmpty || values.isEmpty) {
      print("No ECG data received");
      return [];
    }

    return List.generate(
      values.length,
          (index) => {
        "timestamp": timestamps[index] / 1000.0,  // Convert to seconds
        "value": values[index]?.toDouble() ?? 0.0,
      },
    );
  }
}
