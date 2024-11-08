/// *
/// -  @Date: 2022-07-01 15:30
/// -  @LastEditTime: 2022-07-01 15:30
/// -  @Description: 营业执照
///
import 'package:flutter/material.dart';
import 'package:flutter_drag_scale_widget/flutter_drag_scale_widget.dart';

class BusinessLicensePage extends StatelessWidget {
  const BusinessLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              "营业执照",
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: DragScaleContainer(
        doubleTapStillScale: true,
        child: Container(
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 300),
          child: const Image(
            image: AssetImage("assets/images/yyzz.png"),
            fit: BoxFit.contain,
            height: 220,
          ),
        ),
      ),
    );
  }
}
