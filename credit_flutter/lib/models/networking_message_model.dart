/// *
/// -  @Date: 2022-11-01 15:04
/// -  @LastEditTime: 2022-11-01 18:00
/// -  @Description:
///
/// @Date: 2022-06-14 14:10
/// @LastEditTime: 2022-06-14 20:44
/// @Description: 网络层用 一般消息，记录 成功/失败， 原因
class Message {
  ///成功/失败
  bool isSuccess = false;

  /// 原因
  String reason = "";

  ///扩展 纯放字符串
  String? extension;

  ///扩展 其他不能用字符串表示的
  Map<String, dynamic>? extensionDic;

  Message(this.isSuccess, this.reason, {this.extensionDic});
}
