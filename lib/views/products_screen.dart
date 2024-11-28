import 'dart:math' as math;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../colors.dart';
import '../controllers/products_controller.dart';
import '../controllers/progressdialog_controller.dart';
import '../widgets/customScaffold.dart';
import '../widgets/customTextField.dart';
import '../widgets/network_image_with_loader.dart';
import 'product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _productsController = Get.put(ProductsController());

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  var category = Get.arguments;
  List<Color> colors = [];

  bool _isKeyboardVisible = false;

  @override
  void initState() {
    _productsController.getProductsByCategory(category);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            height: Get.size.height,
            width: Get.size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 45.sp,
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          _productsController.capitalizeFirst(
                              category),
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          onTap: () {
                            if(_isKeyboardVisible){
                              _focusNode.unfocus();
                            }
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
                SizedBox(
                  height: 10.sp,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration: BoxDecoration(
                      color: whiteColor, borderRadius: BorderRadius.circular(50)),
                  child: CustomTextField(
                    onSubmitted: (String value) {
                      print("Screen two Submitted: $value");
                      _productsController.filterProductsByTitle(value);
                    },
                    onFocusNode: _focusNode,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.black45,
                    ),
                    controller: _searchController,
                    hintText: 'Search product',
                    textInputType: TextInputType.text,
                    isVisible: true,
                    validatorMsg: null,
                  ),
                ),
                Expanded(child: Obx(() {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 25.sp,
                        mainAxisSpacing: 15.sp,
                        childAspectRatio: 0.65,
                      ),
                      padding: EdgeInsets.only(
                          top: 0, bottom: 20, left: 20, right: 20),
                      shrinkWrap: true,
                      itemCount: _productsController.productsByCategoryFiltred.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            if(_isKeyboardVisible){
                              _focusNode.unfocus();
                            }
                            await ProgressDialogController.instance.showDialog(
                              'Loading...',
                              Duration(seconds: 1),
                            );

                            Get.to(ProductScreen(),
                                arguments: _productsController
                                    .productsByCategoryFiltred[index]);

                            _searchController.clear();
                            _productsController.filterProductsByTitle("");
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(15.sp),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(25.sp),
                                          bottomRight: Radius.circular(25.sp),
                                          topLeft: Radius.circular(15.sp),
                                          topRight: Radius.circular(15.sp)),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      children: [
                                        // Visibility(
                                        //   visible: _productsController
                                        //       .isImageLoaded[index],
                                        //   child: Container(
                                        //     width: 100,
                                        //     height: 100,
                                        //     decoration: BoxDecoration(
                                        //       borderRadius:
                                        //           BorderRadius.circular(30),
                                        //       boxShadow: [
                                        //         BoxShadow(
                                        //           color: Colors.black.withOpacity(
                                        //             0.2,
                                        //           ),
                                        //           spreadRadius: 10,
                                        //           blurRadius: 25,
                                        //           offset: const Offset(1, 10),
                                        //         ),
                                        //       ],
                                        //     ),
                                        //   ),
                                        // ),
                                        Image.network(
                                          _productsController
                                              .productsByCategoryFiltred[index]
                                              .images[0],
                                          loadingBuilder:
                                              (context, child, loadingProgress) {

                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.grey,
                                                strokeWidth: 1,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Center(
                                                child: Icon(
                                                  Icons.image_not_supported_outlined,
                                                  size: 50,
                                                  color: Colors.grey[400],
                                                ));
                                          },
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        AutoSizeText(
                                          _productsController.capitalizeFirst(
                                              _productsController
                                                  .productsByCategoryFiltred[index]
                                                  .title),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black.withOpacity(0.85),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          minFontSize: 9,overflow: TextOverflow.clip,
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "\$ ${_productsController.priceAfterDiscount(_productsController.productsByCategoryFiltred[index]).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Text(
                                              "\$ ${_productsController.productsByCategoryFiltred[index].price.toString()}",
                                              style: TextStyle(
                                                fontSize: 9.sp,
                                                color: Colors.black.withOpacity(0.85),
                                                fontWeight: FontWeight.w400,
                                                decoration: TextDecoration.lineThrough
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
