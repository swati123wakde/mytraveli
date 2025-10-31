// import 'package:flutter/material.dart';
// import '../constants/app_strings.dart';
// import '../constants/app_colors.dart';
// import '../models/hotel_model.dart';
// import '../widgets/gradient_background.dart';
//
// class HotelDetailsScreen extends StatelessWidget {
//   final Hotel hotel;
//
//   const HotelDetailsScreen({Key? key, required this.hotel}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: CustomScrollView(
//           slivers: [
//             // App Bar with Image
//             SliverAppBar(
//               expandedHeight: 300,
//               pinned: true,
//               backgroundColor: Colors.transparent,
//               leading: IconButton(
//                 icon: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(
//                     Icons.arrow_back_ios_new_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               flexibleSpace: FlexibleSpaceBar(
//                 background: hotel.image != null
//                     ? Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.network(
//                       hotel.!,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) {
//                         return _buildPlaceholder();
//                       },
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.7),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 )
//                     : _buildPlaceholder(),
//               ),
//             ),
//
//             // Content
//             SliverToBoxAdapter(
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: AppColors.backgroundDark,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Hotel Name and Rating
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               hotel.name,
//                               style: const TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.textPrimary,
//                               ),
//                             ),
//                           ),
//                           if (hotel.rating != null)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     AppColors.primaryPurple,
//                                     AppColors.accentPurple,
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.star,
//                                     size: 18,
//                                     color: Colors.amber,
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     hotel.rating!.toStringAsFixed(1),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.textPrimary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//
//                       // Location
//                       Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: AppColors.primaryPurple.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: const Icon(
//                               Icons.location_on_rounded,
//                               color: AppColors.accentPurple,
//                               size: 20,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               hotel.location,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//
//                       // Price
//                       if (hotel.price != null) ...[
//                         Container(
//                           padding: const EdgeInsets.all(20),
//                           decoration: BoxDecoration(
//                             gradient: AppColors.cardGradient,
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: AppColors.accentPurple.withOpacity(0.3),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.payments_rounded,
//                                 color: AppColors.accentPurple,
//                                 size: 32,
//                               ),
//                               const SizedBox(width: 16),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'Price per night',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.textSecondary,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     '₹${hotel.price!.toStringAsFixed(0)}',
//                                     style: const TextStyle(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: AppColors.textPrimary,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                       ],
//
//                       // Description
//                       if (hotel.description != null) ...[
//                         const Text(
//                           'About',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: AppColors.cardDark,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             hotel.description!,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               height: 1.6,
//                               color: AppColors.textSecondary,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 24),
//                       ],
//
//                       // Amenities
//                       if (hotel.amenities != null && hotel.amenities!.isNotEmpty) ...[
//                         const Text(
//                           'Amenities',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.textPrimary,
//                           ),
//                         ),
//                         const SizedBox(height: 12),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: hotel.amenities!.map((amenity) {
//                             return Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 10,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     AppColors.primaryPurple.withOpacity(0.3),
//                                     AppColors.accentPurple.withOpacity(0.3),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 amenity,
//                                 style: const TextStyle(
//                                   color: AppColors.textPrimary,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 32),
//                       ],
//
//                       // Book Button
//                       SizedBox(
//                         width: double.infinity,
//                         height: 56,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Booking feature coming soon!'),
//                                 backgroundColor: AppColors.primaryPurple,
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryPurple,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 8,
//                           ),
//                           child: const Text(
//                             AppStrings.bookNow,
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlaceholder() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [
//             AppColors.primaryPurple.withOpacity(0.5),
//             AppColors.secondaryPurple.withOpacity(0.5),
//           ],
//         ),
//       ),
//       child: const Center(
//         child: Icon(
//           Icons.hotel_rounded,
//           size: 100,
//           color: Colors.white54,
//         ),
//       ),
//     );
//   }
// }
