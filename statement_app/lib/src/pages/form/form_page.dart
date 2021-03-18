import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:statement_app/src/config/screen_size.dart';
import 'package:statement_app/src/controller/focus_form_controller.dart';
import 'package:statement_app/src/models/statement_model.dart';
import 'package:statement_app/src/pages/home/home_page.dart';
import 'package:statement_app/src/services/network_service.dart';
import 'package:statement_app/src/widgets/custom_datefield.dart';
import 'package:statement_app/src/widgets/custom_textformfield.dart';

class FormPage extends StatelessWidget {
  //final focusFormController = Get.put(FocusFormController);
  final RxString date = ''.obs;
  final amountController = TextEditingController();
  final detailController = TextEditingController();
  final String appbarTitle;
  final String id;

  FormPage({Key key, this.id, @required this.appbarTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: getScreenHeight(50),
          horizontal: getScreenWidth(40),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomDateField(
              date: date,
              onTap: () {},
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              hintText: 'กรอกจำนวนเงิน',
              textInputType: TextInputType.number,
              maxlength: 10,
              controller: amountController,
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              hintText: 'กรอกรายละเอียด',
              textInputType: TextInputType.text,
              maxlength: 50,
              maxLine: 3,
              controller: detailController,
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                if (date.value.isNotEmpty &&
                    amountController.text.isNotEmpty &&
                    detailController.text.isNotEmpty) {
                  if (id != null) {
                    Get.dialog(Center(child: CircularProgressIndicator()));
                    await NetworkService()
                        .updateStatement(StatementModel(
                      id: id,
                      date: date.value,
                      amount: int.parse(amountController.text),
                      detail: detailController.text,
                    ))
                        .then((_) async {
                      await NetworkService()
                          .getStatement()
                          .then((_) => Get.offAll(HomePage()));
                    });
                  } else {
                    Get.dialog(Center(child: CircularProgressIndicator()));
                    await NetworkService()
                        .createStatement(StatementModel(
                      date: date.value,
                      amount: int.parse(amountController.text),
                      detail: detailController.text,
                    ))
                        .then((_) async {
                      await NetworkService()
                          .getStatement()
                          .then((_) => Get.offAll(HomePage()));
                    });
                  }
                } else {
                  Get.snackbar("แจ้งเตือน", "กรุณากรอกข้อมูลให้ครบ");
                }
              },
              child: Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightGreen,
                ),
                child: Center(
                    child: Text(
                  "Submit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
