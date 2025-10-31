// lib/controllers/search_controller.dart
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

      
      // Map the API response to your results list
      results.value = response
          .map<String>((item) => item['display_name']?.toString() ?? 'No name')
          .toList();

      var hotels = response
          .map<String>((item) => item['type']?.toString() ?? 'No name')
          .toList();
          
      print (hotels);

    } catch (e) {
      print('Error searching hotels: $e');
      // Optionally show error to user
      // Get.snackbar('Error', 'Failed to search for hotels');
    } finally {
      isLoading.value = false;
    }
  }
}
