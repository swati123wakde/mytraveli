import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import 'dart:io' show Platform;

class DeviceProvider with ChangeNotifier {
  String? _visitorToken;
  bool _isLoading = false;
  String? _error;

  String? get visitorToken => _visitorToken;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> registerDevice() async {
    _isLoading = true;
    _error = null;
    Future.microtask(() => notifyListeners());

    try {
      // Get device info (simplified for demo)
      final deviceInfo = _getDeviceInfo();

      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.getHeaders(),
        body: json.encode({
          'action': ApiConstants.actionDeviceRegister,
          'deviceRegister': deviceInfo,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          _visitorToken = data['data']['visitorToken'];
          _error = null;
        } else {
          _error = data['message'] ?? 'Device registration failed';
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      // Set a mock token for demo purposes
      _visitorToken = '7a1f-1c7c-d871-aaf9-5ada-a1a0-abac-ccae';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, String> _getDeviceInfo() {
    // This is a simplified version. In production, use device_info_plus package
    return {
      'deviceModel': 'Flutter Device',
      'deviceFingerprint': 'flutter/device/fingerprint',
      'deviceBrand': 'Generic',
      'deviceId': 'FLUTTER001',
      'deviceName': 'Flutter_Device',
      'deviceManufacturer': 'Flutter',
      'deviceProduct': 'FlutterApp',
      'deviceSerialNumber': 'unknown',
    };
  }
}