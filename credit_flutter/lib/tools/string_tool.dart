/// *
/// @Date: 2022-05-26 14:29
/// @LastEditTime: 2022-06-07 13:33
/// @Description: 所有字符串，输入格式校验 等  工具
import 'dart:convert';
import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:credit_flutter/define/define_keys.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/asymmetric/api.dart';

class StringTools {
  final int _maxLength = 13;

  /// @description: 格式化手机号码
  /// @Date: 2022-05-26 18:56
  /// @parm:
  /// @return 整理后字符串长度
  int splitPhoneNumber(
      String text, TextEditingController controller, int inputLength) {
    if (text.length > inputLength) {
      if (inputLength >= _maxLength) {
        text = text.substring(0, _maxLength);
        controller.text = text;
        controller.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length));
        return _maxLength;
      }
      //输入
      if (text.length == 4 || text.length == 9) {
        text =
            "${text.substring(0, text.length - 1)} ${text.substring(text.length - 1, text.length)}";
        controller.text = text;
        controller.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length)); //光标移到最后
      }
    } else {
      //删除
      if (text.length == 4 || text.length == 9) {
        text = text.substring(0, text.length - 1);
        controller.text = text;
        controller.selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: text.length)); //光标移到最后
      }
    }
    return text.length;
  }

  /// @description: 拼接字符串
  /// @Date: 2022-05-30 23:32
  /// @parm: strList 要拼接的字符串集合，
  ///        separated 分隔符
  /// @return {*}
  String concatenatedString(List<String> strList, String separated) {
    String temp = "";
    for (var i = 0; i < strList.length; i++) {
      if (i != 0) {
        temp += separated;
      }
      String str = strList[i];
      temp = temp + str;
      temp += separated;
    }
    return temp;
  }

  /// @description: 截取并拼接字符串
  /// @Date: 2022-05-30 23:32
  /// @parm: sourceStr 原始字符串，
  ///        symbol 拼接符 默认...
  ///        len 要截取的长度 默认10
  /// @return {*}
  static String truncateConcatenatedString(
    String sourceStr, {
    String symbol = "...",
    int len = 10,
  }) {
    String temp = "";

    if (sourceStr.length <= len) {
      return sourceStr;
    }

    temp = sourceStr.substring(0, len);
    temp = temp + symbol;

    return temp;
  }

  /// *
  /// -  @description: 隐藏信息
  /// -  @Date: 2022-09-20 13:31
  /// -  @parm: sourceStr原始字符串，
  ///           symbol 拼接符
  ///           type 0,名字，1，身份证
  /// -  @return {*}
  ///
  static String hiddenInfoString(
    String sourceStr, {
    String symbol = "*",
    int type = 0,
  }) {
    String temp = "";

    if (sourceStr.isEmpty) {
      return sourceStr;
    }

    if (sourceStr.length == 2) {
      temp = sourceStr.substring(0, 1);
      temp = temp + symbol;
    } else if (sourceStr.length > 2) {
      String firtStr = "";
      String endStr = "";
      int len = 0;
      if (type == 0) {
        firtStr = sourceStr[0];
        endStr = sourceStr[sourceStr.length - 1];
        len = 2;
      } else {
        firtStr = sourceStr.substring(0, 3);
        endStr = sourceStr.substring(sourceStr.length - 4, sourceStr.length);
        len = 7;
      }

      String str = "";
      for (var i = 0; i < sourceStr.length - len; i++) {
        str += symbol;
      }

      temp = firtStr + str + endStr;
    } else {
      temp = sourceStr;
    }

    return temp;
  }

  ///判断字符串是空的 ""也是空
  ///[str] 需要判断的字符串
  static isEmpty(String? str) {
    return str?.isEmpty ?? true;
  }

  ///判断字符串非空 ""也是空
  ///[str] 需要判断的字符串
  static isNotEmpty(String? str) {
    return str?.isNotEmpty ?? false;
  }

  ///判断字符串空格
  static bool checkSpace(String str) {
    return RegExp(r'[!@#<>?"\s:_`~;[\]\\|=+)(*&^%-]|^$').hasMatch(str);
  }

  ///判断字符英文字符
  static bool checkABC(String str) {
    String regex1 = ".*[a-zA-z].*";
    return RegExp(regex1).hasMatch(str);
    // return false;
  }

  ///隐藏手机号中间4位
  static String phoneEncryption(String str) {
    return str.replaceFirst(RegExp(r'\d{4}'), '****', 3);
  }

  /// *
  /// -  @description: 格式化价格 ¥**.00
  /// -  @Date: 2022-07-13 17:29
  /// -  @parm:  isSymbol 是否有符号
  ///            str 价格
  /// -  @return {*}
  ///
  static String numberFormat(String str, bool isSymbol) {
    String tem = str;
    if (str.isEmpty) {
      tem = "0";
    }
    final oCcy = NumberFormat("#,##0.00", "en_US");

    String formatStr = oCcy.format(double.parse(tem));
    if (isSymbol == true) {
      return "¥$formatStr";
    } else {
      return formatStr;
    }
  }

  /// -  @description: 格式化数字 **,***,***
  /// -  @Date: 2023-09-05 14:48
  /// -  @parm:
  /// -  @return {*}
  ///
  static String numberFormatted(String number) {
    String tem = number;
    if (number.isEmpty) {
      tem = "0";
    }
    final oCcy = NumberFormat("#,##0", "en_US");

    String formatStr = oCcy.format(double.parse(tem));

    return formatStr;
  }

  ///使用md5加密
  static String generateMD5(String data) {
    //4B813DB4-D770-4AEC-96F8-9A6DC77810CA
    Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    return digest.toString();
  }

  ///使用RSA加密
  static String generateRSA(Map<String, dynamic> map) {
    // var now = DateTime.now(); //获取当前时间
    // map["commonData"] = now.millisecondsSinceEpoch.toString();

    String jsonStr = convert.jsonEncode(map);

    const publicPem = FinalKeys.ENCRYPTION_RSA_BEGIN_KEY +
        FinalKeys.ENCRYPTION_RSA_KEY +
        FinalKeys.ENCRYPTION_RSA_END_KEY;

    final parser = RSAKeyParser();

    RSAPublicKey publicKey = parser.parse(publicPem) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    return encrypter.encrypt(jsonStr).base64;
  }

  ///Map -> JSONString
  static String map2Json(Map<String, dynamic> map) {
    return convert.jsonEncode(map);
  }

  ///Map -> JSONString
  static String string2Jso1n(String json) {
    return convert.jsonEncode(json);
  }

  ///jsonString -> Map
  static Map<String, dynamic> json2Map(String jsonStr) {
    return convert.jsonDecode(jsonStr);
  }

  // 校验身份证合法性
  static Map<String, dynamic> verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      print(tip);
      pass = false;
      return {"state": pass, "message": tip};
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      print(tip);
      pass = false;
      return {"state": pass, "message": tip};
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        print(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      print(tip);
      pass = false;
    }
    return {"state": pass, "message": tip};
  }

  // 根据身份证号获取生日
  static String getBirthdayFromCardId(String cardId) {
    bool isRight = StringTools.verifyCardId(cardId)["state"];
    if (!isRight) {
      return "";
    }
    int len = (cardId + "").length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = cardId.substring(6, 10) +
          "-" +
          cardId.substring(10, 12) +
          "-" +
          cardId.substring(12, 14);
    }
    if (len == 15) {
      strBirthday = "19" +
          cardId.substring(6, 8) +
          "-" +
          cardId.substring(8, 10) +
          "-" +
          cardId.substring(10, 12);
    }

    return strBirthday;
  }

// // 根据身份证号获取年龄
//   int getAgeFromCardId(String cardId) {
//     bool isRight = verifyCardId(cardId);
//     if (!isRight) {
//       return 0;
//     }
//     int len = (cardId + "").length;
//     String strBirthday = "";
//     if (len == 18) {
//       //处理18位的身份证号码从号码中得到生日和性别代码
//       strBirthday = cardId.substring(6, 10) +
//           "-" +
//           cardId.substring(10, 12) +
//           "-" +
//           cardId.substring(12, 14);
//     }
//     if (len == 15) {
//       strBirthday = "19" +
//           cardId.substring(6, 8) +
//           "-" +
//           cardId.substring(8, 10) +
//           "-" +
//           cardId.substring(10, 12);
//     }
//     int age = getAgeFromBirthday(strBirthday);
//     return age;
//   }

// // 根据出生日期获取年龄
//   int getAgeFromBirthday(String strBirthday) {
//     if (strBirthday == null || strBirthday.isEmpty) {
//       print('生日错误');
//       return 0;
//     }
//     DateTime birth = DateTime.parse(strBirthday);
//     DateTime now = DateTime.now();

//     int age = now.year - birth.year;
//     //再考虑月、天的因素
//     if (now.month < birth.month ||
//         (now.month == birth.month && now.day < birth.day)) {
//       age--;
//     }
//     return age;
//   }

// 根据身份证获取性别
  static String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = StringTools.verifyCardId(cardId)["state"];
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  // 根据身份证获取性别
  static String getDistrictFromCardId(String cardId) {
    String district = "";
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    bool isRight = StringTools.verifyCardId(cardId)["state"];
    if (!isRight) {
      return district;
    }
    district = city[int.parse(cardId.substring(0, 2))];
    return district;
  }

  // 根据出生日期获取年龄
  static String getAgeFromCardId(String cardId) {
    bool isRight = StringTools.verifyCardId(cardId)["state"];
    if (!isRight) {
      return "";
    }
    String strBirthday = StringTools.getBirthdayFromCardId(cardId);

    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
//再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age.toString();
  }

// 邮箱判断
  static bool isEmail(String input) {
    String regexEmail =
        "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$";
    if (input.isEmpty) return false;
    return RegExp(regexEmail).hasMatch(input);
  }

  /// 获取当前时间
  /// 返回String
  static String getNowTime() {
    DateTime now = DateTime.now();
    return now.toString();
  }

  /// 计算时间差 日期1 和当前时间计算
  /// parme：String time 日期，  timeType 类型
  /// 返回 int 天数
  static int getTimeDifference(String time, {String timeType = "day"}) {
    if (time.isEmpty) {
      if (timeType == "month") {
        return 1;
      } else {
        return 0;
      }
    }
    DateTime now = DateTime.now();
    DateTime dt = DateTime.parse(time);
    if (timeType == "day") {
      return now.difference(dt).inDays;
    }
    if (timeType == "month") {
      int days = now.difference(dt).inDays;
      if ((days / 30) > 1) {
        return 1;
      } else {
        return 0;
      }
    }

    return 0;
  }
}
