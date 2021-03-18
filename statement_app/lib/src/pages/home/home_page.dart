import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:statement_app/src/models/statement_model.dart';
import 'package:statement_app/src/pages/form/form_page.dart';
import 'package:statement_app/src/services/network_service.dart';
import 'package:statement_app/src/widgets/statement_card.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Statement"),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(FormPage(
                appbarTitle: "Create Statement",
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: FutureBuilder<List<StatementModel>>(
              future: NetworkService().getStatement(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final RxList<StatementModel> statement = snapshot.data.obs;
                  if (statement == null || statement.isEmpty) {
                    return Container(
                      margin: EdgeInsets.only(top: 22),
                      alignment: Alignment.topCenter,
                      child: Text('No data'),
                    );
                  }
                  return _buildStatementList(statement);
                }
                if (snapshot.hasError) {
                  return Container(
                    margin: EdgeInsets.only(top: 22),
                    alignment: Alignment.topCenter,
                    child: Text((snapshot.error as DioError).message),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Obx _buildStatementList(List<StatementModel> statements) {
    return Obx(
      () => Column(
        children: List.generate(
            statements.length,
            (index) => StatementCard(
                  id: statements[index].id,
                  date: statements[index].date,
                  amount: statements[index].amount,
                  detail: statements[index].detail,
                  onDelete: () {
                    setState(() {});
                  },
                )),
      ),
    );
  }
}
