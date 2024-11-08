import 'dart:async';
import 'dart:math';

import 'package:app_installer/app_installer.dart';
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/manager/version_manager.dart';
import 'package:credit_flutter/tools/screen_tool.dart';
import 'package:credit_flutter/utils/platform_utils.dart';
import 'package:credit_flutter/utils/toast_utils.dart';
import 'package:flutter/material.dart';

class UpdateUtils {
  int type = 0;
  int buildNumber = 0;
  String version = "";
  late BuildContext context;

  var onWillPop = true;
  var receive = 0;
  var total = 0;
  var isDownload = false;
  var isFinished = false;
  var finished = "";

  void appUpdate(
      BuildContext context, int buildNumber, String version, int type) {
    this.type = type;
    this.context = context;
    this.buildNumber = buildNumber;
    this.version = version;
    VersionManager.getAppVersion((map) {
      ifVersion(map);
    });
  }

  void ifVersion(Map<String, dynamic> map) {
    if (map["latestVersion"] != null) {
      Map<String, dynamic> latest = map["latestVersion"];
      //有最新版本
      var logicalVersion = latest["logicalVersion"];
      var versionNum = latest["versionNum"];
      //更新状态 1.不强制更新弹框 2.强制更新弹框 3.不强制不弹框
      var state = -1;
      // var versionNum = "";
      var publishContent = "";
      var releaseUrl = "";
      if (_compare(versionNum, logicalVersion)) {
        //小于最新版本
        state = latest["state"];
        // versionNum = latest["versionNum"];
        publishContent = latest["publishContent"];
        releaseUrl = latest["releaseUrl"];
      }

      if (map["mostVersion"] != null) {
        Map<String, dynamic> most = map["mostVersion"];
        //有最小版本
        var logicalVersion = most["logicalVersion"];
        if (_compare(versionNum, logicalVersion)) {
          // if (buildNumber < logicalVersion) {
          //不满足最小版本
          var mostState = most["state"];
          if (state == -1) {
            state = mostState;
            versionNum = most["versionNum"];
            publishContent = most["publishContent"];
            releaseUrl = most["releaseUrl"];
          } else {
            if (mostState == 2) {
              state = 2;
            }
          }
        }
      }
      if (state != -1) {
        //有最新版
        if (PlatformUtils.isAndroid && state == 2) {
          onWillPop = false;
        }
        if (type == 0) {
          showRenewDialog(
              publishContent, releaseUrl, versionNum, logicalVersion, state);
        } else if (state == 1 || state == 2) {
          showRenewDialog(
              publishContent, releaseUrl, versionNum, logicalVersion, state);
        }
      } else {
        if (type == 0) {
          ToastUtils.showMessage("当前已是最新版本");
        }
      }
    } else {
      if (type == 0) {
        ToastUtils.showMessage("当前已是最新版本");
      }
    }
  }

  void showRenewDialog(String publishContent, String releaseUrl,
      String versionNum, logicalVersion, int state) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, update) {
            return WillPopScope(
              onWillPop: () async {
                return Future.value(onWillPop);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                      Expanded(
                        flex: 8,
                        child: Stack(
                          children: [
                            const Image(
                              image: AssetImage(
                                  "assets/images/icon_version_update.png"),
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.only(left: 18, right: 18),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 65,
                                  ),
                                  const Text(
                                    "发现新版本",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    "$versionNum版本",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(
                                    height: ScreenTool.screenHeight * 0.22,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          publishContent,
                                          style: const TextStyle(
                                            color: CustomColors.greyBlack,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Visibility(
                                          visible: isDownload,
                                          child: Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " 下载进度：${formatFileSize(receive.toDouble())}/${formatFileSize(total.toDouble())}",
                                                  style: const TextStyle(
                                                    color:
                                                        CustomColors.darkGrey99,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Container(
                                                  height: 10,
                                                  width: double.infinity,
                                                  margin: const EdgeInsets.only(
                                                      left: 8, right: 8),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(4)),
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: receive == 0
                                                          ? 0.01
                                                          : (receive / total)
                                                              .toDouble(),
                                                      // 当前进度
                                                      backgroundColor:
                                                          CustomColors
                                                              .whiteBlueColorFE,
                                                      // 进度条背景色
                                                      valueColor:
                                                          const AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Color(
                                                                  0xFF4587FF)),
                                                      // 进度条当前进度颜色
                                                      minHeight: 5, // 最小宽度
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _getClose(state),
                                        Visibility(
                                          visible: !isDownload,
                                          child: Expanded(
                                            child: Container(
                                              height: 42,
                                              margin: const EdgeInsets.only(
                                                  left: 6),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: const Color(0xFF4587FF),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Color(0x4D4587FF),
                                                    offset: Offset(0, 5),
                                                    blurRadius: 8,
                                                  ),
                                                ],
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  if (PlatformUtils.isAndroid) {
                                                    if (isFinished) {
                                                      //下载完成
                                                      AppInstaller.installApk(
                                                          finished);
                                                      return;
                                                    }

                                                    if (isDownload) {
                                                      return;
                                                    }
                                                    onWillPop = false;
                                                    isDownload = true;

                                                    VersionManager.download(
                                                        releaseUrl,
                                                        "${logicalVersion}_hyc.apk",
                                                        (map) {
                                                      receive = map["receive"];
                                                      total = map["total"];
                                                      update(() {});
                                                    }, (map) {
                                                      // Navigator.of(context).pop();
                                                      isFinished = true;
                                                      finished = map;
                                                      isDownload = false;
                                                      update(() {});
                                                      AppInstaller.installApk(
                                                          map);
                                                    });
                                                  } else if (PlatformUtils
                                                      .isIOS) {
                                                    AppInstaller.goStore(
                                                        "", "id6444669734");
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                    isFinished ? "安装" : "马上更新",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  _getClose(int state) {
    if (state != 2) {
      return Visibility(
        visible: !isDownload,
        child: Expanded(
          child: Container(
            height: 42,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFECE9E9),
                  offset: Offset(0, 5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Center(
                child: Text(
                  "下次再说",
                  style: TextStyle(
                    color: Color(0xFF7A7A7A),
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  /// 将文件大小 格式化
  /// [fileSize] 文件大小
  /// [position] 保留几位小数
  /// [scale] 比例 1000/1024
  /// [specified] 0-5 指定的单位 0是B 1是KB 2是mb 3是GB 4是TB 5是PB
  String formatFileSize(fileSize,
      {position = 2, scale = 1024, specified = -1}) {
    double num = 0;
    if (fileSize > 0) {
      List sizeUnit = ["B", "KB", "MB", "GB", "TB", "PB"];
      if (fileSize is String) {
        num = double.parse(fileSize);
      } else if (fileSize is int || fileSize is double) {
        num = fileSize;
      }
      //获取他的单位
      if (num > 0) {
        int unit = log(num) ~/ log(scale);
        if (specified >= 0 && specified < sizeUnit.length) {
          unit = specified;
        }
        double size = num / pow(scale, unit);
        String numStr = formatNum(num: size, position: position);
        return "$numStr ${sizeUnit[unit]}";
      }
    }
    return "0 B";
  }

  ///格式化数字 如果小数后面为0则不显示小数点
  ///[num]要格式化的数字 double 类型
  /// [position] 保留几位小数 int类型
  formatNum({required double num, required int position}) {
    String numStr = num.toString();
    int dotIndex = numStr.indexOf(".");

    ///当前数字有小数且需要小数位数小于需要的 直接返回当前数字
    if (num % 1 != 0 && (numStr.length - 1 - dotIndex < position)) {
      return numStr;
    }
    int numbs = pow(10, position).toInt();
    //模运算 取余数
    double remainder = num * numbs % numbs;
    //小数点后位数如果小于0则表示只保留整数,余数小于1不会进位防止出现200.01保留一位小数出现200.0的情况
    if (position > 0 && remainder >= 0.5) {
      return num.toStringAsFixed(position);
    }
    return num.toStringAsFixed(0);
  }

  bool _compare(String versionNum, int logicalVersion) {
    if (PlatformUtils.isIOS) {
      return haveNewVersion(versionNum, version);
      // double.parse(version) < double.parse(versionNum);
    } else {
      return buildNumber < logicalVersion;
    }
  }

  bool haveNewVersion(String newVersion, String old) {
    if (newVersion == null ||
        newVersion.isEmpty ||
        old == null ||
        old.isEmpty) {
      return false;
    }
    int newVersionInt, oldVersion;
    var newList = newVersion.split('.');
    var oldList = old.split('.');
    if (newList.isEmpty || oldList.isEmpty) {
      return false;
    }
    for (int i = 0; i < newList.length; i++) {
      newVersionInt = int.parse(newList[i]);
      oldVersion = int.parse(oldList[i]);
      if (newVersionInt > oldVersion) {
        return true;
      } else if (newVersionInt < oldVersion) {
        return false;
      }
    }

    return false;
  }
}
