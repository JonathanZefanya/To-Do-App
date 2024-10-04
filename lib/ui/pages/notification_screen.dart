// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/theme.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
    required this.payload,
  });
  final String payload;
  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String _payload = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        backgroundColor: context.theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          _payload.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  'Hello , Sayang',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Get.isDarkMode ? Colors.white : darkGreyClr),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Aku Ingetin Kamu',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 30, right: 30),
                margin: EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25), color: primaryClr),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.text_format,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Judul", //_payload.toString().split('|')[0],
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 26),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payload.toString().split('|')[0],
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Deskripsi", //_payload.toString().split('|')[0],
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 26),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payload.toString().split('|')[1],
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Tanggal", //_payload.toString().split('|')[0],
                            style: TextStyle(
                                color: Get.isDarkMode
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 26),
                          ),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        _payload.toString().split('|')[2],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
