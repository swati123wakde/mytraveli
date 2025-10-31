import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';

  Future<String?> registerDevice() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      final body = {
        "action": "deviceRegister",
        "deviceRegister": {
          "deviceModel": androidInfo.model,
          "deviceFingerprint": androidInfo.fingerprint,
          "deviceBrand": androidInfo.brand,
          "deviceId": androidInfo.id,
          "deviceName": androidInfo.device,
          "deviceManufacturer": androidInfo.manufacturer,
          "deviceProduct": androidInfo.product,
          "deviceSerialNumber": androidInfo.serialNumber ?? "unknown"
        }
      };

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'authtoken': authToken,
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          return data['data']['visitorToken'];
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to register device: $e');
    }
  }
}