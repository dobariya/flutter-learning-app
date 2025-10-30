// lib/views/search_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart' hide SearchController;

class SearchView extends StatelessWidget {
  final SearchController controller = Get.lazyPut(SearchController);

  SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Example (GetX + MVC)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Box and Button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter search term...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => controller.query.value = value,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.searchItems,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Loading indicator or results
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.results.isEmpty) {
                  return const Center(
                    child: Text(
                      'No results found',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.title),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
