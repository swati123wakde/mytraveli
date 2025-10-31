// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../constants/app_strings.dart';
// import '../constants/app_colors.dart';
// import '../providers/hotel_provider.dart';
// import '../widgets/gradient_background.dart';
// import '../widgets/hotel_card.dart';
// import '../widgets/loading_widget.dart';
// import 'hotel_details_screen.dart';
//
// class SearchResultsScreen extends StatefulWidget {
//   final String searchQuery;
//
//   const SearchResultsScreen({Key? key, required this.searchQuery})
//       : super(key: key);
//
//   @override
//   State<SearchResultsScreen> createState() => _SearchResultsScreenState();
// }
//
// class _SearchResultsScreenState extends State<SearchResultsScreen> {
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
//       hotelProvider.searchHotels(widget.searchQuery);
//     });
//     _scrollController.addListener(_scrollListener);
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       final hotelProvider = Provider.of<HotelProvider>(context, listen: false);
//       if (!hotelProvider.isLoading && hotelProvider.hasMore) {
//         hotelProvider.loadMore();
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GradientBackground(
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Custom App Bar
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   children: [
//                     IconButton(
//                       icon: const Icon(
//                         Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white,
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                     const SizedBox(width: 8),
//                     const Expanded(
//                       child: Text(
//                         AppStrings.searchResults,
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Search Query Display
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(
//                     color: AppColors.accentPurple.withOpacity(0.3),
//                   ),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Searching for:',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.white.withOpacity(0.7),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.searchQuery,
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Consumer<HotelProvider>(
//                       builder: (context, hotelProvider, _) {
//                         if (hotelProvider.hotels.isNotEmpty) {
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8),
//                             child: Text(
//                               '${hotelProvider.hotels.length} ${AppStrings.hotelsFound}',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: AppColors.accentPurple,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                           );
//                         }
//                         return const SizedBox.shrink();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//
//               // Results List
//               Expanded(
//                 child: Container(
//                   decoration: const BoxDecoration(
//                     color: AppColors.backgroundDark,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Consumer<HotelProvider>(
//                     builder: (context, hotelProvider, _) {
//                       return _buildBody(hotelProvider);
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBody(HotelProvider hotelProvider) {
//     if (hotelProvider.isLoading && hotelProvider.hotels.isEmpty) {
//       return const LoadingWidget(message: 'Searching hotels...');
//     }
//
//     if (hotelProvider.errorMessage != null && hotelProvider.hotels.isEmpty) {
//       return _buildError(hotelProvider.errorMessage!);
//     }
//
//     if (hotelProvider.hotels.isEmpty) {
//       return _buildEmpty();
//     }
//
//     return RefreshIndicator(
//       onRefresh: () => hotelProvider.searchHotels(widget.searchQuery),
//       color: AppColors.primaryPurple,
//       backgroundColor: AppColors.cardDark,
//       child: ListView.builder(
//         controller: _scrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount: hotelProvider.hotels.length + (hotelProvider.hasMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= hotelProvider.hotels.length) {
//             return const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Center(
//                 child: CircularProgressIndicator(
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                     AppColors.primaryPurple,
//                   ),
//                 ),
//               ),
//             );
//           }
//
//           final hotel = hotelProvider.hotels[index];
//           return HotelCard(
//             hotel: hotel,
//             // onTap: () {
//             //   Navigator.push(
//             //     context,
//             //     MaterialPageRoute(
//             //       builder: (context) => HotelDetailsScreen(hotel: hotel),
//             //     ),
//             //   );
//             // },
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildError(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppColors.error.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.error_outline_rounded,
//                 size: 64,
//                 color: AppColors.error,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               AppStrings.error,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () {
//                 Provider.of<HotelProvider>(context, listen: false)
//                     .searchHotels(widget.searchQuery);
//               },
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text(AppStrings.retry),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primaryPurple,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 32,
//                   vertical: 16,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEmpty() {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: AppColors.primaryPurple.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.search_off_rounded,
//                 size: 64,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               AppStrings.noResults,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               AppStrings.tryDifferentSearch,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textSecondary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
