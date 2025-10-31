// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../providers/settings_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/gradient_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _currentPlatformVersion;

  @override
  void initState() {
    super.initState();
    _getPlatformInfo();
    // Fetch settings when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SettingsProvider>(context, listen: false).fetchAppSettings();
    });
  }

  Future<void> _getPlatformInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _currentPlatformVersion = androidInfo.version.release;
        });
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _currentPlatformVersion = iosInfo.systemVersion;
        });
      }
    } catch (e) {
      print('Error getting platform info: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showSnackBar('Could not launch $url');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      _showSnackBar('Could not launch email app');
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    // Clean the phone number - remove any spaces, dashes, etc.
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[+\-\s]'), '');
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: cleanedNumber,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      _showSnackBar('Could not make a call');
    }
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    // Clean the phone number - remove any spaces, dashes, plus sign
    final cleanedNumber = phoneNumber.replaceAll(RegExp(r'[+\-\s]'), '');
    final Uri whatsappUri = Uri(
      scheme: 'https',
      host: 'wa.me',
      path: cleanedNumber,
    );
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      _showSnackBar('Could not open WhatsApp');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildPlatformSpecificInfo(AppSettings settings) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return _buildSectionCard(
      title: 'Device Information',
      children: [
        if (_currentPlatformVersion != null)
          _buildInfoRow('OS Version', _currentPlatformVersion!),
        if (isAndroid) _buildInfoRow('App Version', settings.appAndroidVersion),
        if (isIOS) _buildInfoRow('App Version', settings.appIosVersion),
        if (isAndroid) _buildInfoRow(
          'Force Update Required',
          settings.appAndroidForceUpdate ? 'Yes' : 'No',
          isWarning: settings.appAndroidForceUpdate,
        ),
        if (isIOS) _buildInfoRow(
          'Force Update Required',
          settings.appIosForceUpdate ? 'Yes' : 'No',
          isWarning: settings.appIosForceUpdate,
        ),
        if (settings.appMaintenanceMode) _buildInfoRow(
          'Maintenance Mode',
          'Active',
          isWarning: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            if (settingsProvider.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Loading settings...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              );
            }

            if (settingsProvider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        settingsProvider.error!,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => settingsProvider.fetchAppSettings(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final settings = settingsProvider.settings;
            if (settings == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      size: 60,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No settings available',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => settingsProvider.fetchAppSettings(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                      ),
                      child: const Text('Load Settings'),
                    ),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Platform Specific Information
                _buildPlatformSpecificInfo(settings),

                const SizedBox(height: 16),

                // Contact Information
                _buildSectionCard(
                  title: 'Contact Information',
                  children: [
                    _buildActionRow(
                      'Support Email',
                      settings.supportEmailId,
                      Icons.email_outlined,
                          () => _sendEmail(settings.supportEmailId),
                    ),
                    _buildActionRow(
                      'Contact Email',
                      settings.contactEmailId,
                      Icons.contact_mail_outlined,
                          () => _sendEmail(settings.contactEmailId),
                    ),
                    _buildActionRow(
                      'Contact Number',
                      settings.contactNumber,
                      Icons.phone_outlined,
                          () => _makeCall(settings.contactNumber),
                    ),
                    _buildActionRow(
                      'WhatsApp',
                      settings.whatsappNumber,
                      Icons.chat_outlined,
                          () => _openWhatsApp(settings.whatsappNumber),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Links
                _buildSectionCard(
                  title: 'Links & Resources',
                  children: [
                    _buildActionRow(
                      'Play Store',
                      'Get the latest version',
                      Icons.android,
                          () => _launchURL(settings.playStoreLink),
                    ),
                    _buildActionRow(
                      'App Store',
                      'Download from App Store',
                      Icons.apple,
                          () => _launchURL(settings.appStoreLink),
                    ),
                    _buildActionRow(
                      'Terms & Conditions',
                      'View our terms and conditions',
                      Icons.description_outlined,
                          () => _launchURL(settings.termsAndConditionUrl),
                    ),
                    _buildActionRow(
                      'Privacy Policy',
                      'View our privacy policy',
                      Icons.privacy_tip_outlined,
                          () => _launchURL(settings.privacyUrl),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Update Information
                if (settings.updateTitle.isNotEmpty)
                  _buildSectionCard(
                    title: 'Update Available',
                    children: [
                      _buildInfoRow(
                        'Title',
                        settings.updateTitle,
                        isImportant: true,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Message',
                        settings.updateMessage,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            final isAndroid =
                                Theme.of(context).platform == TargetPlatform.android;
                            final url = isAndroid
                                ? settings.playStoreLink
                                : settings.appStoreLink;
                            _launchURL(url);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryPurple,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Update Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // App Info Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'MyTravaly App',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Version ${Theme.of(context).platform == TargetPlatform.android ? settings.appAndroidVersion : settings.appIosVersion}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      color: const Color(0xFF1D1E33),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      String label,
      String value, {
        bool isWarning = false,
        bool isImportant = false,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: isImportant ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isWarning ? Colors.orange : Colors.white,
                fontSize: 14,
                fontWeight: isImportant || isWarning
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(
      String label,
      String value,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}