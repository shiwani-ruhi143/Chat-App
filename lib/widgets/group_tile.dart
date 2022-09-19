import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return GestureDetector(
      onTap: () {
        nextScreenReplace(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30.r,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              )),
          title: Text(
            widget.groupName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                fontSize: 20.sp),
          ),
          subtitle: Text("Join the conversation as ${widget.userName}",
              style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
