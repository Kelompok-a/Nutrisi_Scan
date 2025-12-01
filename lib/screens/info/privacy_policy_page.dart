import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white70 : Colors.black54;
    final titleColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('1. Introduction', titleColor),
            _buildParagraph(
              'Welcome to NutriScan. We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you as to how we look after your personal data when you visit our application and tell you about your privacy rights and how the law protects you.',
              textColor,
            ),
            _buildSectionTitle('2. Information We Collect', titleColor),
            _buildParagraph(
              'We may collect, use, store and transfer different kinds of personal data about you which we have grouped together follows: Identity Data, Contact Data, and Usage Data. We do not collect any Special Categories of Personal Data about you.',
              textColor,
            ),
            _buildSectionTitle('3. How We Use Your Data', titleColor),
            _buildParagraph(
              'We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances: Where we need to perform the contract we are about to enter into or have entered into with you.',
              textColor,
            ),
            _buildSectionTitle('4. Data Security', titleColor),
            _buildParagraph(
              'We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used or accessed in an unauthorized way, altered or disclosed.',
              textColor,
            ),
            _buildSectionTitle('5. Contact Us', titleColor),
            _buildParagraph(
              'If you have any questions about this privacy policy or our privacy practices, please contact us at support@nutriscan.id.',
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
