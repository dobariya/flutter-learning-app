import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/search/search_controller.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function(String)? onItemSelected;
  final SearchControllerX controller = Get.put(SearchControllerX());

  SearchWidget({
    super.key,
    this.hintText = 'Search...',
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) async {
                controller.query.value = value;
                if (value.isNotEmpty) {
                  await Future.delayed(const Duration(seconds: 1));
                  if (value == controller.query.value) {
                    await controller.searchItems();
                  }
                } else {
                  controller.results.clear();
                }
              },
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.searchItems(),
            ),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (controller.results.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    return ListTile(
                      title: Text(item),
                      leading: const Icon(Icons.location_on, color: Colors.blue),
                      onTap: () {
                        if (onItemSelected != null) {
                          onItemSelected!(item);
                        }
                        controller.results.clear();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
