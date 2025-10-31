// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/hotel_model.dart';
//
// class ApiService {
//   static const String baseUrl = 'https://api.mytravaly.com/public/v1/';
//   static const String authToken = '71523fdd8d26f585315b4233e39d9263';
//
//   Future<Map<String, dynamic>> searchHotels({
//     required String query,
//     int page = 1,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${baseUrl}hotels?search=$query&page=$page'),
//         headers: {
//           'authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         final hotels = (data['data'] as List?)
//             ?.map((json) => HotelModel.fromJson(json))
//             .toList() ?? [];
//
//         return {
//           'hotels': hotels,
//           'hasMore': data['next_page_url'] != null,
//           'currentPage': data['current_page'] ?? page,
//           'total': data['total'] ?? 0,
//         };
//       } else {
//         throw Exception('Failed to load hotels: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching hotels: $e');
//     }
//   }
//
//   Future<HotelModel?> getHotelDetails(String hotelId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('${baseUrl}hotels/$hotelId'),
//         headers: {
//           'Authorization': 'Bearer $authToken',
//           'Content-Type': 'application/json',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         return HotelModel.fromJson(data['data']);
//       }
//       return null;
//     } catch (e) {
//       throw Exception('Error fetching hotel details: $e');
//     }
//   }
// }