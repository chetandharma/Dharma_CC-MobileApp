import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';
import '../routes/app_routes.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("CC Operations Dashboard"),
        actions: [
          Obx(() => GestureDetector(
                onTap: () => _showProfileSheet(context, auth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: auth.userAvatar.value.isNotEmpty
                      ? CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(auth.userAvatar.value),
                        )
                      : CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.green,
                          child: Text(
                            _initials(auth.userName.value),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            dashboardCard(
              title: "Procurement",
              icon: Icons.assignment,
              onTap: () => Get.toNamed(Routes.grnList),
            ),
            dashboardCard(
              title: "Packing",
              icon: Icons.storefront_outlined,
              onTap: () => Get.toNamed(Routes.grnAssignListPage),
            ),
            dashboardCard(
              title: "Dispatch",
              icon: Icons.local_shipping,
              onTap: () => Get.toNamed(Routes.dispatchCrateList),
            ),
            dashboardCard(
              title: "Inventory",
              icon: Icons.inventory,
              onTap: () => Get.toNamed(Routes.inventoryList),
            ),
            dashboardCard(
              title: "Farmers",
              icon: Icons.person_4_outlined,
              onTap: () => Get.toNamed(Routes.farmersList),
            ),
            dashboardCard(
              title: "Reports",
              icon: Icons.bar_chart,
              onTap: () => comingSoon(),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileSheet(BuildContext context, AuthController auth) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(ctx).viewPadding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            auth.userAvatar.value.isNotEmpty
                ? CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(auth.userAvatar.value),
                  )
                : CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.green,
                    child: Text(
                      _initials(auth.userName.value),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
            const SizedBox(height: 12),
            Text(
              auth.userName.value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              auth.userEmail.value,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Text(
                auth.userRole.value,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  auth.signOut();
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty || name.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Widget dashboardCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.green),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void comingSoon() {
    Get.snackbar("Coming Soon", "Module under development");
  }
}
