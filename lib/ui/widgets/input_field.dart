import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/size_config.dart';
import 'package:todo/ui/theme.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.title,
      required this.note,
      this.controller,
      this.myWidget})
      : super(key: key);
  final String title;
  final String note;
  final TextEditingController? controller;
  final Widget? myWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
              padding: EdgeInsets.only(left: 14),
              margin: EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: primaryClr,
                  border: Border.all(color: Colors.grey)),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    style: subTitleStyle,
                    controller: controller,
                    autofocus: false,
                    readOnly: myWidget != null ? true : false,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[800],
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 0,
                            color: context.theme.dialogBackgroundColor),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 0,
                            color: context.theme.dialogBackgroundColor),
                      ),
                      hintText: note,
                      hintStyle: subTitleStyle,
                    ),
                  )),
                  myWidget ?? Container()
                ],
              )),
        ],
      ),
    );
  }
}
