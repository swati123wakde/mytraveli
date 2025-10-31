class ApiConstants {
  // Base URLs
  static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
  static const String appSettingUrl = 'https://api.mytravaly.com/public/v1/appSetting';

  // Auth Token
  static const String authToken = '71523fdd8d26f585315b4233e39d9263';

  // Actions
  static const String actionDeviceRegister = 'deviceRegister';
  static const String actionSearchAutoComplete = 'searchAutoComplete';
  static const String actionPopularStay = 'popularStay';
  static const String actionGetSearchResult = 'getSearchResultListOfHotels';
  static const String actionGetCurrencyList = 'getCurrencyList';

  // Headers
  static Map<String, String> getHeaders({String? visitorToken}) {
    final headers = {
      'Content-Type': 'application/json',
      'authtoken': authToken,
    };

    if (visitorToken != null && visitorToken.isNotEmpty) {
      headers['visitortoken'] = visitorToken;
    }

    return headers;
  }

  // Search Types
  static const List<String> searchTypes = [
    'byCity',
    'byState',
    'byCountry',
    'byRandom',
    'byPropertyName',
  ];

  // Accommodation Types
  static const List<String> accommodationTypes = [
    'all',
    'hotel',
    'resort',
    'Boat House',
    'bedAndBreakfast',
    'guestHouse',
    'Holidayhome',
    'cottage',
    'apartment',
    'Home Stay',
    'hostel',
    'Guest House',
    'Camp_sites/tent',
    'co_living',
    'Villa',
    'Motel',
    'Capsule Hotel',
    'Dome Hotel',
  ];

  // Entity Types
  static const List<String> entityTypes = [
    'Any',
    'hotel',
    'resort',
    'Home Stay',
    'Camp_sites/tent',
  ];
}