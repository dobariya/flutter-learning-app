// lib/controllers/search_controller.dart
import 'package:get/get.dart';
import 'search_model.dart';

class SearchController extends GetxController {
  /// Text input by user
  var query = ''.obs;

  /// Search results list
  var results = <SearchModel>[].obs;

  /// Loading state
  var isLoading = false.obs;

  /// Dummy data to search from
  final List<SearchModel> allItems = [
    SearchModel(title: 'Apple'),
    SearchModel(title: 'Banana'),
    SearchModel(title: 'Orange'),
    SearchModel(title: 'Mango'),
    SearchModel(title: 'Grapes'),
    SearchModel(title: 'Pineapple'),
    SearchModel(title: 'Strawberry'),
  ];

  /// Function to simulate a search
  Future<void> searchItems() async {
    if (query.value.isEmpty) return;

    isLoading.value = true;

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Filter results based on the query
    results.value = allItems
        .where((item) =>
            item.title.toLowerCase().contains(query.value.toLowerCase()))
        .toList();

    isLoading.value = false;
  }
}
