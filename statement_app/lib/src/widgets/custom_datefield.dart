import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:statement_app/src/config/screen_size.dart';
import 'package:intl/intl.dart';
import 'package:statement_app/src/constants/asset_constant.dart';

class CustomDateField extends StatefulWidget {
  final bool showError;
  final Function onTap;
  final RxString date;
  const CustomDateField({
    Key key,
    this.showError = false,
    @required this.onTap,
    this.date,
  }) : super(key: key);
  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    final outlineInputBorderEnable = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: widget.showError ? Colors.red : Color(0xFFDDDDDD),
      ),
    );

    final outlineInputBorderFocus = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.black),
    );
    return Container(
      height: getScreenWidth(90),
      width: getScreenWidth(670),
      child: TextFormField(
        style: TextStyle(
          fontSize: getScreenWidth(30),
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: getScreenHeight(23),
              horizontal: getScreenWidth(30),
            ),
            enabledBorder: outlineInputBorderEnable,
            focusedBorder: outlineInputBorderFocus,
            hintText: _dateTime != null
                ? DateFormat("yMd").format(_dateTime)
                : "วันที่ใช้จ่าย (ว/ด/ป)",
            hintStyle: TextStyle(
              color: _dateTime == null ? Color(0xFFBBBBBB) : Colors.black,
              fontSize: getScreenWidth(30),
              fontWeight: _dateTime == null ? FontWeight.w500 : FontWeight.bold,
            ),
            suffixIcon: Container(
              padding: EdgeInsets.symmetric(
                vertical: getScreenHeight(20),
              ),
              child: Image.asset(
                Asset.SCHEDULE_ICON,
                height: getScreenHeight(42),
              ),
            )),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          ).then((value) {
            setState(() {
              _dateTime = value;
              widget.date.value = '${DateFormat("yMd").format(_dateTime)}';
            });
            widget.onTap();
          });
        },
      ),
    );
  }
}
