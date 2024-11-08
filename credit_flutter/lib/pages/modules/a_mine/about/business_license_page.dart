/// *
/// -  @Date: 2022-07-01 15:30
/// -  @LastEditTime: 2022-07-01 15:30
/// -  @Description: 营业执照
///
import 'package:flutter/material.dart';

class BusinessLicensePage extends StatelessWidget {
  const BusinessLicensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
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
      body: Container(
        padding: const EdgeInsets.all(30),
        child: const Image(
          image: AssetImage("assets/images/yyzz.png"),
          height: 220,
        ),
      ),
    );
  }
}
