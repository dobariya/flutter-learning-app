import 'package:flutter/material.dart';
import 'package:flutter_auth_app/routes/app_pages.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final locationController = TextEditingController();
  final apiService = ApiService();

  var isLoading = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var formSubmitted = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  Future<void> register() async {
    formSubmitted.value = true;
    
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    final response = await apiService.register(
      username: usernameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      location: locationController.text.trim(),
    );

    isLoading.value = false;

    if (response.success) {
      Get.snackbar(
        'Success',
        response.message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.HOME, arguments: response.user);
    } else {
      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
