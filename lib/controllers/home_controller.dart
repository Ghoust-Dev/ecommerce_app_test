import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController instance = Get.find();

  final TextEditingController searchController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  var filteredCategories = <String>[].obs;

  void filterCategories(String keyword, List<String> categories) {
    if (keyword.isEmpty) {
      filteredCategories.assignAll(categories);
    } else {
      filteredCategories.assignAll(
        categories.where((category) =>
            category.toLowerCase().contains(keyword.toLowerCase())
        ).toList(),
      );
    }
    filteredCategories.refresh();
  }

  int getCategoryIndexByName(String name, List<String> categories) {
    return categories.indexWhere((category) => category.toLowerCase() == name.toLowerCase());
  }

}