import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/search/search_controller.dart';

class SearchWidget extends StatelessWidget {
  final String hintText;
  final Function(String)? onItemSelected;
  final SearchControllerX controller = Get.put(SearchControllerX());
  final double width;
  final double maxHeight;
  final EdgeInsetsGeometry? margin;
  final bool showResultsBelow;
  final TextEditingController? textController;

  SearchWidget({
    super.key,
    this.hintText = 'Search...',
    this.onItemSelected,
    this.width = double.infinity,
    this.maxHeight = 300,
    this.margin,
    this.showResultsBelow = true,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The search input field
        Container(
          width: width,
          margin: margin,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
            ),
            onChanged: (value) async {
              controller.query.value = value;
              if (value.isNotEmpty) {
                await Future.delayed(const Duration(milliseconds: 500));
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
        ),
        
        // Search results that will overlap content below
        Positioned(
          top: showResultsBelow ? null : 0,
          left: margin!.horizontal / 2 ?? 0,
          right: margin!.horizontal / 2 ?? 0,
          child: Container(
            width: width,
            margin: margin,
            child: Obx(() {
              if (controller.isLoading.value) {
                return _buildResultsContainer(
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }

              if (controller.results.isEmpty || controller.query.value.isEmpty) {
                return const SizedBox.shrink();
              }

              return _buildResultsContainer(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.results.length,
                  itemBuilder: (context, index) {
                    final item = controller.results[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (onItemSelected != null) {
                            onItemSelected!(item);
                          }
                          if (textController != null) {
                            textController!.text = item;
                          }
                          controller.results.clear();
                          controller.query.value = '';
                          FocusScope.of(context).unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, color: Colors.blue, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsContainer({required Widget child}) {
    return Container(
      margin: EdgeInsets.only(
        top: showResultsBelow ? 60 : 0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      child: child,
    );
  }
}
