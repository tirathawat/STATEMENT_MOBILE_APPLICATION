import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FocusFormController extends GetxController {
  FocusNode dateFocusNode;
  FocusNode amountFocusNode;
  FocusNode detailFocusNode;

  @override
  void onInit() {
    super.onInit();
    dateFocusNode = FocusNode();
    amountFocusNode = FocusNode();
    detailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    dateFocusNode.dispose();
    amountFocusNode.dispose();
    detailFocusNode.dispose();
  }
}
