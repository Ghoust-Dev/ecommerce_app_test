
import 'package:ecomerce_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../views/cart_screen.dart';
import '../views/home_screen.dart';

class CustomScaffold extends StatefulWidget {
  const CustomScaffold({
    super.key,

    required this.child,
  });

  final Widget child;

  @override
  State<CustomScaffold> createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {
  final _homeController = Get.put(HomeController());
  final _cartController = Get.put(CartController());

  bool _isKeyboardVisible = false;

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
      body: Container(
        padding: EdgeInsets.only(top: 50, right: 20, left: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: widget.child,
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: (){
                FocusScope.of(context).unfocus();
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: Get.currentRoute == "/HomeScreen" ? primaryColor : Colors.grey, size: 26.sp,),
                    Text("Home", style: TextStyle(color: Get.currentRoute == "/HomeScreen" ? primaryColor : Colors.grey, fontWeight: FontWeight.w500, fontSize: 10.sp),)
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: (){
                if(MediaQuery.of(context).viewInsets.bottom > 0){
                  _homeController.focusNode.unfocus();
                }
                Get.to(() => const CartScreen());
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_basket, color: Get.currentRoute == "/CartScreen" ? primaryColor : Colors.grey, size: 26.sp,),
                        Text("Cart", style: TextStyle(color: Get.currentRoute == "/CartScreen" ? primaryColor : Colors.grey, fontWeight: FontWeight.w500, fontSize: 10.sp),)
                      ],
                    ),
                  ),
                  Visibility(
                    visible:
                    !_cartController.items.length.isEqual(0),
                    child: Positioned(
                      right: 15,
                      top: -6,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius:
                            BorderRadius.circular(50)),
                        child: Text(
                          "${_cartController.items.length}",
                          style: TextStyle(
                              color: Colors.white, fontSize: 9.sp),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
