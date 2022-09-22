import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime time;

  const MessageTile(
      {super.key,
      required this.time,
      required this.message,
      required this.sender,
      required this.sentByMe});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    // print(widget.time);
    ScreenUtil.init(context);
    return Container(
      padding: EdgeInsets.only(
          top: 4.h,
          bottom: 4.h,
          left: widget.sentByMe ? 0 : 24.w,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding:
            EdgeInsets.only(top: 10.h, bottom: 10.h, left: 20.w, right: 20.w),
        margin: widget.sentByMe
            ? EdgeInsets.only(left: 30.w)
            : EdgeInsets.only(right: 30.w),
        decoration: BoxDecoration(
            borderRadius: widget.sentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r))
                : BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r)),
            color: widget.sentByMe ? const Color(0xFFee7b64) : Colors.grey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sentByMe ? "You" : widget.sender,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              widget.message,
              style: TextStyle(fontSize: 16.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 8.h,
            ),
            SizedBox(
              width: 100.w,
              child: Text(
                widget.time.hour.toString() +
                    ":" +
                    (widget.time.minute.toString()),
                textAlign: TextAlign.right,
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
