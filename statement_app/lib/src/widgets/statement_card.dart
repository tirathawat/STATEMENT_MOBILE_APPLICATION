import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:statement_app/src/config/screen_size.dart';
import 'package:statement_app/src/constants/asset_constant.dart';
import 'package:statement_app/src/pages/form/form_page.dart';
import 'package:statement_app/src/services/network_service.dart';

class StatementCard extends StatelessWidget {
  final String date, detail, id;
  final int amount;
  final Function onDelete;

  const StatementCard({
    Key key,
    @required this.date,
    @required this.detail,
    @required this.amount,
    @required this.id,
    this.onDelete,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.black,
      child: Padding(
          padding: EdgeInsets.all(getScreenWidth(40)),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    Asset.SCHEDULE_ICON,
                    width: 30,
                  ),
                  SizedBox(width: 20),
                  Text(date),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        FormPage(
                          id: id,
                          appbarTitle: "Update Statement",
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () async {
                      Get.dialog(Center(child: CircularProgressIndicator()));
                      await NetworkService().deleteStatement(id);
                      Get.back();
                      onDelete();
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Image.asset(
                    Asset.MONEY_ICON,
                    width: 30,
                  ),
                  SizedBox(width: 20),
                  Text("$amount Bath"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text("Detail: "),
                  SizedBox(width: 5),
                  Text(detail),
                ],
              ),
            ],
          )),
    );
  }
}
