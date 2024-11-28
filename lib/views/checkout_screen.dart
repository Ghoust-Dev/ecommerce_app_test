import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../controllers/cart_controller.dart';
import '../controllers/products_controller.dart';
import '../widgets/customScaffold.dart';
import '../widgets/custom_dialog.dart';
import 'home_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _productsController = Get.put(ProductsController());
  final _cartController = Get.put(CartController());

  String selectedPaymentMethod = "Credit Card"; // Default selection

  void _showDialogPopup() {
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return CustomDialog(
            title: "Successful!",
            message: "You have successfully your confirm Payment send!",
            icon: Icons.check_rounded,
            iconColor: Colors.black,
            titleColor: Colors.black,
            primaryButtonLabel: "Continue Shopping",
            primaryButtonCallback: () {
              _cartController.submitCart(_cartController.items);
              _cartController.items.clear();
              _cartController.items.refresh();
              Navigator.of(context).pop();
              Get.offAll(HomeScreen());
            },
            secondaryButtonLabel: '',
            secondaryButtonCallback: () {
              Navigator.of(context).pop();
            },
            secondaryButtonColor: Colors.grey,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
                          "Check Out",
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
                  height: 25,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.location_on_outlined, color: primaryColor,),
                            ),
                            SizedBox(width: 15.sp,),
                            Text(
                              "325 15th Eighth Avenue, New York",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.75),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        SizedBox(height: 10.sp,),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Icon(Icons.access_time_filled, color: primaryColor,),
                            ),
                            SizedBox(width: 15.sp,),
                            Text(
                              "3:00 pm, Friday 22",
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.75),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
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
                    ],
                  ),
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
                            borderRadius: BorderRadius.circular(10.sp)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Choose payment method",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15.sp,
                            ),
                            paymentDetail("assets/icons/paypal.png", "Paypal",),
                            SizedBox(
                              height: 10.sp,
                            ),
                            paymentDetail("assets/icons/card.png", "Credit Card",),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _showDialogPopup();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45,
                          decoration: BoxDecoration(
                              color: _cartController.items.isEmpty ? Colors.grey : primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Place Order",
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

  Widget paymentDetail(String icon, String description) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = description; // Update the selected payment method
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(icon, height: 18.sp,),
                SizedBox(width: 10.sp,),
                Text(
                  description,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            CircleAvatar(
              radius: 13.sp,
              backgroundColor: selectedPaymentMethod != description ? Colors.grey.shade300 : Colors.deepPurple.shade100,
              child: selectedPaymentMethod == description ? Icon(Icons.check, size: 18.sp,) : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
