import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ProgressDialogController extends GetxController {

  static ProgressDialogController instance = Get.find();

  Timer? _timer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    EasyLoading.init();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(seconds: 2)
      ..maskType = EasyLoadingMaskType.black
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.light
      ..indicatorSize = 45.0
      ..radius = 20.0
      ..userInteractions = false
      ..dismissOnTap = false;


    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  showDialog(message, duration) async{
    configLoading();
    _timer?.cancel();
    await EasyLoading.show(
      status: message,
    );

    await Future.delayed(duration);
    EasyLoading.dismiss();
  }

  closeDialog(){
    EasyLoading.dismiss();
  }

}