import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_farmer_page.dart';
import 'farmer_controller.dart';
import 'farmer_detail_page.dart';

class FarmerListPage extends StatelessWidget {
  FarmerListPage({super.key});

  final FarmerController controller = Get.put(FarmerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmers'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              controller.statusFilter.value = value;
            },
            icon: const Icon(Icons.filter_list),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'all', child: Text('All')),
              PopupMenuItem(value: 'active', child: Text('Active')),
              PopupMenuItem(value: 'inactive', child: Text('Inactive')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Get.to(() => AddFarmerPage());
              if (result == true) {
                controller.fetchFarmers();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          /// 🔍 Search Field
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name or code...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                controller.searchQuery.value = value;
              },
            ),
          ),

          /// 📋 Farmer List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredFarmers.isEmpty) {
                return const Center(
                  child: Text(
                    'No farmers found',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.fetchFarmers,
                child: ListView.separated(
                  itemCount: controller.filteredFarmers.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final farmer =
                    controller.filteredFarmers[index];

                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          farmer.name[0].toUpperCase(),
                        ),
                      ),
                      title: Text(
                        "${farmer.name} (${farmer.farmerCode})",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          const Icon(Icons.star,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(farmer.rating.toString()),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: farmer.isActive
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              farmer.isActive
                                  ? "Active"
                                  : "Inactive",
                              style: TextStyle(
                                fontSize: 12,
                                color: farmer.isActive
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14),
                      onTap: () {
                        Get.to(
                              () => FarmerDetailPage(),
                          arguments: farmer,
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}