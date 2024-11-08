/// *
/// -  @Date: 2022-06-09 19:18
/// -  @LastEditTime: 2022-07-05 13:47
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-09 19:18
/// -  @LastEditTime: 2022-06-24 10:29
/// -  @Description:
///
///正则表达式帮助类
class RegexUtils {
  ///校验手机号
  static bool verifyPhoneNumber(String phone) {
    return RegExp(r"^(1[3,4,5,6,7,8,9])[0-9]{9}$").hasMatch(phone);
  }

  ///校验（最少8位，数字+字母大小写）
  static bool checkPassword(String password) {
    return RegExp(r"^(?=.*\d)(?=.*[a-zA-Z])[\s\S]{8,12}$").hasMatch(password);
  }
}
