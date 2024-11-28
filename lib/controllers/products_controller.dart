import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/products_model.dart';
import '../services/api_service.dart';
import '../views/home_screen.dart';
import 'home_controller.dart';
import 'progressdialog_controller.dart';
// import '../view/widgets/custom_alert_dialog.dart';
// import '../view/widgets/dialog_helper.dart';

class ProductsController extends GetxController {
  static ProductsController instance = Get.find();
  final ApiService _apiService = Get.find<ApiService>();

  final _homeController = Get.put(HomeController());

  final products = <ProductList>[].obs;
  var product = <Product>[].obs;
  var cart = <Product>[].obs;
  var productsByCategory = <Product>[].obs;
  var productsByCategoryFiltred = <Product>[].obs;
  late final List<String> categories;
  RxList<bool> isImageLoaded = RxList<bool>();

  @override
  onInit(){
    fetchProducts().then((onValue){
      if (onValue) {
        Future.delayed(Duration(seconds: 2), () {
          Get.offAll(HomeScreen());
        });
      }
    });

    super.onInit();
  }

  Future<bool> fetchProducts() async {

    try {
      final response = await _apiService.getOutJsonData(
          '',
          {
            "Accept": "application/json",
          },
          );

      Map<String, dynamic> jsonMap = json.decode(response.body);

      if (response.statusCode == 200) {
        products.clear();
        products.add(ProductList.fromJson(jsonMap));
        products.refresh();

        categories = getAllUniqueCategories(products.first.products);
        _homeController.filteredCategories.assignAll(categories);
        return true;
      } else {
        Timer(new Duration(seconds: 1), () {
          alert('Error Connection');
        });
        update();
        return false;
      }
    } finally {}
  }

  double priceAfterDiscount(product) {
    return product.price - (product.price * (product.discountPercentage / 100));
  }

  void addProductToCart(Product product){
    int productCount = cart.where((item) => item.id == product.id).length;

    if (productCount < product.stock) {
      cart.add(product);
    } else {
      alert("Stock limit reached for ${product.title}");
    }
  }

  List<String> getAllUniqueCategories(List<Product> products) {
    return products.map((product) => product.category).toSet().toList();
  }

  String capitalizeFirst(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  int getTotalProductsForCategory(String category) {
    List<Product> listproducts = products.first.products;
    listproducts.where((product){
      return product.category == category;
    });
    return listproducts.where((product) => product.category == category).length;
  }

  Product? getFirstProductOfCategory(String category) {
    List<Product> listproducts = products.first.products;
    return listproducts.firstWhere(
          (product) => product.category == category,
    );
  }

  void getProductsByCategory(String category) {
    List<Product> listproducts = products.first.products;
    productsByCategory.value = listproducts.where((product) => product.category == category).toList();
    productsByCategoryFiltred.assignAll(productsByCategory);
  }

  void filterProductsByTitle(String keyword) {
    if (keyword.isEmpty) {
      productsByCategoryFiltred.assignAll(productsByCategory);
    } else {
      productsByCategoryFiltred.assignAll(
        productsByCategory.where((product) =>
            product.title.toLowerCase().contains(keyword.toLowerCase())).toList(),
      );
    }
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
  void imageLoaded(){
    isImageLoaded.assignAll(List<bool>.filled(productsByCategory.length, false));
  }

  void imageLoadedYes(int index){
    isImageLoaded[index] = true;
    isImageLoaded.refresh();
    update();
  }

  String getImageUrl(String imageName) {
    return imageName.replaceAll(
        'http://localhost/public/', _apiService.baseUrl);
  }

  String cleanImageUrl(String imageName) {
    imageName = imageName.replaceAll('{url: ', '');
    imageName = imageName.replaceAll('}', '');
    return imageName;
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
