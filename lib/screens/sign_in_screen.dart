import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_strings.dart';
import '../constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';
import 'home_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentPurple.withOpacity(0.5),
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.hotel_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // App Title
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.white,
                        AppColors.lightPurple,
                      ],
                    ).createShader(bounds),
                    child: const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    AppStrings.signInToContinue,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Sign In Card
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.accentPurple.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          AppStrings.welcomeBack,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 32),

                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return Column(
                              children: [
                                // Regular Sign In Button
                                CustomButton(
                                  text: 'Sign In',
                                  // isLoading: authProvider.isLoading,
                                  icon: const Icon(
                                    Icons.login,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  backgroundColor: AppColors.primaryPurple,
                                  textColor: Colors.white,
                                  onPressed: ()  {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(height: 16),

                                // OR Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'OR',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Google Sign In Button
                                CustomButton(
                                  text: AppStrings.signInWithGoogle,
                                  isLoading: authProvider.isLoading,
                                  icon: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  backgroundColor: Colors.white,
                                  textColor: AppColors.primaryPurple,
                                  onPressed: () async {
                                    final success = await authProvider.signIn();
                                    if (success && context.mounted) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => const HomeScreen(),
                                        ),
                                      );
                                    }
                                  },
                                ),

                                if (authProvider.errorMessage != null) ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      authProvider.errorMessage!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}