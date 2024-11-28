import 'package:ecomerce_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../controllers/products_controller.dart';
import '../controllers/progressdialog_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _productsController = Get.put(ProductsController());
  final _progressDialogController = Get.put(ProgressDialogController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: Get.size.height,
        width: Get.size.width,
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(15.sp),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(40.sp),
                  border: Border.all(color: whiteColor, width: 2.sp)
                ),
                child: Image.asset(
                  "assets/icons/panier.png",
                  height: 100.sp,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              "Ecommerce App",
              style: TextStyle(color: whiteColor.withOpacity(0.75)),
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 100,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [whiteColor],
                  strokeWidth: 3,
                  backgroundColor: Colors.transparent ,
              ),
            )
          ],
        ),
      ),
    );
  }
}
