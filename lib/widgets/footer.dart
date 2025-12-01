import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
              _buildFooterLink('About Us'),
              _buildFooterLink('Privacy Policy'),
              _buildFooterLink('Terms of Service'),
            ],
          ),
          const SizedBox(height: 32),

          // Social Media
          Row(
            children: [
              _buildSocialIcon(Icons.camera_alt), // Instagram placeholder
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.alternate_email), // Twitter placeholder
              const SizedBox(width: 16),
              _buildSocialIcon(Icons.facebook),
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

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Icon(icon, color: Colors.white, size: 16),
    );
  }
}
