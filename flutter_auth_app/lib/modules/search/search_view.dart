import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart' show SearchControllerX;

String lastValue = "";

class SearchView extends GetView<SearchControllerX> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Example (GetX)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                // Search Box
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (value) async {
                    controller.query.value = value;
                    lastValue = value;

                    if (value.isNotEmpty) {
                      await Future.delayed(const Duration(seconds: 2));
                      if (lastValue == value) {
                        controller.searchItems();
                      }
                    } else {
                      controller.results.clear();
                    }
                  },
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => controller.searchItems(),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 100,
                  width: double.infinity,
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: const Text(
                    'Blue Box',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),

            // Results
            Positioned(
              top:
                  70, // Adjust this value based on your layout (height of search bar + padding)
              left: 0,
              right: 0,
              bottom: 0,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.query.value.isEmpty) {
                  return const Center(
                    child: Text(
                      'Enter a search term',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                if (controller.results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No results for "${controller.query.value}"',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    return GestureDetector(
                      onTap: () => controller.getAddress(item),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item),
                          leading: const Icon(Icons.search),
                        ),
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
