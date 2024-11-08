import 'package:credit_flutter/pages/modules/report/new_report_details_sample_page.dart';
import 'package:credit_flutter/pages/modules/report/personal_report_home_page.dart';
import 'package:credit_flutter/pages/test_page.dart';
import 'package:credit_flutter/tools/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'new_company_report_home_page.dart';

/// @Description: 报告页
class ReportHomePage extends StatefulWidget {
  const ReportHomePage({Key? key}) : super(key: key);

  @override
  State<ReportHomePage> createState() => _ReportHomePageState();
}

class _ReportHomePageState extends State<ReportHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _currentContentView();
  }

  Widget _currentContentView() {
    if (Golbal.token.isEmpty) {
      return NewReportDetailsSamplePage(
        type: 2,
      );
    } else {
      switch (Golbal.loginType) {
        case "1":
          //企业雇主
          return const NewCompanyReportHomePage();
        case "2":
        //个人自查
        case "3":
          //个人雇主
          return const PersonalReportHomePage();
        default:
          return const TestPage();
      }
    }
  }
}
