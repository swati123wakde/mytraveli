import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../models/hotel_model.dart';
import '../models/search_result_model.dart';

class HotelProvider with ChangeNotifier {
  List<Hotel> _hotels = [];
  List<SearchAutoCompleteItem> _searchSuggestions = [];
  List<String> _currencies = [];
  bool _isLoading = false;
  String? _error;
  String _visitorToken = '';
  final List<dynamic> hotelLis = [];

  List<Hotel> get hotels => _hotels;
  List<SearchAutoCompleteItem> get searchSuggestions => _searchSuggestions;
  List<String> get currencies => _currencies;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setVisitorToken(String token) {
    _visitorToken = token;
  }

  Future<void> searchAutoComplete(String query) async {
    if (query.length < 2) {
      _searchSuggestions = [];
      Future.microtask(() => notifyListeners());
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.getHeaders(visitorToken: _visitorToken),
        body: json.encode({
          'action': ApiConstants.actionSearchAutoComplete,
          'searchAutoComplete': {
            'inputText': query,
            'searchType': ApiConstants.searchTypes,
            'limit': 10,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final autoCompleteData = data['data']['autoCompleteList'];
          _searchSuggestions = _parseSearchSuggestions(autoCompleteData);
          _error = null;
        } else {
          _error = data['message'] ?? 'Search failed';
          _searchSuggestions = [];
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        _searchSuggestions = [];
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _searchSuggestions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SearchAutoCompleteItem> _parseSearchSuggestions(Map<String, dynamic> data) {
    List<SearchAutoCompleteItem> suggestions = [];

    // Parse property names
    if (data['byPropertyName']?['present'] == true) {
      final list = data['byPropertyName']['listOfResult'] as List;
      for (var item in list) {
        suggestions.add(SearchAutoCompleteItem.fromJson(item, 'property'));
      }
    }

    // Parse cities
    if (data['byCity']?['present'] == true) {
      final list = data['byCity']['listOfResult'] as List;
      for (var item in list) {
        suggestions.add(SearchAutoCompleteItem.fromJson(item, 'city'));
      }
    }

    // Parse streets
    if (data['byStreet']?['present'] == true) {
      final list = data['byStreet']['listOfResult'] as List;
      for (var item in list) {
        suggestions.add(SearchAutoCompleteItem.fromJson(item, 'street'));
      }
    }

    // Parse countries
    if (data['byCountry']?['present'] == true) {
      final list = data['byCountry']['listOfResult'] as List;
      for (var item in list) {
        suggestions.add(SearchAutoCompleteItem.fromJson(item, 'country'));
      }
    }

    return suggestions;
  }

  Future<void> getPopularStays({
    required String city,
    required String state,
    required String country,
    String currency = 'INR',
  }) async {
    _isLoading = true;
    _error = null;
    Future.microtask(() => notifyListeners());

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.getHeaders(visitorToken: _visitorToken),
        body: json.encode({
          'action': ApiConstants.actionPopularStay,
          'popularStay': {
            'limit': 10,
            'entityType': 'Any',
            'filter': {
              'searchType': 'byCity',
              'searchTypeInfo': {
                'country': country,
                'state': state,
                'city': city,
              },
            },
            'currency': currency,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("data ${data}");

        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> hotelList = data['data'];
          _hotels = hotelList.map((json) => Hotel.fromJson(json)).toList();
          print("_hotels ${_hotels.length}");
          _error = null;
        } else {
          _error = data['message'] ?? 'Failed to load hotels';
          _hotels = [];
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        _hotels = [];
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _hotels = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchHotels({
    required String checkIn,
    required String checkOut,
    required int rooms,
    required int adults,
    int children = 0,
    required String searchType,
    required List<String> searchQuery,
    String currency = 'INR',
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.getHeaders(visitorToken: _visitorToken),
        body: json.encode({
          'action': ApiConstants.actionGetSearchResult,
          'getSearchResultListOfHotels': {
            'searchCriteria': {
              'checkIn': checkIn,
              'checkOut': checkOut,
              'rooms': rooms,
              'adults': adults,
              'children': children,
              'searchType': searchType,
              'searchQuery': searchQuery,
              'accommodation': ['all'],
              'arrayOfExcludedSearchType': ['street'],
              'highPrice': '3000000',
              'lowPrice': '0',
              'limit': 20,
              'preloaderList': [],
              'currency': currency,
              'rid': 0,
            },
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> hotelList = data['data']['arrayOfHotelList'];
          _hotels = hotelList.map((json) => Hotel.fromSearchResult(json)).toList();
          _error = null;
        } else {
          _error = data['message'] ?? 'Search failed';
          _hotels = [];
        }
      } else {
        _error = 'Server error: ${response.statusCode}';
        _hotels = [];
      }
    } catch (e) {
      _error = 'Network error: ${e.toString()}';
      _hotels = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrencyList() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.baseUrl),
        headers: ApiConstants.getHeaders(visitorToken: _visitorToken),
        body: json.encode({
          'action': ApiConstants.actionGetCurrencyList,
          'getCurrencyList': {
            'baseCode': 'INR',
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true && data['data'] != null) {
          final List<dynamic> currencyList = data['data']['currencyList'];
          _currencies = currencyList
              .map((c) => '${c['currencyCode']} - ${c['currencyName']}')
              .toList();
        }
      }
    } catch (e) {
      // Silently fail currency loading
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchSuggestions = [];
    notifyListeners();
  }
}