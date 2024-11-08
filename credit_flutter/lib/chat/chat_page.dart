/// *
/// -  @Date: 2023-09-26 09:59
/// -  @LastEditTime: 2023-09-26 10:01
/// -  @Description:
///

// import 'package:chatview/chatview.dart' as chat;
import 'dart:ffi';

import 'package:chatview3/chatview3.dart' as chat;
import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/define/define_keys.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/string_tool.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:credit_flutter/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final String _chatId = "kefuchannelimid_563522";
  final String _chatId = "aa";
  String _currentUserId = EMClient.getInstance.currentUserId ?? "";

  List<chat.Message> chatModels = [];

  /// 会话
  EMConversation? _conv;

  late chat.ChatController chatController;

  @override
  void initState() {
    chatController = chat.ChatController(
      initialMessageList: [],
      scrollController: ScrollController(),
      chatUsers: [chat.ChatUser(id: _chatId, name: "客服")],
    );

    _signUser();
    if (_currentUserId.isNotEmpty) {
      _pullHXData();
    }
    EMClient.getInstance.startCallback();

    _addChatListener();
    super.initState();
  }

  @override
  void dispose() {
    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColors.lightBlue,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "在线客服",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: chat.ChatView2(
        currentUser: chat.ChatUser(id: _currentUserId, name: "用户"),
        chatController: chatController,
        onSendTap: _onSendTap,
        featureActiveConfig: const chat.FeatureActiveConfig(
          enableDoubleTapToLike: false,
          enableSwipeToReply: false,
          enableReactionPopup: false,
          enableReplySnackBar: false,
        ),
        chatBubbleConfig: const chat.ChatBubbleConfiguration(
          inComingChatBubbleConfig: chat.ChatBubble(
            // Receiver's message chat bubble
            color: Colors.amber,
            textStyle: TextStyle(color: Colors.black),
          ),
        ),
        chatview2State: chat.ChatView2State.hasMessages,
        sendMessageConfig: const chat.SendMessageConfiguration(
          enableCameraImagePicker: false,
          enableGalleryImagePicker: true,
          allowRecordingVoice: false,
          textFieldBackgroundColor: Colors.amber,
          textFieldConfig: chat.TextFieldConfiguration(
            minLines: 1,
            textStyle: TextStyle(color: Colors.black),
            hintText: "说点什么吧",
          ),
        ),
        messageConfig: chat.MessageConfiguration(
            imageMessageConfig: chat.ImageMessageConfiguration(
          onTap: (imageUrl) {
            WidgetTools().tapImagePreview(context, imageUrl);
          },
        )),
      ),
    );
  }

  _onSendTap(String message, chat.ReplyMessage replyMessage,
      chat.MessageType messageType) {
    if (messageType.isText) {
      _sendMessage(message);
    } else if (messageType.isImage) {
      FocusManager.instance.primaryFocus?.unfocus();
      _sendImageMessage(message);
    }
  }

  _signUser() async {
    //暂时不用，从逻辑上来说这个应该是个低频操作，不需要每个打开APP的人都去注册环信用户
    //只需要当用户需要反馈时能正常发送消息就可以了
    ////2.判断是否有环信用户，有正常登录 拉取聊天记录。没有就去注册
    //用户发送完消息，需要清退，时间为三天
    if (_currentUserId.isEmpty) {
      var box = Hive.box(HiveBoxs.dataBox);
      String password = box.get(FinalKeys.BOX_HUANXIN_PASSWORD) ?? "";
      String user = box.get(FinalKeys.BOX_HUANXIN_USER) ?? "";
////判断是否有环信用户
      if (user.isEmpty || password.isEmpty) {
        /// 没有记录过用户，需要创建用户
        createAccount();
      } else {
        /// 记录过用户，需要判断是否超过清退时间。
        DateTime dateTime =
            DateTime.fromMillisecondsSinceEpoch(int.parse(user));

        int days = StringTools.getTimeDifference(dateTime.toString());
        if (days > 3) {
          /// 超过三天，清退
          createAccount();
        } else {
          ///有环信用户，去登录，拉取聊天记录
          try {
            await EMClient.getInstance.login(user, password);
            _currentUserId = EMClient.getInstance.currentUserId!;

            for (int i = 0; i < chatController.chatUsers.length; i++) {
              chat.ChatUser user = chatController.chatUsers[i];
              if (user.id.isEmpty) {
                chatController.chatUsers.removeAt(i);
              }
            }
            chatController.chatUsers
                .add(chat.ChatUser(id: _currentUserId, name: "用户"));
            setState(() {
              _pullHXData();
            });
          } on EMError catch (e) {
            Log.e(e);
          }
        }
      }
    }
  }

  ///去环信注册用户并登录
  void createAccount() async {
    var box = Hive.box(HiveBoxs.dataBox);
    String uname = "${DateTime.now().millisecondsSinceEpoch}";
    String pws = "q1234567890";
    try {
      await EMClient.getInstance.createAccount(uname, pws);
      box.put(FinalKeys.BOX_HUANXIN_USER, uname);
      box.put(FinalKeys.BOX_HUANXIN_PASSWORD, pws);
      await EMClient.getInstance.login(uname, pws);
      _currentUserId = EMClient.getInstance.currentUserId!;
    } on EMError catch (e) {
      Log.e(e);
    }
  }

  void _addChatListener() {
    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
      "UNIQUE_HANDLER_ID",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          parsingPackageMessage(msg);
        },
      ),
    );

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          for (EMMessage msg in messages) {
            parsingPackageMessage(msg);
            try {
              _conv?.markMessageAsRead(msg.msgId);
              _conv?.markAllMessagesAsRead();
            } on EMError catch (e) {
              Log.e('操作失败，原因是: $e');
            }
          }
        },
      ),
    );
  }

  void _sendMessage(String message) async {
    if (_chatId.isEmpty || message.isEmpty) {
      return;
    }

    var msg = EMMessage.createTxtSendMessage(
      targetId: _chatId,
      content: message,
    );
    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  void _sendImageMessage(String message) async {
    if (_chatId.isEmpty || message.isEmpty) {
      return;
    }
    var msg =
        EMMessage.createImageSendMessage(targetId: _chatId, filePath: message);
    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  void parsingPackageMessage(EMMessage msg) {
    if (msg.body.type == MessageType.TXT) {
      EMTextMessageBody body = msg.body as EMTextMessageBody;
      chat.Message message = chat.Message(
          message: body.content, createdAt: DateTime.now(), sendBy: msg.from!);
      chatController.addMessage(message);
      setState(() {});
    } else if (msg.body.type == MessageType.IMAGE) {
      EMImageMessageBody body = msg.body as EMImageMessageBody;
      chat.Message message = chat.Message(
          message: body.remotePath!,
          messageType: chat.MessageType.image,
          createdAt: DateTime.now(),
          sendBy: msg.from!);
      chatController.addMessage(message);
      setState(() {});
    }
  }

  void _pullHXData() async {
    try {
      _conv = await EMClient.getInstance.chatManager.getConversation(_chatId);
      List<EMMessage> msgs = await _conv?.loadMessages() as List<EMMessage>;
      if (msgs.isNotEmpty) {
        for (var i = 0; i < msgs.length; i++) {
          parsingPackageMessage(msgs[i]);
        }
      } else {
        setState(() {});
      }
    } on EMError catch (e) {
      Log.e('操作失败，原因是: $e');
    }
  }
}
