import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final teamMembers = [
      {
        'nama': 'Sukma Dwi Pangesti',
        'nim': '24111814120',
        'role': 'Leader',
        'roleDetail': 'Anggota 1',
        'job': 'Database',
        'image': 'assets/images/profile_placeholder.png', // Placeholder
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
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Meet Our Team',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The brilliant minds behind NutriScan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return _buildTeamCard(context, member);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, Map<String, String> member) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[100],
              child: Text(
                member['nama']![0],
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              // backgroundImage: AssetImage(member['image']!), // Uncomment if assets exist
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member['nama']!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${member['nim']}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      member['roleDetail'] != null 
                          ? '${member['role']} (${member['roleDetail']})' 
                          : member['role']!,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    member['job']!,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
