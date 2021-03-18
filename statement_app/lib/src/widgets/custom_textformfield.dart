import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:statement_app/src/config/screen_size.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextInputType textInputType;
  final TextEditingController controller;
  final List<TextInputFormatter> inputformatter;
  final Function validator;
  final Function onSubmit;
  final RxBool _isCancel = false.obs;
  final Function onChange;
  final int maxLine;

  final int maxlength;

  final outlineInputBorderEnable = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: Color(0xFFDDDDDD),
    ),
  );
  final outlineInputBorderFocus = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.black),
  );
  final outlineInputBorderError = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: Colors.red),
  );
  CustomTextFormField({
    Key key,
    @required this.hintText,
    @required this.textInputType,
    this.controller,
    this.validator,
    this.inputformatter,
    this.onSubmit,
    this.onChange,
    this.maxlength,
    this.maxLine = 1,
  }) : super(key: key);

  get pi => null;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      inputFormatters: inputformatter,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxLine,
      validator: validator,
      controller: controller,
      maxLength: maxlength,
      style: TextStyle(
        fontSize: getScreenWidth(30),
        fontWeight: FontWeight.bold,
      ),
      keyboardType: textInputType,
      decoration: InputDecoration(
        counterText: '',
        contentPadding: EdgeInsets.symmetric(
          vertical: getScreenHeight(23),
          horizontal: getScreenWidth(30),
        ),
        suffixIcon: Container(
          height: getScreenHeight(5),
          width: getScreenHeight(5),
          padding: EdgeInsets.all(
            getScreenWidth(5),
          ),
          child: Obx(
            () {
              if (_isCancel.value) {
                return GestureDetector(
                  onTap: () {
                    _isCancel.value = false;
                    controller.clear();
                  },
                  child: Transform.rotate(
                    angle: pi / 4,
                    child: Icon(
                      Icons.add_circle,
                      color: Color(0xFFDDDDDD),
                    ),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          ),
        ),
        enabledBorder: outlineInputBorderEnable,
        focusedBorder: outlineInputBorderFocus,
        errorBorder: outlineInputBorderError,
        border: outlineInputBorderFocus,
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: getScreenWidth(25),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Color(0xFFBBBBBB),
          fontSize: getScreenWidth(30),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
