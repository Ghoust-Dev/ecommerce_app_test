import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/cart_model.dart';
import '../models/products_model.dart';
import '../services/api_service.dart';
import '../views/home_screen.dart';
import 'progressdialog_controller.dart';
// import '../view/widgets/custom_alert_dialog.dart';
// import '../view/widgets/dialog_helper.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();

  final items = <CartItem>[].obs;

  @override
  onInit(){
    super.onInit();
  }

  Future<bool> addProduct(Product product) async {
    final existingItem = items.firstWhere(
          (item){
            return item.product.id == product.id;
          },
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (existingItem.quantity > 0) {
      return false;
    } else {
      items.add(CartItem(product: product));
      return true;
    }
  }

  void updateProductQuantity(Product product, bool increase) {
    final cartItem = items.firstWhere(
          (item) => item.product.id == product.id,
      orElse: () => CartItem(product: product, quantity: 0),
    );

    if (increase) {
      if (!cartItem.increaseQuantity()) {
        alert("Cannot increase quantity as it exceeds stock.");
        print("Cannot increase quantity for '${product.title}' as it exceeds stock.");
      }
    } else {
      if (!cartItem.decreaseQuantity() && cartItem.quantity == 0) {
        print("Quantity of '${product.title}' is already 0.");
        alert("Quantity is already 0.");
      }
    }

    items.refresh();
  }

  void removeProduct(Product product) {
    items.removeWhere((item) => item.product.id == product.id);
    items.refresh();
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + (item.priceAfterDiscount * item.quantity));
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  List<Color> generateColors(int length) {
    Random random = Random();
    return List<Color>.generate(length, (index) {
      // Generate a random color for each index
      return Color.fromARGB(
        255, // Fully opaque
        random.nextInt(256), // Random Red
        random.nextInt(256), // Random Green
        random.nextInt(256), // Random Blue
      );
    });
  }

  Future<void> submitCart(List<CartItem> cartItems) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts'); // Mock API endpoint

    final cartData = {
      'userId': 145,
      'items': cartItems.map((item) => item.toJson()).toList(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cartData),
      );
      print('Response: ${response.body}');
      if (response.statusCode == 201) {
        print('Cart submitted successfully!');
      } else {
        print('Failed to submit cart');
      }
    } catch (e) {
      print('Error submitting the cart: $e');
    }
  }

  alert(error) {
    return Get.snackbar(
      'Sorry!!',
      error,
      colorText: Colors.white,
      backgroundColor: Colors.black54,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
    );
  }

  successAlert(msg) {
    return Get.snackbar(
      'Great!!',
      msg,
      colorText: Colors.white,
      backgroundColor: Colors.black54,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
    );
  }
}
