/// *
/// -  @Date: 2023-09-08 14:20
/// -  @LastEditTime: 2023-09-08 14:20
/// -  @Description: 自定义工具
///

class CommonUtils {
  static DateTime? lastPopTime;

  // 防重复提交
  static bool checkClick({int needTime = 600}) {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime ?? DateTime.now()) >
            Duration(milliseconds: needTime)) {
      lastPopTime = DateTime.now();
      return true;
    }
    return false;
  }
}
