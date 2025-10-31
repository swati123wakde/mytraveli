class Hotel {
  final String propertyCode;
  final String propertyName;
  final String propertyImage;
  final String propertyType;
  final int propertyStar;
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final double latitude;
  final double longitude;
  final double markedPrice;
  final double staticPrice;
  final String currencySymbol;
  final String propertyUrl;
  final GoogleReview? googleReview;
  final PropertyPolicies? policies;

  Hotel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyImage,
    required this.propertyType,
    required this.propertyStar,
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    required this.latitude,
    required this.longitude,
    required this.markedPrice,
    required this.staticPrice,
    required this.currencySymbol,
    required this.propertyUrl,
    this.googleReview,
    this.policies,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    final address = json['propertyAddress'];
    final markedPriceData = json['markedPrice'];
    final staticPriceData = json['staticPrice'];

    return Hotel(
      propertyCode: json['propertyCode'] ?? '',
      propertyName: json['propertyName'] ?? '',
      propertyImage: json['propertyImage'] ?? '',
      propertyType: json['propertyType'] ?? 'hotel',
      propertyStar: json['propertyStar'] ?? 3,
      street: address['street'] ?? '',
      city: address['city'] ?? '',
      state: address['state'] ?? '',
      country: address['country'] ?? '',
      zipcode: address['zipcode'] ?? '',
      latitude: (address['latitude'] ?? 0.0).toDouble(),
      longitude: (address['longitude'] ?? 0.0).toDouble(),
      markedPrice: (markedPriceData['amount'] ?? 0.0).toDouble(),
      staticPrice: (staticPriceData['amount'] ?? 0.0).toDouble(),
      currencySymbol: markedPriceData['currencySymbol'] ?? '₹',
      propertyUrl: json['propertyUrl'] ?? '',
      googleReview: json['googleReview'] != null && json['googleReview']['reviewPresent'] == true
          ? GoogleReview.fromJson(json['googleReview']['data'])
          : null,
      policies: json['propertyPoliciesAndAmmenities']?['present'] == true
          ? PropertyPolicies.fromJson(json['propertyPoliciesAndAmmenities']['data'])
          : null,
    );
  }

  factory Hotel.fromSearchResult(Map<String, dynamic> json) {
    final address = json['propertyAddress'];
    final minPrice = json['propertyMinPrice'];
    final maxPrice = json['propertyMaxPrice'];
    final markedPrice = json['markedPrice'];

    return Hotel(
      propertyCode: json['propertyCode'] ?? '',
      propertyName: json['propertyName'] ?? '',
      propertyImage: json['propertyImage']?['fullUrl'] ?? '',
      propertyType: json['propertytype'] ?? 'Hotel',
      propertyStar: json['propertyStar'] ?? 3,
      street: address['street'] ?? '',
      city: address['city'] ?? '',
      state: address['state'] ?? '',
      country: address['country'] ?? '',
      zipcode: address['zipcode'] ?? '',
      latitude: (address['latitude'] ?? 0.0).toDouble(),
      longitude: (address['longitude'] ?? 0.0).toDouble(),
      markedPrice: (markedPrice['amount'] ?? 0.0).toDouble(),
      staticPrice: (minPrice['amount'] ?? 0.0).toDouble(),
      currencySymbol: minPrice['currencySymbol'] ?? '₹',
      propertyUrl: json['propertyUrl'] ?? '',
      googleReview: json['googleReview']?['reviewPresent'] == true
          ? GoogleReview.fromJson(json['googleReview']['data'])
          : null,
      policies: json['propertyPoliciesAndAmmenities']?['present'] == true
          ? PropertyPolicies.fromJson(json['propertyPoliciesAndAmmenities']['data'])
          : null,
    );
  }
}

class GoogleReview {
  final double overallRating;
  final int totalUserRating;
  final int withoutDecimal;

  GoogleReview({
    required this.overallRating,
    required this.totalUserRating,
    required this.withoutDecimal,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    return GoogleReview(
      overallRating: (json['overallRating'] ?? 0.0).toDouble(),
      totalUserRating: json['totalUserRating'] ?? 0,
      withoutDecimal: json['withoutDecimal'] ?? 0,
    );
  }
}

class PropertyPolicies {
  final String cancelPolicy;
  final String refundPolicy;
  final String childPolicy;
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;

  PropertyPolicies({
    required this.cancelPolicy,
    required this.refundPolicy,
    required this.childPolicy,
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
  });

  factory PropertyPolicies.fromJson(Map<String, dynamic> json) {
    return PropertyPolicies(
      cancelPolicy: json['cancelPolicy'] ?? 'N/A',
      refundPolicy: json['refundPolicy'] ?? 'N/A',
      childPolicy: json['childPolicy'] ?? 'N/A',
      petsAllowed: json['petsAllowed'] ?? false,
      coupleFriendly: json['coupleFriendly'] ?? false,
      suitableForChildren: json['suitableForChildren'] ?? false,
      bachularsAllowed: json['bachularsAllowed'] ?? false,
      freeWifi: json['freeWifi'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
    );
  }
}