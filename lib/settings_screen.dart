import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';
import 'providers/theme_provider.dart';
import 'widgets/custom_header_background.dart';
import 'widgets/section_title.dart';
import 'widgets/settings_divider.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'ตั้งค่า',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                const CustomHeaderBackground(height: 50, borderRadius: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      // Profile Card
                      _buildProfileCard(context),
                      const SizedBox(height: 20),

                      // General Settings Section
                      const SectionTitle(title: 'ทั่วไป', fontSize: 16),
                      const SizedBox(height: 10),
                      SettingsGroup(
                        children: [
                          SettingsTile(
                            icon: FontAwesomeIcons.moon,
                            title: 'โหมดมืด',
                            subtitle: 'เปลี่ยนธีมแอปพลิเคชัน',
                            color: Colors.indigoAccent,
                            onTap: () {
                              final provider = Provider.of<ThemeProvider>(
                                context,
                                listen: false,
                              );
                              provider.toggleTheme(!provider.isDarkMode);
                            },
                            trailing: Switch(
                              value: Provider.of<ThemeProvider>(
                                context,
                              ).isDarkMode,
                              onChanged: (value) {
                                Provider.of<ThemeProvider>(
                                  context,
                                  listen: false,
                                ).toggleTheme(value);
                              },
                              activeColor: AppColors.primary,
                            ),
                          ),
                          const SettingsDivider(),
                          SettingsTile(
                            icon: FontAwesomeIcons.bell,
                            title: 'การแจ้งเตือน',
                            subtitle: 'เปิด/ปิด การแจ้งเตือน',
                            color: Colors.orange,
                            onTap: () {},
                          ),
                          const SettingsDivider(),
                          SettingsTile(
                            icon: FontAwesomeIcons.language,
                            title: 'ภาษา',
                            subtitle: 'ไทย',
                            color: Colors.blue,
                            onTap: () {},
                          ),
                          const SettingsDivider(),
                          SettingsTile(
                            icon: FontAwesomeIcons.coins,
                            title: 'สกุลเงิน',
                            subtitle: 'THB (฿)',
                            color: Colors.purple,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Data & Privacy Section
                      const SectionTitle(
                        title: 'ข้อมูลและความปลอดภัย',
                        fontSize: 16,
                      ),
                      const SizedBox(height: 10),
                      SettingsGroup(
                        children: [
                          SettingsTile(
                            icon: FontAwesomeIcons.cloudArrowUp,
                            title: 'สำรองข้อมูล',
                            subtitle: 'ซิงค์ข้อมูลกับ Cloud',
                            color: Colors.indigo,
                            onTap: () {},
                          ),
                          const SettingsDivider(),
                          SettingsTile(
                            icon: FontAwesomeIcons.lock,
                            title: 'ความปลอดภัย',
                            subtitle: 'รหัสผ่าน, Face ID',
                            color: Colors.green,
                            onTap: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Other Section
                      const SectionTitle(title: 'อื่นๆ', fontSize: 16),
                      const SizedBox(height: 10),
                      SettingsGroup(
                        children: [
                          SettingsTile(
                            icon: FontAwesomeIcons.circleInfo,
                            title: 'เกี่ยวกับแอป',
                            subtitle: 'เวอร์ชั่น 1.0.0',
                            color: Colors.grey,
                            onTap: () {},
                          ),
                          const SettingsDivider(),
                          SettingsTile(
                            icon: FontAwesomeIcons.rightFromBracket,
                            title: 'ออกจากระบบ',
                            titleColor: Colors.red,
                            iconColor: Colors.red,
                            color: Colors.red.withValues(alpha: 0.1),
                            onTap: () {},
                            showArrow: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
              image: const DecorationImage(
                image: NetworkImage('https://i.pravatar.cc/150?img=12'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Andrew User',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'andrew.user@email.com',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'สมาชิก Premium',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.penToSquare, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
