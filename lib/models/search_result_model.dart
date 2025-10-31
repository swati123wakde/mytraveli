class SearchAutoCompleteItem {
  final String displayValue;
  final String type;
  final Map<String, dynamic> searchArray;
  final String? city;
  final String? state;
  final String? country;

  SearchAutoCompleteItem({
    required this.displayValue,
    required this.type,
    required this.searchArray,
    this.city,
    this.state,
    this.country,
  });

  factory SearchAutoCompleteItem.fromJson(Map<String, dynamic> json, String type) {
    final address = json['address'] ?? {};

    return SearchAutoCompleteItem(
      displayValue: json['valueToDisplay'] ?? '',
      type: type,
      searchArray: json['searchArray'] ?? {},
      city: address['city'],
      state: address['state'],
      country: address['country'],
    );
  }

  String get subtitle {
    List<String> parts = [];
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.join(', ');
  }

  String get icon {
    switch (type) {
      case 'property':
        return '🏨';
      case 'city':
        return '🏙️';
      case 'street':
        return '📍';
      case 'country':
        return '🌍';
      default:
        return '📍';
    }
  }
}