/***
 * @Date: 2022-05-30 17:12
 * @LastEditTime: 2022-05-31 00:07
 * @Description: 公司详情
 */
import 'dart:async';

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/manager/back_check_company_manager.dart';
import 'package:credit_flutter/models/back_check_company_info_model.dart';
import 'package:credit_flutter/models/comment_bean.dart';
import 'package:credit_flutter/pages/modules/company/report_page.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class NewCompanyDerailsPage extends StatefulWidget {
  final int companyId;

  const NewCompanyDerailsPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  State<NewCompanyDerailsPage> createState() => _NewCompanyDerailsPageState();
}

class _NewCompanyDerailsPageState extends State<NewCompanyDerailsPage> {
  BackCheckCompanyInfoModel? companyInfoModel;

  //是否收藏
  var isCollection = false;

  var textStyle = const TextStyle(
    color: CustomColors.darkGrey,
    fontSize: 16,
  );

  //总条数
  int total = 0;

  //当前页
  int currentPage = 1;

  //每页多少条
  int pageSize = 10;

  //公司列表
  List<CommentDataBean> commentList = [];

  ///滚动监听设置
  final ScrollController _scrollController = ScrollController();

  String loadingText = "加载中.....";
  bool _isLoadMore = true;

  @override
  void initState() {
    super.initState();
    _initUI();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    String picture = "";
    String name = "";
    String introduction = "";
    String website = "";
    String mail = "";
    String address = "";
    String phone = "";
    double score = 0;
    if (companyInfoModel != null) {
      name = companyInfoModel!.name;
      picture = companyInfoModel!.logo;
      introduction = companyInfoModel!.introduction;
      website = companyInfoModel!.website;
      mail = companyInfoModel!.mail;
      address = companyInfoModel!.address;
      phone = companyInfoModel!.phone;
      score = companyInfoModel!.score;
    }
    ImageProvider logo;
    if (picture.isEmpty) {
      logo = const AssetImage("assets/images/logo.png");
    } else {
      logo = NetworkImage(picture);
    }

    var statusHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.colorF8F8FA,
      body: Stack(
        children: [
          const Image(
            image: AssetImage("assets/images/icon_company_derails_bg.png"),
            width: double.infinity,
            fit: BoxFit.fill,
            height: 260,
          ),
          Column(
            children: [
              _titleBlock(statusHeight),
              Expanded(
                child: CustomScrollView(
                  // physics: ScrollPhysics(),
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverList(
                        delegate: SliverChildListDelegate(<Widget>[
                      _information(logo, name, score, phone),
                      _introduction(introduction),
                      Container(
                        color: CustomColors.colorF8F8FA,
                        height: 10,
                      ),
                      _info(website, mail, address),
                      Container(
                        color: CustomColors.colorF8F8FA,
                        height: 10,
                      ),
                      _commentList(total.toString()),
                    ])),
                    SliverToBoxAdapter(
                      child: Visibility(
                        visible: _isLoadMore,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Center(
                            child: Text(loadingText),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _comment(),
            ],
          )
        ],
      ),
    );
  }

  //标题栏
  Container _titleBlock(double statusHeight) {
    return Container(
      width: double.infinity,
      height: 45,
      margin: EdgeInsets.only(top: statusHeight),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () => Navigator.pop(context, true),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "公司详情",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 92,
          ),
        ],
      ),
    );
  }

  //公司基本信息
  Container _information(
      ImageProvider logo, String name, double score, String phone) {
    return Container(
      width: double.infinity,
      height: 135,
      padding:
          const EdgeInsets.only(left: 16, right: 16, top: 22.5, bottom: 22.5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image(
              image: logo,
              width: 90,
              height: 90,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 2,
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) {
                        return _bottomSheet(name, score);
                      },
                    );
                  },
                  child: _commentOnStars(score),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          SizedBox(
            width: 92,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                launch("tel:$phone");
              },
              child: const Image(
                image: AssetImage("assets/images/icon_telephone.png"),
                width: 28,
                height: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _commentOnStars(double score) {
    return Row(
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingBar(
          itemSize: 15,
          initialRating: score,
          ignoreGestures: true,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          ratingWidget: RatingWidget(
            full: _image('assets/images/icon_collected.png'),
            half: _image('assets/images/icon_collected.png'),
            empty: _image('assets/images/icon_solid_not_collected.png'),
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          "$score分",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  //公司简介

  ClipRRect _introduction(String introduction) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        child: Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      color: CustomColors.lightBlue,
                      width: 3,
                      height: 18,
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "公司简介",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  introduction,
                  style: const TextStyle(
                    color: CustomColors.darkGrey,
                    fontSize: 16,
                  ),
                ),
              ],
            )));
  }

  //公司简介
  Container _info(String website, String mail, String address) {
    return Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  color: CustomColors.lightBlue,
                  width: 3,
                  height: 18,
                ),
                const SizedBox(width: 5),
                const Text(
                  "公司信息",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            _infoDetails(
                "公司官网：",
                website,
                const TextStyle(
                  color: CustomColors.connectColor,
                  fontSize: 16,
                ), () {
              Clipboard.setData(ClipboardData(text: website));
              ToastUtils.showMessage("复制到剪切板");
            }),
            const SizedBox(
              height: 8,
            ),
            _infoDetails("联系邮箱：", mail, textStyle, () {}),
            const SizedBox(
              height: 8,
            ),
            _infoDetails("公司地址：", address, textStyle, () {}),
          ],
        ));
  }

  //公司简介
  Row _infoDetails(
      String title, String content, TextStyle style, GestureTapCallback back) {
    return Row(
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyle,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: back,
            child: Text(
              content,
              style: style,
            ),
          ),
        ),
      ],
    );
  }

  //公司简介
  Container _commentList(String number) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                color: CustomColors.lightBlue,
                width: 3,
                height: 18,
              ),
              const SizedBox(width: 5),
              Text(
                "全部点评（$number）",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var commentData = commentList[index];
              return WidgetTools().showBackToneCommentItem(context, commentData,
                  () {
                BackCheckCompanyManager.commentLike({
                  "commentId": commentData.id,
                  "type": commentData.selfLike == 1 ? 0 : 1
                }, (object) {
                  setState(() {
                    if (commentData.selfLike == 1) {
                      ToastUtils.showMessage("取消点赞成功");
                      commentData.selfLike = 0;
                      commentData.likeCount--;
                    } else {
                      ToastUtils.showMessage("点赞成功");
                      commentData.selfLike = 1;
                      commentData.likeCount++;
                    }
                  });
                });
              }, () {
                _report(commentData.content);
              });
            },
            itemCount: commentList.length,
          ),
        ],
      ),
    );
  }

  //评论
  Widget _comment() {
    Image collection;
    if (isCollection) {
      collection = const Image(
        image: AssetImage("assets/images/icon_collected.png"),
        width: 18,
        height: 18,
      );
    } else {
      collection = const Image(
        image: AssetImage("assets/images/icon_not_collected1.png"),
        width: 18,
        height: 18,
      );
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (ctx) {
                    return _enterAComment();
                  },
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: CustomColors.colorF3F2F2,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                width: double.infinity,
                height: 35,
                padding: const EdgeInsets.only(left: 22, right: 22),
                margin: const EdgeInsets.only(right: 12),
                child: Row(
                  children: const [
                    Image(
                      width: 12,
                      height: 12,
                      image: AssetImage("assets/images/icon_comment.png"),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "请输入您的观点",
                      style: TextStyle(
                        color: CustomColors.darkGrey99,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  isCollection = !isCollection;
                  if (isCollection) {
                    saveDataModel();
                    ToastUtils.showMessage("收藏成功");
                  } else {
                    cancelDataModel();
                    ToastUtils.showMessage("取消收藏成功");
                  }
                  setState(() {});
                },
                child: collection,
              ),
              // const Text(
              //   "1234",
              //   style: TextStyle(
              //     color: CustomColors.darkGrey,
              //     fontSize: 10,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  var businessLicense = TextEditingController();

  bool isFill = false;

  //评论
  Widget _enterAComment() {
    // return StatefulBuilder(builder: (context, setBottomSheetState) {
    //   return Container(
    //     color: Colors.white,
    //     width: double.infinity,
    //     padding: EdgeInsets.only(
    //         left: 16,
    //         top: 12,
    //         right: 16,
    //         bottom: (MediaQuery.of(context).viewInsets.bottom) + 12),
    //     child: Row(
    //       children: [
    //         Expanded(
    //           child: Container(
    //             decoration: const BoxDecoration(
    //               color: CustomColors.colorF5F5F5,
    //               borderRadius: BorderRadius.all(Radius.circular(2)),
    //             ),
    //             padding: const EdgeInsets.only(
    //                 left: 12, top: 5, right: 12, bottom: 5),
    //             child: TextField(
    //               autofocus: true,
    //               minLines: 3,
    //               maxLines: null,
    //                 keyboardType: TextInputType.multiline,
    //               onChanged: (text) {
    //                 setBottomSheetState(() {
    //                   isFill = text.isNotEmpty;
    //                   Log.i("${text}--${text.isNotEmpty}");
    //                 });
    //               },
    //               textAlign: TextAlign.start,
    //               inputFormatters: <TextInputFormatter>[
    //                 LengthLimitingTextInputFormatter(100),
    //                 FilteringTextInputFormatter.deny(RegExp(
    //                     "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
    //               ],
    //               controller: businessLicense,
    //               textAlignVertical: TextAlignVertical.center,
    //               decoration: const InputDecoration(
    //                 border: InputBorder.none,
    //                 contentPadding: EdgeInsets.all(0),
    //                 isCollapsed: true,
    //                 hintText: "分享你的见解",
    //                 hintStyle: TextStyle(
    //                   fontSize: 14,
    //                   color: CustomColors.lightGrey,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         InkWell(
    //           onTap: () {
    //             var string = businessLicense.text.toString();
    //             if (string.isNotEmpty) {
    //               _putComment(string);
    //               businessLicense.text = "";
    //               Navigator.of(context).pop();
    //             } else {
    //               ToastUtils.showMessage("评论不能未空");
    //             }
    //           },
    //           child: Container(
    //             width: 44,
    //             height: 22,
    //             decoration: BoxDecoration(
    //               color: isFill
    //                   ? const Color(0xFF1B7CF6)
    //                   : const Color(0x821B7CF6),
    //               borderRadius: const BorderRadius.all(Radius.circular(11)),
    //             ),
    //             margin: const EdgeInsets.only(left: 12),
    //             child: const Center(
    //               child: Text('发送',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize: 12,
    //                   )),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // });
    return StatefulBuilder(builder: (context, setBottomSheetState) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 16,
            top: 12,
            right: 16,
            bottom: (MediaQuery.of(context).viewInsets.bottom) + 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: CustomColors.colorF5F5F5,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
              padding:
                  const EdgeInsets.only(left: 12, top: 5, right: 12, bottom: 5),
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                children: [
                  TextField(
                    autofocus: true,
                    minLines: 3,
                    maxLines: 10,
                    onChanged: (text) {
                      setBottomSheetState(() {
                        isFill = text.isNotEmpty;
                        Log.i("${text}--${text.isNotEmpty}");
                      });
                    },
                    textAlign: TextAlign.start,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                      FilteringTextInputFormatter.deny(RegExp(
                          "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                    ],
                    controller: businessLicense,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                      isCollapsed: true,
                      hintText: "分享你的见解",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: CustomColors.lightGrey,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${businessLicense.text.length}/100",
                        style: const TextStyle(
                            fontSize: 12, color: CustomColors.lightGrey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    var string = businessLicense.text.toString();
                    if (string.isNotEmpty) {
                      _putComment(string);
                      businessLicense.text = "";
                      Navigator.of(context).pop();
                    } else {
                      ToastUtils.showMessage("评论不能未空");
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isFill
                          ? const Color(0xFF1B7CF6)
                          : const Color(0x821B7CF6),
                      borderRadius: const BorderRadius.all(Radius.circular(11)),
                    ),
                    margin: const EdgeInsets.only(right: 16),
                    child: const Center(
                      child: Text('发送',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _initData() {
    BackCheckCompanyManager.info({"id": widget.companyId}, (object) {
      companyInfoModel = object as BackCheckCompanyInfoModel;
      if (companyInfoModel != null) {
        setState(() {
          _comparativeCollectionData();
        });
      }
    });

    Map<String, dynamic> param = {
      "pageNum": currentPage,
      "pageSize": pageSize,
      "backCompanyId": widget.companyId,
    };
    BackCheckCompanyManager.commentList(param, (object) {
      CommentBean liModel = object as CommentBean;
      setState(() {
        total = liModel.total;
        commentList.addAll(liModel.data);
      });
    });
  }

  Future _onLoad() async {
    //自定义方法执行下拉操作
    int num = commentList.length;
    if (num >= total) {
      _isLoadMore = false;
    } else {
      currentPage++;
      Map<String, dynamic> param = {
        "pageNum": currentPage,
        "pageSize": pageSize,
        "backCompanyId": widget.companyId,
      };
      BackCheckCompanyManager.commentList(param, (object) {
        CommentBean liModel = object as CommentBean;
        setState(() {
          total = liModel.total;
          commentList.addAll(liModel.data);
        });
      });
    }
    return "";

    // //自定义方法执行下拉操作
    //
    // int num = commentList.length;
    // Log.i("---${num}");
    // if (num >= total) {
    //   _controller.finishLoad(success: true, noMore: true);
    // } else {
    //   currentPage++;
    //   Map<String, dynamic> param = {
    //     "pageNum": currentPage,
    //     "pageSize": pageSize,
    //     "backCompanyId": widget.companyId,
    //   };
    //   BackCheckCompanyManager.commentList(param, (object) {
    //     CommentBean liModel = object as CommentBean;
    //     setState(() {
    //       total = liModel.total;
    //       commentList.addAll(liModel.data);
    //     });
    //   });
    // }
    //
    // return "";
  }

  void _putComment(String content) {
    BackCheckCompanyManager.putComment(
        {"id": widget.companyId, "content": content}, (object) {
      total++;
      var bean = CommentDataBean(widget.companyId, content,
          DateTime.now().millisecondsSinceEpoch, object as int, 0, 0);
      commentList.insert(0, bean);
      ToastUtils.showMessage("评论成功");
      setState(() {});
    });
  }

  _image(String assetName) {
    return Image(
      image: AssetImage(assetName),
    );
  }

  /// *
  /// -  @description: 比较收藏数据
  /// -  @Date: 2022-06-24 18:20
  /// -  @return {*}
  ///
  void _comparativeCollectionData() {
    if (companyInfoModel != null) {
      Future<SharedPreferences> prefs = SharedPreferences.getInstance();
      prefs.then((sp) {
        List<String>? strList =
            sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY);
        if (strList != null) {
          for (var i = 0; i < strList.length; i++) {
            String str = strList[i];
            Map tem = StringTools.json2Map(str);
            int id = tem["id"];
            if (id == companyInfoModel!.id) {
              isCollection = true;
              setState(() {});
              break;
            }
          }
        }
      });
    }
  }

  /// *
  /// -  @description: 收藏公司
  /// -  @Date: 2022-06-24 18:16
  /// -  @parm:
  /// -  @return {*}
  ///
  void saveDataModel() {
    Map<String, dynamic> data = companyInfoModel!.toJson();
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY);
      if (strList != null) {
        strList.add(StringTools.map2Json(data));
      } else {
        strList = [];
        strList.add(StringTools.map2Json(data));
      }
      sp.setStringList(
          FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY, strList);
    });
  }

  /// *
  /// -  @description: 取消收藏
  /// -  @Date: 2022-06-24 18:16
  /// -  @parm:
  /// -  @return {*}
  ///
  void cancelDataModel() {
    Future<SharedPreferences> prefs = SharedPreferences.getInstance();
    prefs.then((sp) {
      List<String>? strList =
          sp.getStringList(FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY);
      List<String> temStrList = [];
      if (strList != null) {
        for (var i = 0; i < strList.length; i++) {
          String str = strList[i];
          Map tem = StringTools.json2Map(str);
          int id = tem["id"];
          if (id == companyInfoModel!.id) {
            continue;
          }
          temStrList.add(str);
        }
      }
      sp.setStringList(
          FinalKeys.SHARED_PREFERENCES_COLLECTION_COMPANY, temStrList);
    });
  }

  /// *
  /// -  @description: 底部sheet
  /// -  @Date: 2022-06-24 14:42
  /// -  @parm:
  /// -  @return {*}
  Widget _bottomSheet(String name, double score) {
    return Container(
      color: Colors.white,
      constraints: const BoxConstraints(
        maxHeight: 240,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: CustomColors.darkGrey,
                  )),
            ],
          ),
          Text(
            name,
            style: const TextStyle(
              color: CustomColors.greyBlack,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "点击星星打分",
            style: TextStyle(
              color: CustomColors.darkGrey99,
              fontSize: 12,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          RatingBar(
            itemSize: 35,
            initialRating: score,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.only(right: 7.5, left: 7.5),
            ratingWidget: RatingWidget(
              full: _image('assets/images/icon_collected.png'),
              half: _image('assets/images/icon_collected.png'),
              empty: _image('assets/images/icon_grey_not_collected.png'),
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text(
              "提交",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            onPressed: () {
              ToastUtils.showMessage("评分提交成功");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _report(String content) {
    showModalBottomSheet(
      context: context,
      // backgroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          constraints: const BoxConstraints(
            maxHeight: 182,
          ),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    color: CustomColors.whiteBFColor,
                    width: double.infinity,
                    height: 111,
                    child: Column(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: content));
                              ToastUtils.showMessage("复制到剪切板");
                              Navigator.of(context).pop();
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: const [
                                  Text(
                                    "复制",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                      color: CustomColors.connectColor,
                                      fontSize: 19,
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        Container(
                          height: 1,
                          color: CustomColors.colorD1D1D1,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ReportPage(
                                    id: "1",
                                    type: "1",
                                  ),
                                ),
                              );
                            },
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: const [
                                Text(
                                  "举报",
                                  style: TextStyle(
                                    color: CustomColors.connectColor,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                child: InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      height: 55,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Text(
                            "取消",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.color5477B8,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initUI() {
    _scrollController.addListener(() {
      ///监听滚动位置设置导航栏颜色
      setState(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          /// 加载更多操作
          _onLoad();
        }
      });
    });
  }
}
