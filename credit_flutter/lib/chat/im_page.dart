///
////// -  @Date: 2023-09-20 14:40
/// -  @LastEditTime: 2023-09-20 14:44
/// -  @Description: 在线客服
/// 暂时弃用  聊天页面使用 chat_page.dart

import 'package:credit_flutter/define/define_colors.dart';
import 'package:credit_flutter/tools/db/hive_boxs.dart';
import 'package:credit_flutter/tools/widget_tool.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

import '../define/define_keys.dart';

class OnlineServisePage extends StatefulWidget {
  const OnlineServisePage({super.key});

  @override
  State<OnlineServisePage> createState() => _OnlineServisePageState();
}

class _OnlineServisePageState extends State<OnlineServisePage> {
  final String _chatId = "kefuchannelimid_563522";
  ScrollController scrollController = ScrollController();
  String _messageContent = "";

  late ListObserverController observerController;
  late ChatScrollObserver chatObserver;
  List<EMMessage> chatModels = [];
  ValueNotifier<int> unreadMsgCount = ValueNotifier<int>(0);
  bool needIncrementUnreadMsgCount = false;
  bool editViewReadOnly = false;
  TextEditingController editViewController = TextEditingController();
  BuildContext? pageOverlayContext;
  final LayerLink layerLink = LayerLink();
  bool isShowClassicHeaderAndFooter = false;

  @override
  void initState() {
    _signUser();
    EMClient.getInstance.startCallback();
    _addChatListener();

    // _fetchHistoryMessages();

    scrollController.addListener(_scrollControllerListener);

    observerController = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;

    chatObserver = ChatScrollObserver(observerController)
      ..fixedPositionOffset = 5
      ..toRebuildScrollViewCallback = () {
        setState(() {});
      }
      ..onHandlePositionResultCallback = (result) {
        if (!needIncrementUnreadMsgCount) return;
        switch (result.type) {
          case ChatScrollObserverHandlePositionType.keepPosition:
            updateUnreadMsgCount(changeCount: result.changeCount);
            break;
          case ChatScrollObserverHandlePositionType.none:
            updateUnreadMsgCount(isReset: true);
            break;
        }
      };

    super.initState();
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    Widget resultWidget = Column(
      children: [
        Expanded(child: _buildListView()),
        CompositedTransformTarget(
          link: layerLink,
          child: Container(),
        ),
        _buildEditView(),
        const SafeArea(top: false, child: SizedBox.shrink()),
      ],
    );
    resultWidget = Stack(children: [
      resultWidget,
      _buildPageOverlay(),
    ]);
    return resultWidget;
  }

  Widget _buildPageOverlay() {
    return Overlay(initialEntries: [
      OverlayEntry(
        builder: (context) {
          pageOverlayContext = context;
          return Container();
        },
      )
    ]);
  }

  Widget _buildListView() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Widget resultWidget = EasyRefresh.builder(
          header: WidgetTools().getClassicalHeader(),
          footer: WidgetTools().getClassicalFooter(),
          builder: (context, physics, header, footer) {
            var scrollViewPhysics =
                physics.applyTo(ChatObserverClampingScrollPhysics(
              observer: chatObserver,
            ));
            Widget resultWidget = ListView.builder(
              // physics: chatObserver.isShrinkWrap
              //     ? const NeverScrollableScrollPhysics()
              //     : scrollViewPhysics,
              padding: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 15,
                bottom: 15,
              ),
              // shrinkWrap: chatObserver.isShrinkWrap,
              // reverse: true,
              controller: scrollController,
              itemBuilder: ((context, index) {
                return ChatItemWidget(
                  chatModel: chatModels[index],
                  index: index,
                  itemCount: chatModels.length,
                  onRemove: () {
                    chatObserver.standby(isRemove: true);
                    setState(() {
                      chatModels.removeAt(index);
                    });
                  },
                );
              }),
              itemCount: chatModels.length,
            );
            if (chatObserver.isShrinkWrap) {
              resultWidget = SingleChildScrollView(
                reverse: true,
                physics: scrollViewPhysics,
                child: Container(
                  alignment: Alignment.topCenter,
                  child: resultWidget,
                  height: constraints.maxHeight + 0.001,
                ),
              );
            }
            return resultWidget;
          },
        );

        resultWidget = ListViewObserver(
          controller: observerController,
          child: resultWidget,
        );
        resultWidget = Align(
          child: resultWidget,
          alignment: Alignment.topCenter,
        );
        return resultWidget;
      },
    );
  }

  addUnreadTipView() {
    Overlay.of(pageOverlayContext!)?.insert(OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          followerAnchor: Alignment.bottomRight,
          targetAnchor: Alignment.topRight,
          offset: const Offset(-20, 0),
          child: Material(
            type: MaterialType.transparency,
            // color: Colors.green,
            child: _buildUnreadTipView(),
          ),
        ),
      ),
    ));
  }

  Widget _buildUnreadTipView() {
    return ValueListenableBuilder<int>(
      builder: (context, value, child) {
        return ChatUnreadTipView(
          unreadMsgCount: unreadMsgCount.value,
          onTap: () {
            scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            updateUnreadMsgCount(isReset: true);
          },
        );
      },
      valueListenable: unreadMsgCount,
    );
  }

  Widget _buildEditView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) {
                _messageContent = value;
              },
              style: const TextStyle(color: Colors.black),
              maxLines: 1,
              minLines: 1,
              showCursor: true,
              readOnly: editViewReadOnly,
              controller: editViewController,
            ),
          ),
          TextButton(
            child: const Text('发送'),
            onPressed: () {
              _sendMessage();
              _messageContent = "";
              editViewController.text = "";
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    observerController.controller?.dispose();
    editViewController.dispose();
    EMClient.getInstance.chatManager.removeMessageEvent("UNIQUE_HANDLER_ID");
    EMClient.getInstance.chatManager.removeEventHandler("UNIQUE_HANDLER_ID");
    super.dispose();
  }

  void _addChatListener() {
    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
      "UNIQUE_HANDLER_ID",
      ChatMessageEvent(
        onSuccess: (msgId, msg) {
          _addLogToConsole(msg);
        },
        // onProgress: (msgId, progress) {
        //   _addLogToConsole("on message progress");
        // },
        // onError: (msgId, msg, error) {
        //   _addLogToConsole(
        //     "on message failed, code: ${error.code}, desc: ${error.description}",
        //   );
        // },
      ),
    );

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          for (EMMessage msg in messages) {
            _addLogToConsole(msg);
            msg.hasReadAck = true;
          }
        },
      ),
    );
  }

  void _sendMessage() async {
    if (_chatId.isEmpty || _messageContent.isEmpty) {
      return;
    }

    var msg = EMMessage.createTxtSendMessage(
      targetId: _chatId,
      content: _messageContent,
    );

    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  void _addLogToConsole(EMMessage ms) {
    chatModels.add(ms);
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }

  updateUnreadMsgCount({
    bool isReset = false,
    int changeCount = 1,
  }) {
    needIncrementUnreadMsgCount = false;
    if (isReset) {
      unreadMsgCount.value = 0;
    } else {
      unreadMsgCount.value += changeCount;
    }
  }

  _scrollControllerListener() {
    if (scrollController.offset < 50) {
      updateUnreadMsgCount(isReset: true);
    }
  }

  _signUser() async {
    String currentUserId = EMClient.getInstance.currentUserId ?? "";
    if (currentUserId.isEmpty) {
      var box = Hive.box(HiveBoxs.dataBox);
      String password = box.get(FinalKeys.BOX_HUANXIN_PASSWORD) ?? "";
      String user = box.get(FinalKeys.BOX_HUANXIN_USER) ?? "";
      try {
        await EMClient.getInstance.login(user, password);
      } on EMError catch (e) {}
    }
  }

  _fetchHistoryMessages() async {
    try {
      EMCursorResult<EMMessage> a =
          await EMChatManager().fetchHistoryMessages(conversationId: _chatId);
      print(a);
    } on EMError catch (e) {
      print(e);
    }
  }
}

class ChatUnreadTipView extends StatelessWidget {
  ChatUnreadTipView({
    Key? key,
    required this.unreadMsgCount,
    this.onTap,
  }) : super(key: key);

  final int unreadMsgCount;

  final Color primaryColor = Colors.green[100]!;

  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (unreadMsgCount == 0) return const SizedBox.shrink();
    Widget resultWidget = Stack(
      children: [
        const Icon(
          Icons.mode_comment,
          size: 50,
          color: Colors.white,
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          width: 50,
          child: Center(
            child: Text(
              '$unreadMsgCount',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
    resultWidget = GestureDetector(
      child: resultWidget,
      onTap: onTap,
    );
    return resultWidget;
  }
}

class ChatItemWidget extends StatelessWidget {
  const ChatItemWidget({
    Key? key,
    required this.chatModel,
    required this.index,
    required this.itemCount,
    this.onRemove,
  }) : super(key: key);

  final EMMessage chatModel;
  final int index;
  final int itemCount;
  final Function? onRemove;
  // final String _chatId = "kefuchannelimid_563522";
  final String _chatId = "aa";

  @override
  Widget build(BuildContext context) {
    bool flag = true;
    if (chatModel.from == _chatId) {
      flag = false;
    }

    final isOwn = flag;
    final nickName = isOwn == true ? "用户" : "客服";
    Widget contenView;
    switch (chatModel.body.type) {
      case MessageType.TXT:
        {
          EMTextMessageBody body = chatModel.body as EMTextMessageBody;
          contenView = Text(
            body.content,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          );
        }
        break;
      case MessageType.IMAGE:
        {
          EMImageMessageBody body = chatModel.body as EMImageMessageBody;
          contenView = Image(
            image: NetworkImage(body.thumbnailRemotePath ?? ""),
            width: 100,
            height: 80,
            fit: BoxFit.fitHeight,
          );
        }
        break;
      default:
        {
          contenView = const Text(
            "消息未知格式",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          );
        }
    }

    Widget resultWidget = Row(
      textDirection: isOwn ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isOwn ? Colors.blue : Colors.black,
          ),
          child: Center(
            child: Text(
              nickName,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isOwn
                    ? const Color.fromARGB(255, 21, 125, 200)
                    : const Color.fromARGB(255, 39, 39, 38),
                borderRadius: BorderRadius.circular(4),
              ),
              child: contenView),
        ),
        const SizedBox(width: 50),
      ],
    );
    resultWidget = Column(
      children: [
        resultWidget,
        const SizedBox(height: 15),
      ],
    );
    resultWidget = Dismissible(
      key: UniqueKey(),
      child: resultWidget,
      onDismissed: (_) {
        onRemove?.call();
      },
    );
    return resultWidget;
  }
}
