/*** 
 * @Date: 2022-05-30 17:12
 * @LastEditTime: 2022-05-31 00:07
 * @Description: 公司详情
 */
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_info_model.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:flutter/material.dart';

class CompanyDerailsPage extends StatefulWidget {
  final int companyId;
  const CompanyDerailsPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  State<CompanyDerailsPage> createState() => _CompanyDerailsPageState();
}

class _CompanyDerailsPageState extends State<CompanyDerailsPage> {
  BackCheckCompanyInfoModel? companyInfoModel;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String picture = "";
    if (companyInfoModel != null) {
      name = companyInfoModel!.name;
      picture = companyInfoModel!.logo;
    }
    ImageProvider image;
    if (picture.length == 0) {
      image = const AssetImage("assets/images/logo.png");
    } else {
      image = NetworkImage(picture);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "公司详情",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.pop(context, true),
        ),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          new SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 0),
                              spreadRadius: 1,
                              blurRadius:
                                  1), //阴影   spreadRadius 延展   blurRadius 模糊
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(0, 0),
                              spreadRadius: 1,
                              blurRadius: 1),
                        ],
                      ),
                      child: Image(
                        image: image,
                        width: 55,
                        height: 55,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text(
                      name,
                      style: TextStyle(
                          color: CustomColors.greyBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  Text(
                    _getString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: CustomColors.greyBlack,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initData() {
    BackCheckCompanyManager.info({"id": widget.companyId}, (object) {
      setState(() {
        companyInfoModel = object as BackCheckCompanyInfoModel;
      });
    });
  }

  String _getString() {
    String? introduction = companyInfoModel?.introduction;
    String? name = companyInfoModel?.name;
    String? website = companyInfoModel?.website;
    String? address = companyInfoModel?.address;
    String? phone = companyInfoModel?.phone;
    String? mail = companyInfoModel?.mail;

    List<String> strList = [
      "简介：$introduction",
      "公司名称:$name",
      "公司简介：$introduction",
      "公司官网：$website",
      "公司地址：$address",
      "联系电话：$phone",
      "联系邮箱：$mail",
    ];
    return StringTools().concatenatedString(strList, "\n");
  }
}
