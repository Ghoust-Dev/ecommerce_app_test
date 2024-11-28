import 'dart:async';
import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ecomerce_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/products_controller.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/network_image_with_loader.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productsController = Get.put(ProductsController());
  final _cartController = Get.put(CartController());

  final PageController _pageController = PageController(initialPage: 0);

  Timer? timer;

  var product = Get.arguments;
  int activeImage = 0;

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 3), (timer){
      if(_pageController.page == product.images.length - 1){
        _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }else{
        _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _showDialogPopup(
      String title, String description, IconData icon, Color color) {
    showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CustomDialog(
            title: title,
            message: description,
            icon: icon,
            iconColor: color,
            titleColor: primaryColor,
            primaryButtonLabel: "Check your Cart",
            primaryButtonCallback: () {
              Navigator.of(context).pop(false);
              Get.to(const CartScreen());
            },
            secondaryButtonLabel: '',
            secondaryButtonCallback: () {},
            secondaryButtonColor: Colors.white,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        height: Get.size.height,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35.sp),
                        bottomRight: Radius.circular(35.sp),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        PageView.builder(
                            itemCount: product.images.length,
                            controller: _pageController,
                            onPageChanged: (value){
                              setState(() {
                                activeImage = value;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              activeImage = index;
                              return CustomNetworkImage(
                                fit: BoxFit.fitHeight,
                                imageUrl: product.images[index],
                              );
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: List<Widget>.generate(product.images.length, (index){
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 3.0),
                                child: InkWell(
                                  onTap: (){
                                    _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                                  },
                                  child: CircleAvatar(
                                    radius: 8.sp,
                                    backgroundColor: activeImage == index ? primaryColor : Colors.white,
                                  ),
                                ),
                              );
                            }),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 35.sp, left: 15.sp),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5.sp),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(50.sp)),
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(math.pi),
                            child: Icon(
                              Icons.arrow_right_alt_rounded,
                              color: Colors.white,
                              size: 30.sp,
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 15.sp),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        _productsController.capitalizeFirst(product.title),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        _productsController.capitalizeFirst(product.brand),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        minFontSize: 8,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/star.png",
                              width: 24.sp,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _productsController
                                  .capitalizeFirst(product.rating.toString()),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black.withOpacity(0.85),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "( ${product.reviews.length.toString()} Reviews )",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black.withOpacity(0.85),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              "\$${product.price}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                            SizedBox(width: 5,),
                            AutoSizeText(
                              "\$${_productsController.priceAfterDiscount(product).toStringAsFixed(2)}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: primaryColor.withOpacity(0.85),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              minFontSize: 8,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${product.availabilityStatus}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Description",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.black.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText(
                      product.description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                      minFontSize: 8,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.sp),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 3,
                      child: InkWell(
                        onTap: () {
                          _cartController.addProduct(product).then((value) {
                            if (value) {
                              _showDialogPopup(
                                  "Awesome!",
                                  "Product Added successfully",
                                  Icons.check,
                                  Colors.green);
                            } else {
                              _showDialogPopup(
                                  "Sorry!",
                                  "This Product Already added",
                                  Icons.warning_amber_rounded,
                                  primaryColor);
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Add To Cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30.sp,
                    ),
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        return InkWell(
                          onTap: () {
                            Get.to(const CartScreen());
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 45,
                            decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.shopping_basket,
                                  color: Colors.grey,
                                  size: 24.sp,
                                ),
                                Visibility(
                                  visible:
                                      !_cartController.items.length.isEqual(0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    margin: EdgeInsets.only(left: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade400,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Text(
                                      "${_cartController.items.length}",
                                      style: TextStyle(
                                          color: whiteColor, fontSize: 11.sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
