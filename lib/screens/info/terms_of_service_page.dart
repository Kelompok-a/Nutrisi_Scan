import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white70 : Colors.black54;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Acceptance of Terms', titleColor),
            _buildParagraph(
              'By accessing and using NutriScan, you accept and agree to be bound by the terms and provision of this agreement. In addition, when using these particular services, you shall be subject to any posted guidelines or rules applicable to such services.',
              textColor,
            ),
            _buildSectionTitle('2. Description of Service', titleColor),
            _buildParagraph(
              'NutriScan provides users with nutrition information and product scanning capabilities. You are responsible for obtaining access to the Service and that access may involve third party fees (such as Internet service provider or airtime charges).',
              textColor,
            ),
            _buildSectionTitle('3. User Conduct', titleColor),
            _buildParagraph(
              'You agree to use the Service only for purposes that are legal, proper and in accordance with these Terms and any applicable policies or guidelines. You agree not to misuse the scanning feature or attempt to disrupt the service.',
              textColor,
            ),
            _buildSectionTitle('4. Disclaimer of Warranties', titleColor),
            _buildParagraph(
              'The service is provided on an "as is" and "as available" basis. NutriScan expressly disclaims all warranties of any kind, whether express or implied, including, but not limited to the implied warranties of merchantability, fitness for a particular purpose and non-infringement.',
              textColor,
            ),
            _buildSectionTitle('5. Changes to Terms', titleColor),
            _buildParagraph(
              'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. What constitutes a material change will be determined at our sole discretion.',
              textColor,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        height: 1.5,
        color: color,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
