import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Edit',
              style: TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
        ],
      ),
      body: StreamBuilder<UserModel?>(
        stream: FirebaseService().getUser(
          FirebaseAuth.instance.currentUser?.uid ?? '',
        ),
        builder: (context, snapshot) {
          final user = snapshot.data;
          final targetCalories = user?.targetCalories ?? 2200;
          final weight = user?.weight ?? 75;
          final goal = user?.goal ?? 'maintain';

          String goalText;
          if (goal == 'lose') {
            goalText = 'Lose Weight';
          } else if (goal == 'gain') {
            goalText = 'Gain Weight';
          } else {
            goalText = 'Maintain';
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User Info
                  const Text(
                    'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Member since 2023',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    children: [
                      _buildStatCard(
                        icon: Icons.local_fire_department,
                        label: 'DAILY GOAL',
                        value: '$targetCalories',
                        unit: 'kcal',
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.bolt,
                        label: 'STREAK',
                        value: '12',
                        unit: 'days',
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        icon: Icons.scale,
                        label: 'WEIGHT',
                        value: '$weight',
                        unit: 'kg',
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Dietary Preferences
                  _buildSectionHeader('Dietary Preferences', 'Manage'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildpreferenceChip('Vegan', Icons.eco, true),
                      _buildpreferenceChip(
                        'Keto',
                        Icons.egg_alt,
                        false,
                      ), // Using egg_alt as proxy for Keto/Meat
                      _buildpreferenceChip('Gluten-Free', Icons.grass, true),
                      _buildpreferenceChip('Paleo', Icons.restaurant, false),
                      _buildpreferenceChip('Nut-Free', Icons.no_food, true),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Scanning Goals
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Scanning Goals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.fitness_center,
                    title: 'Current Goal',
                    subtitle: 'Based on your plan',
                    value: goalText,
                    color: Colors.green.shade100,
                    iconColor: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  _buildGoalCard(
                    icon: Icons.water_drop,
                    title: 'Water Intake',
                    subtitle: 'Daily target',
                    value: '2.5L',
                    color: Colors.blue.shade100,
                    iconColor: Colors.blue,
                  ),
                  const SizedBox(height: 24),

                  // App Settings
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notifications'),
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (val) =>
                          setState(() => _notificationsEnabled = val),
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      trackOutlineColor: WidgetStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                  ),
                  _buildSettingItem(Icons.dark_mode, 'Dark Mode', 'System'),
                  _buildSettingItem(
                    Icons.health_and_safety,
                    'Health Integrations',
                    '',
                  ),
                  _buildSettingItem(Icons.help, 'Help & Support', ''),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Log Out'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Version 2.4.0 (Build 302)',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: unit,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          action,
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildpreferenceChip(String label, IconData icon, bool isSelected) {
    return Chip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.green : Colors.grey,
      ),
      label: Text(label),
      backgroundColor: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
      side: BorderSide.none,
      labelStyle: TextStyle(
        color: isSelected ? Colors.green.shade900 : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildGoalCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String trailing) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing.isNotEmpty)
            Text(trailing, style: const TextStyle(color: Colors.grey)),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
