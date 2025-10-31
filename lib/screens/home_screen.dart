import 'package:flutter/material.dart';
import 'package:hotel_finder/screens/settings_screen.dart';
import 'package:hotel_finder/screens/sign_in_screen.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../providers/hotel_provider.dart';
import '../providers/device_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/hotel_card.dart';
import '../widgets/search_bar_widget.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 2));
  int _rooms = 1;
  int _adults = 2;
  int _children = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final hotelProvider = Provider.of<HotelProvider>(context, listen: false);

    if (deviceProvider.visitorToken != null) {
      hotelProvider.setVisitorToken(deviceProvider.visitorToken!);
      // Load popular stays for a default city
      hotelProvider.getPopularStays(
        city: 'Jamshedpur',
        state: 'Jharkhand',
        country: 'India',
      );
      hotelProvider.getCurrencyList();
    }
  }

  void _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              surface: Color(0xFF1D1E33),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate
              .isBefore(_checkInDate.add(const Duration(days: 1)))) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _showGuestSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1D1E33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Guests',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildGuestCounter(
                    'Rooms',
                    _rooms,
                    (value) {
                      setState(() => _rooms = value);
                      setModalState(() => _rooms = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGuestCounter(
                    'Adults',
                    _adults,
                    (value) {
                      setState(() => _adults = value);
                      setModalState(() => _adults = value);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildGuestCounter(
                    'Children',
                    _children,
                    (value) {
                      setState(() => _children = value);
                      setModalState(() => _children = value);
                    },
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 16, color: AppColors.primaryDark),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGuestCounter(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > (label == 'Children' ? 0 : 1)
                  ? () => onChanged(value - 1)
                  : null,
              icon: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: value > (label == 'Children' ? 0 : 1)
                      ? AppColors.primaryPurple
                      : Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove,
                    color: AppColors.primaryDark, size: 20),
              ),
            ),
            Container(
              width: 40,
              alignment: Alignment.center,
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            IconButton(
              onPressed: value < 10 ? () => onChanged(value + 1) : null,
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: value < 10 ? AppColors.primaryPurple : Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: AppColors.primaryDark, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appName,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Find your perfect stay',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                    Consumer<AuthProvider>(builder: (context, authProvider, _) {
                      return CircleAvatar(
                        backgroundColor: AppColors.primaryPurple,
                        child: PopupMenuButton<String>(
                          color: AppColors.primaryPurple,
                          icon: const Icon(Icons.person, color: Colors.white),
                          onSelected: (value) async {
                            switch (value) {
                              case 'signOut':
                                // Handle sign out
                                final success = await authProvider.signOut();
                                if ( context.mounted) {
                                  await authProvider.signOut();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const SignInScreen(),
                                    ),
                                  );
                                }
                                case 'Setting':
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsScreen(),
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem<String>(
                              value: 'signOut',
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Sign Out',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Setting',
                              child: Row(
                                children: [
                                  Icon(Icons.settings, color: Colors.black),
                                  SizedBox(width: 8),
                                  Text('Setting',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  ],
                ),
              ),

              // Search Section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1D1E33),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SearchBarWidget(
                      controller: _searchController,
                      onSearch: (suggestion) {
                        // Handle search
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDateField(
                            'Check-in',
                            _checkInDate,
                            () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildDateField(
                            'Check-out',
                            _checkOutDate,
                            () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () => _showGuestSelector(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF111328),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.people,
                                  color: AppColors.info,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  '$_rooms Room, $_adults Adults, $_children Children',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white60,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Perform search
                          final hotelProvider = Provider.of<HotelProvider>(
                            context,
                            listen: false,
                          );
                          // This would use the search query from suggestions
                          hotelProvider.getPopularStays(
                            city: 'Jamshedpur',
                            state: 'Jharkhand',
                            country: 'India',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurpleLight,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Search Hotels',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Hotels List
              Expanded(
                child: Consumer<HotelProvider>(
                  builder: (context, hotelProvider, child) {
                    if (hotelProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }

                    if (hotelProvider.error != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 60,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              hotelProvider.error!,
                              style: const TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () => _loadInitialData(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (hotelProvider.hotels.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hotels found',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: hotelProvider.hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(hotel: hotelProvider.hotels[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFF111328),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('MMM dd').format(date),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
