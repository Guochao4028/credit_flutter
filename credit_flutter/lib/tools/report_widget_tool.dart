import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/models/professional_certificate_bean.dart';
import 'package:credit_flutter/models/report_data_bean.dart';
import 'package:flutter/material.dart';

/// *
/// @Date: 2022-05-27 09:57
/// @LastEditTime: 2022-06-09 15:39
/// @Description: 所有自定义组件

class ReportWidgetTools {
  /// 报告通用Item
  Widget showReportGeneralPurposeItem(
    BuildContext context,
    int index,
    ProfessionalCertificateBean data,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 10),
              decoration: const BoxDecoration(
                color: CustomColors.color3B8FF9,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: CustomColors.connectColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.content.length,
          itemBuilder: (context, index) {
            var content = data.content[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    "${content.title}：",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content.content,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 5, top: 6, right: 5, bottom: 6),
          margin: const EdgeInsets.only(top: 5, bottom: 15),
          decoration: const BoxDecoration(
            color: CustomColors.colorFAF8F8,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: Text(
            data.explain,
            style: const TextStyle(
              color: CustomColors.darkGrey,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }

  ///工商信息
  Widget showBusinessInfoItem(
    BuildContext context,
    int index,
    ItemData136 data,
  ) {
    List<ProfessionalCertificateBean> businessInfoList =
        <ProfessionalCertificateBean>[];
    for (var item in data.itemPropValue) {
      List<ProfessionalCertificateContent> content =
          <ProfessionalCertificateContent>[];
      var name = "";
      for (var item1 in item) {
        if (item1.itemPropLabel.contains("企业（机构）名称") ||
            item1.itemPropLabel.contains("企业名称")) {
          name = item1.itemPropValue;
        } else {
          content.add(ProfessionalCertificateContent(
              item1.itemPropLabel, item1.itemPropValue));
        }
      }
      businessInfoList.add(ProfessionalCertificateBean(name, content, ""));
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                businessInfoList.isNotEmpty
                    ? data.itemPropLabel
                    : "${data.itemPropLabel}（无）",
                style: const TextStyle(
                  fontSize: 15,
                  color: CustomColors.connectColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: businessInfoList.length,
          itemBuilder: (context, index) {
            var contentData = businessInfoList[index];
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: const BoxDecoration(
                        color: CustomColors.color3B8FF9,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                      ),
                      child: Center(
                        child: Text(
                          "${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        contentData.name,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CustomColors.connectColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: contentData.content.length,
                  itemBuilder: (context, index) {
                    var content = contentData.content[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            "${content.title}：",
                            style: const TextStyle(
                              fontSize: 12,
                              color: CustomColors.darkGrey,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              content.content,
                              style: const TextStyle(
                                fontSize: 12,
                                color: CustomColors.greyBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: double.infinity,
                  height: 10,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  ///开庭公告
  Widget showHearingAnnouncementItem(
    BuildContext context,
    int index,
    ItemData755 data,
  ) {
    List<ProfessionalCertificateContent> contentList =
        <ProfessionalCertificateContent>[];
    for (var item in data.itemPropValue) {
      for (var item1 in item) {
        contentList.add(ProfessionalCertificateContent(
            item1.itemPropLabel, item1.itemPropValue));
      }
    }

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                data.itemPropLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: contentList.length,
          itemBuilder: (context, index) {
            var content = contentList[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    "${content.title}：",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content.content,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  ///刑事案件记录 / 法院失信被执行人
  Widget showCriminalAdjudicationItem(
    BuildContext context,
    int index,
    ProfessionalCertificateBean data,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.content.length,
          itemBuilder: (context, index) {
            var content = data.content[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    "${content.title}：",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content.content,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  ///工商信息
  Widget showLimitedLitigationRecordItem(
    BuildContext context,
    int index,
    ProfessionalCertificateBean data,
  ) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                data.name,
                style: const TextStyle(
                  fontSize: 12,
                  color: CustomColors.greyBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.content.length,
          itemBuilder: (context, index) {
            var content = data.content[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    "${content.title}：",
                    style: const TextStyle(
                      fontSize: 12,
                      color: CustomColors.darkGrey,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      content.content,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CustomColors.greyBlack,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
