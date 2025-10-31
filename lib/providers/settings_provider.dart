// providers/settings_provider.dart
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class SettingsProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  AppSettings? _settings;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AppSettings? get settings => _settings;

  Future<void> fetchAppSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(ApiConstants.appSettingUrl),
        headers: ApiConstants.getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == true) {
          _settings = AppSettings.fromJson(data['data']);
          _error = null;
        } else {
          _error = data['message'] ?? 'Failed to fetch settings';
        }
      } else {
        _error = 'Failed to load settings: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Error fetching settings: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

class AppSettings {
  final String googleMapApi;
  final String appAndroidVersion;
  final String appIosVersion;
  final bool appAndroidForceUpdate;
  final bool appIosForceUpdate;
  final bool appMaintenanceMode;
  final String supportEmailId;
  final String contactEmailId;
  final String contactNumber;
  final String whatsappNumber;
  final String updateTitle;
  final String updateMessage;
  final String playStoreLink;
  final String appStoreLink;
  final String termsAndConditionUrl;
  final String privacyUrl;

  AppSettings({
    required this.googleMapApi,
    required this.appAndroidVersion,
    required this.appIosVersion,
    required this.appAndroidForceUpdate,
    required this.appIosForceUpdate,
    required this.appMaintenanceMode,
    required this.supportEmailId,
    required this.contactEmailId,
    required this.contactNumber,
    required this.whatsappNumber,
    required this.updateTitle,
    required this.updateMessage,
    required this.playStoreLink,
    required this.appStoreLink,
    required this.termsAndConditionUrl,
    required this.privacyUrl,
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      googleMapApi: json['googleMapApi'] ?? '',
      appAndroidVersion: json['appAndroidVersion'] ?? '',
      appIosVersion: json['appIosVersion'] ?? '',
      appAndroidForceUpdate: json['appAndroidForceUpdate'] ?? false,
      appIosForceUpdate: json['appIsoForceUpdate'] ?? false, // Note: typo in API response
      appMaintenanceMode: json['appMaintenanceMode'] ?? false,
      supportEmailId: json['supportEmailId'] ?? '',
      contactEmailId: json['contactEmailId'] ?? '',
      contactNumber: json['conatctNumber'] ?? '', // Note: typo in API response
      whatsappNumber: json['whatsappNumber'] ?? '',
      updateTitle: json['updateTitle'] ?? '',
      updateMessage: json['updateMessage'] ?? '',
      playStoreLink: json['playStoreLink'] ?? '',
      appStoreLink: json['appStoreLink'] ?? '',
      termsAndConditionUrl: json['termsAndConditionUrl'] ?? '',
      privacyUrl: json['privacyUrl'] ?? '',
    );
  }
}