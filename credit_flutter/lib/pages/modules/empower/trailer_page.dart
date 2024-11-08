/// *
/// -  @Date: 2022-08-19 11:22
/// -  @LastEditTime: 2022-09-27 13:41
/// -  @Description:
///
/// *
/// -  @Date: 2022-06-16 14:24
/// -  @LastEditTime: 2022-09-19 14:02
/// -  @Description:首页
///
import 'package:credit_flutter/define/define_colors.dart';
import 'package:flutter/material.dart';

class TrailerPage extends StatefulWidget {
  int type;

  TrailerPage({Key? key, required this.type}) : super(key: key);

  @override
  State<TrailerPage> createState() => _TrailerPageState();
}

class _TrailerPageState extends State<TrailerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 100),
            _getImage(),
            const SizedBox(height: 20),
            _getContent(),
            // Container(
            //   margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            //   height: 45,
            //   decoration: BoxDecoration(
            //     color: isTime && bottom
            //         ? const Color(0xFF1B7CF6)
            //         : const Color.fromRGBO(200, 200, 200, 0.7),
            //     borderRadius: const BorderRadius.all(Radius.circular(22.5)),
            //   ),
            //   child: InkWell(
            //     highlightColor: Colors.transparent,
            //     splashColor: Colors.transparent,
            //     onTap: () {
            //       if (isTime && bottom) {
            //         Navigator.of(context).pop("ok");
            //       }
            //     },
            //     child: Center(
            //       child: Text(
            //         handleCodeText(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 16,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  _getImage() {
    var image = "";
    switch (widget.type) {
      case 1:
        image = "icon_submit_successfully";
        break;
      case 2:
        image = "icon_circular_rejection";
        break;
    }
    return Image(
      image: AssetImage("assets/images/$image.png"),
      width: 96,
      height: 96,
    );
  }

  _getContent() {
    return Text(
      widget.type == 1 ? "授权完成" : "您已主动拒绝签署",
      style: const TextStyle(
        color: CustomColors.greyBlack,
        fontSize: 17,
      ),
    );
  }
}
