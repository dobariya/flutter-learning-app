// lib/controllers/search_controller.dart
import 'dart:js_interop';

import 'package:get/get.dart';
import '../../services/api_service.dart';
import 'search_model.dart';

class SearchControllerX extends GetxController {
  final _apiService = ApiService();

  /// Text input by user
  var query = ''.obs;

  /// Search results list
  // var results = <SearchModel>[].obs;
  var results = <String>[].obs;
  var address = <Map<String, dynamic>>[].obs;
  var data = <String, dynamic>{}.obs;
  var apiResponse;

  /// Loading statea
  var isLoading = false.obs;

  /// Dummy data to search from

  /// Search for hotels using the API
  Future<void> searchItems() async {
    if (query.value.isEmpty) {
      results.clear();
      return;
    }

    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      final response = await _apiService.searchHotel(query.value);
      apiResponse = response;
      // Map the API response to your results list
      results.value = response
          .map<String>((item) => item['display_name']?.toString() ?? 'No name')
          .toList();

      var hotels = response
          .map<String>((item) => item['type']?.toString() ?? 'No name')
          .toList();

      print(hotels);
    } catch (e) {
      print('Error searching hotels: $e');
      // Optionally show error to user
      // Get.snackbar('Error', 'Failed to search for hotels');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAddress(String name) async {
    final filtered = apiResponse
        .where((item) => item['display_name'] == name)
        .map<Map<String, dynamic>>(
            (item) => Map<String, dynamic>.from(item['address'] ?? {}))
        .toList();

    address.value = filtered; // address is RxList<Map<String, dynamic>>
    data.assignAll(address.firstOrNull ?? {}); // safely assign first address map

    print(data["city"]);
    print(data["country"]);
    print(data["postcode"]);
    print(address);
  }
}
