import 'package:flutter/material.dart';
import 'package:uts_project/model/user_data.dart';

class UserPage extends StatelessWidget {
  final User user;
  
  const UserPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${user.name.first} ${user.name.last}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            /// Display the user's profile picture.
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(user.picture),
            ),
            const SizedBox(height: 20),
            /// Display the user's name.
            Text(
              '${user.name.first} ${user.name.last}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            /// Display the user's email.
            Text(
              user.email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            // Display additional user information
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(Icons.phone, user.phone),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(Icons.location_on, user.location),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.person_outline,
                      user.gender == 'male' ? 'Laki-laki' : 'Perempuan',
                    ),
                  ],
                ),

              ],
            ),
            const SizedBox(height: 30),
            /// Display additional information about the user.
            _buildInfoCard(
              icon: Icons.person,
              title: 'Edit Profil',
              subtitle: 'Edit informasi profil Anda.',
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              icon: Icons.settings,
              title: 'Kandang',
              subtitle: 'Lihat kandang Anda.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        /// The title is a bold text.
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Add navigation or action here
        },
      ),
    );
  }
}