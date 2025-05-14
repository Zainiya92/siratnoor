import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/constants/colors.dart';
import 'admin_controller.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_features/dua_screen.dart';
import 'admin_features/manage_hadiths.dart';
import 'admin_features/manage_quiz.dart';
import 'admin_features/story_screen.dart';

class AdminController extends GetxController {
  var totalUsers = 0.obs;
  var totalStories = 0.obs;
  var totalDuas = 0.obs;
  var totalHadiths = 0.obs;

  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchAdminDashboardData();
  }

  Future<void> fetchAdminDashboardData() async {
    try {
      isLoading(true);

      // Fetch total users
      final userSnapshot =
          await FirebaseFirestore.instance.collection('Users').get();
      totalUsers.value = userSnapshot.docs.length;

      // Fetch total stories from nested collections: /categories/{categoryId}/events/{eventId}/stories
      int storiesCount = 0;
      final categoriesSnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      for (final categoryDoc in categoriesSnapshot.docs) {
        final eventsSnapshot = await FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryDoc.id)
            .collection('events')
            .get();

        for (final eventDoc in eventsSnapshot.docs) {
          final storiesSnapshot = await FirebaseFirestore.instance
              .collection('categories')
              .doc(categoryDoc.id)
              .collection('events')
              .doc(eventDoc.id)
              .collection('stories')
              .get();

          storiesCount += storiesSnapshot.docs.length;
        }
      }
      totalStories.value = storiesCount;

      // Fetch total duas
      final duasSnapshot =
          await FirebaseFirestore.instance.collection('duas').get();
      totalDuas.value = duasSnapshot.docs.length;

      // Fetch total hadiths
      final hadithsSnapshot =
          await FirebaseFirestore.instance.collection('hadiths').get();
      totalHadiths.value = hadithsSnapshot.docs.length;
    } catch (e) {
      print("❌ Error fetching dashboard data: $e");
    } finally {
      isLoading(false);
    }
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminController adminController = Get.put(AdminController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style:
              GoogleFonts.urbanist(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      drawer: AdminDrawer(), // Sidebar for navigation
      body: Obx(() {
        if (adminController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 30,
                  children: [
                    DashboardCard(
                      title: "Total Users",
                      count: "${adminController.totalUsers.value}",
                      icon: Icons.people,
                      color: TColors.black,
                    ),
                    DashboardCard(
                      title: "Total Stories",
                      count: "${adminController.totalStories.value}",
                      icon: Icons.book,
                      color: TColors.black,
                    ),
                    DashboardCard(
                      title: "Total Duas",
                      count: "${adminController.totalDuas.value}",
                      icon: Icons.favorite,
                      color: TColors.black,
                    ),
                    DashboardCard(
                      title: "Total Hadiths",
                      count: "${adminController.totalHadiths.value}",
                      icon: Icons.menu_book,
                      color: TColors.black,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminAuthController());

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: TColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/219/219986.png'),
                ),
                const SizedBox(height: 10),
                Text(
                  "Admin Panel",
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "admin@gmail.com",
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Manage Users'),
            onTap: () => Get.to(const ManageUsersScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Manage SAW Stories'),
            onTap: () => Get.to(const ManageStoriesScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Manage Duas'),
            onTap: () => Get.to(ManageDuasScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.menu_book),
            title: const Text('Manage Hadiths'),
            onTap: () => Get.to(ManageHadithsScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Manage Quiz'),
            onTap: () => Get.to(ManageQuizScreen()),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => _showLogoutDialog(controller),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(AdminAuthController controller) {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      textCancel: "Cancel",
      textConfirm: "Yes",
      confirmTextColor: Colors.black,
      onConfirm: controller.logout,
    );
  }
}

// Dashboard Card Widget
class DashboardCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const DashboardCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: TColors.secondary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              count,
              style: GoogleFonts.urbanist(
                fontSize: 20,
                color: TColors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.urbanist(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageUsersScreen extends StatelessWidget {
  const ManageUsersScreen({super.key});

  void _showDisableDialog(BuildContext context, String userId, bool isEnabled) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEnabled ? "Disable User" : "Enable User"),
        content: Text(
            "Are you sure you want to ${isEnabled ? "disable" : "enable"} this account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(userId)
                  .update({'enabled': !isEnabled});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        "User account ${isEnabled ? "disabled" : "enabled"}.")),
              );
            },
            child: Text(
              isEnabled ? "Disable" : "Enable",
              style: TextStyle(color: isEnabled ? Colors.red : Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(bool isEnabled) {
    return Chip(
      label: Text(isEnabled ? 'Enabled' : 'Disabled'),
      backgroundColor: isEnabled ? Colors.green.shade100 : Colors.red.shade100,
      labelStyle: TextStyle(
        color: isEnabled ? Colors.green.shade800 : Colors.red.shade800,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Users"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              var data = user.data();
              final bool isEnabled = data['enabled'] ?? true;

              return ListTile(
                leading: CircleAvatar(child: Text(data['FirstName'][0])),
                title: Text("${data['FirstName']} ${data['LastName']}"),
                subtitle: Text(data['Email']),
                trailing: _buildStatusChip(isEnabled),
                onTap: () => _showDisableDialog(context, user.id, isEnabled),
              );
            },
          );
        },
      ),
    );
  }
}
