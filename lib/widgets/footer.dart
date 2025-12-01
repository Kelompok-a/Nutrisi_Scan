import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/info/about_us_page.dart';
import '../screens/info/privacy_policy_page.dart';
import '../screens/info/terms_of_service_page.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      color: AppTheme.kTextColor, // Dark background for footer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Tagline
          Row(
            children: [
              const Icon(Icons.health_and_safety, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                'NutriScan',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your personal nutrition assistant for a healthier lifestyle.',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
          const SizedBox(height: 32),

          // Links
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterLink(context, 'About Us', const AboutUsPage()),
              _buildFooterLink(context, 'Privacy Policy', const PrivacyPolicyPage()),
              _buildFooterLink(context, 'Terms of Service', const TermsOfServicePage()),
            ],
          ),
          const SizedBox(height: 32),

          // Copyright
          Center(
            child: Text(
              '© 2024 NutriScan. All rights reserved.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
