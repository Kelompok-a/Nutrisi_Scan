import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final teamMembers = [
      {
        'nama': 'Sukma Dwi Pangesti',
        'nim': '24111814120',
        'role': 'Leader',
        'job': 'Database',
        'image': 'assets/images/profile_placeholder.png',
      },
      {
        'nama': 'Oktavia Rahma Widjianti',
        'nim': '24111814075',
        'role': 'Anggota 2',
        'job': 'Manajemen data',
        'image': 'assets/images/profile_placeholder.png',
      },
      {
        'nama': 'Rizma Indra Pramudya',
        'nim': '24111814117',
        'role': 'Anggota 3',
        'job': 'Fullstack Developer',
        'image': 'assets/images/profile_placeholder.png',
      },
      {
        'nama': 'Putera Al Khalidi',
        'nim': '24111814077',
        'role': 'Anggota 4',
        'job': 'Frontend Developer',
        'image': 'assets/images/profile_placeholder.png',
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'MEET OUR TEAM',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2.5,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'OUR TEAM',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: 60,
                height: 4,
                color: isDarkMode ? Colors.blueAccent : Colors.black,
              ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 30,
                runSpacing: 50,
                alignment: WrapAlignment.center,
                children: teamMembers.map((member) => _buildTeamMember(context, member, isDarkMode)).toList(),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, Map<String, String> member, bool isDarkMode) {
    return SizedBox(
      width: 180,
      child: Column(
        children: [
          // Hexagon Image Placeholder
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: 140,
              height: 160,
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              child: Center(
                child: Text(
                  member['nama']![0],
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey,
                  ),
                ),
                // Uncomment below to use actual images when available
                // child: Image.asset(member['image']!, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            member['nama']!.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member['role']!.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            member['job']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'NIM: ${member['nim']}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}

class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Creates a hexagon shape (pointy top/bottom)
    path.moveTo(width * 0.5, 0);
    path.lineTo(width, height * 0.25);
    path.lineTo(width, height * 0.75);
    path.lineTo(width * 0.5, height);
    path.lineTo(0, height * 0.75);
    path.lineTo(0, height * 0.25);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
