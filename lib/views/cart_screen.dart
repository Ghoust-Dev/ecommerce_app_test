import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/products_controller.dart';
import '../widgets/customScaffold.dart';
import '../widgets/custom_dialog.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _productsController = Get.put(ProductsController());
  final _cartController = Get.put(CartController());

  void _showDialogPopup(product) {
    showDialog(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Are you sure!",
            message: "You will lose your product",
            icon: Icons.warning_amber_rounded,
            iconColor: primaryColor,
            titleColor: primaryColor,
            primaryButtonLabel: "Confirm",
            primaryButtonCallback: () {
              Navigator.of(context).pop();
              _cartController.removeProduct(product);
            },
            secondaryButtonLabel: 'Cancel',
            secondaryButtonCallback: () {
              Navigator.of(context).pop();
            },
            secondaryButtonColor: Colors.grey,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50, right: 20, left: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Obx(() {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 45.sp,
                    alignment: Alignment.center,
                    child: Container(
                      child: Text(
                        "My Cart",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.all(7.sp),
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
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 3,
                child:
                _cartController.items.isEmpty ? Container(
                  alignment: Alignment.center,
                  child: Text("Your Cart is Empty", style: TextStyle(color: Colors.black45),),
                ) :
                ListView.builder(
                    itemCount: _cartController.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: Get.size.height * 0.15,
                        width: double.infinity,
                        margin: EdgeInsets.only(bottom: 15.sp),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(15.sp)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.network(
                                  "${_cartController.items[index].product.images[0]}",
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.grey,
                                        strokeWidth: 1,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                        child: Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 50,
                                      color: Colors.grey[400],
                                    ));
                                  },
                                  height: 100,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${_cartController.items[index].product.title}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    _productsController.capitalizeFirst(
                                        "${_cartController.items[index].product.brand}"),
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${_cartController.items[index].priceAfterDiscount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        "\$${_cartController.items[index].product.price}",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.bold, decoration: TextDecoration.lineThrough),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        _showDialogPopup(_cartController.items[index].product);
                                      },
                                      child: Image.asset(
                                        "assets/icons/trash.png",
                                        height: 25.sp,
                                        color: primaryColor.withOpacity(0.75),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 28.sp,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            _cartController
                                                .updateProductQuantity(
                                                    _cartController
                                                        .items[index].product,
                                                    false);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: primaryColor,
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                            radius: 12.sp,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 12.sp,
                                        ),
                                        Text(
                                          "${_cartController.items[index].quantity}",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 12.sp,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _cartController
                                                .updateProductQuantity(
                                                    _cartController
                                                        .items[index].product,
                                                    true);
                                          },
                                          child: CircleAvatar(
                                            backgroundColor: primaryColor,
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 20.sp,
                                            ),
                                            radius: 12.sp,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Container(
                      height: Get.size.height * 0.20,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 15.sp),
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10.sp)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order Summary",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.sp,
                          ),
                          orderDetail("Items", "${_cartController.items.length}"),
                          orderDetail("Subtotal", "\$${_cartController.totalPrice.toStringAsFixed(2)}"),
                          orderDetail("Shipping", "\$0.0"),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Divider(
                              height: 1,
                              color: Colors.black12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Total",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.75),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                "\$${_cartController.totalPrice.toStringAsFixed(2)}",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if(_cartController.items.isEmpty)
                          return null;
                        Get.to(CheckoutScreen());
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 45,
                        decoration: BoxDecoration(
                            color: _cartController.items.isEmpty ? Colors.grey : primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Proceed to Checkout",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget orderDetail(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            description,
            style: TextStyle(
                color: Colors.black.withOpacity(0.7),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
