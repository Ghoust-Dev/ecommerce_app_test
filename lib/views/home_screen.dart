import 'package:ecomerce_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/progressdialog_controller.dart';
import '../widgets/customScaffold.dart';
import '../widgets/customTextField.dart';
import '../widgets/network_image_with_loader.dart';
import 'product_screen.dart';
import 'products_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeController = Get.put(HomeController());
  final _productsController = Get.put(ProductsController());
  final _cartController = Get.put(CartController());

  bool _isKeyboardVisible = false;

  List<String> backgroundCategories = [
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKB7iQfgorjMnRmlR7To0XCcCCFFjw15rRyQ&s",
    "https://img.freepik.com/premium-photo/front-view-expensive-perfume-with-flowers-light-background-fragnance-valentines-day-love-gift-flask-feeling-present-scent_461922-18933.jpg",
    "https://img.freepik.com/premium-photo/banner-with-modern-furniture-copy-space-text-advertisement-furniture-store-interior-details-furnishings-sale-interior-project-template-with-empty-space-minimalist-design-3d-render_429124-3838.jpg",
    "https://img.freepik.com/free-photo/supermarket-banner-concept-with-ingredients_23-2149421148.jpg"
  ];

  @override
  Widget build(BuildContext context) {

    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;

    if (isKeyboardVisible != _isKeyboardVisible) {
      setState(() {
        _isKeyboardVisible = isKeyboardVisible;
      });
    }

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: CustomScaffold(
          child: Container(
            child: Obx((){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hello!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17.sp),
                              ),
                              Text(
                                "Daniel William",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22.sp),
                              ),
                            ],
                          ),
                          Spacer(),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "assets/images/profile.png",
                                height: 50,
                              )),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      decoration: BoxDecoration(
                          color: whiteColor, borderRadius: BorderRadius.circular(50)),
                      child: CustomTextField(
                        onSubmitted: (String value) {
                          _homeController.filterCategories(value, _productsController.categories);
                        },
                        onFocusNode: _homeController.focusNode,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black45,
                        ),
                        controller: _homeController.searchController,
                        hintText: 'Search category',
                        textInputType: TextInputType.text,
                        isVisible: true,
                        validatorMsg: null,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _homeController.filteredCategories.length,
                          padding: EdgeInsets.only(top: 10),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () async {

                                if(_isKeyboardVisible){
                                  _homeController.focusNode.unfocus();
                                }

                                await ProgressDialogController.instance.showDialog(
                                  'Loading...',
                                  Duration(seconds: 1),
                                );
                                Get.to(
                                  ProductsScreen(),
                                  arguments: _homeController.filteredCategories[index],
                                );
                                _homeController.searchController.clear();
                                _homeController.filterCategories("", _productsController.categories);
                              },
                              child: Container(
                                height: 145,
                                width: Get.size.width,
                                margin: const EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.30),
                                      spreadRadius: 1,
                                      blurRadius: 7,
                                      offset: const Offset(1, 5),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Stack(
                                    clipBehavior: Clip.antiAlias,
                                    alignment: Alignment.bottomLeft,
                                    children: [
                                      CustomNetworkImage(
                                        imageUrl: backgroundCategories[_homeController.getCategoryIndexByName(
                                            _homeController.filteredCategories[index],
                                            _productsController.categories
                                        )],
                                        width: double.infinity,
                                        height: 150,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        alignment: _homeController.getCategoryIndexByName(_homeController.filteredCategories[index], _productsController.categories).isOdd
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        padding: const EdgeInsets.only(
                                            bottom: 15.0,
                                            left: 30.0,
                                            top: 5,
                                            right: 35.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _productsController.capitalizeFirst(
                                                  _homeController.filteredCategories[index]),
                                              style: TextStyle(
                                                fontSize: 28.sp,
                                                color: Colors.black.withOpacity(0.85),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "${_productsController.getTotalProductsForCategory(_homeController.filteredCategories[index])} Products",
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black.withOpacity(0.85),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
