import 'package:chat_app/pages/group_info.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/message_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatPage extends StatefulWidget {
  final String groupName;
  final String groupId;
  final String userName;

  const ChatPage(
      {super.key,
      required this.groupId,
      required this.groupName,
      required this.userName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() {
    chats = DatabaseService().getChats(widget.groupId);
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: TextStyle(fontSize: 27.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextScreenReplace(
                    context,
                    GroupInfo(
                        adminName: admin,
                        groupId: widget.groupId,
                        groupName: widget.groupName));
              },
              icon: Icon(Icons.info_outline)),
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
              width: MediaQuery.of(context).size.width,
              color: Color.fromARGB(255, 90, 90, 90),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Send a message..",
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      _isLoading = true;
                      setState(() {});
                      await sendMessage();
                    },
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(20.r)),
                      child: _isLoading
                          ? Padding(
                              padding: EdgeInsets.all(10.r),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return MessageTile(
                        time: snapshot
                            .data!
                            .docs[snapshot.data!.docs.length - index - 1]
                                ['time']
                            .toDate(),
                        message: snapshot.data!
                                .docs[snapshot.data!.docs.length - index - 1]
                            ['message'],
                        sender: snapshot.data!
                                .docs[snapshot.data!.docs.length - index - 1]
                            ['sender'],
                        sentByMe: widget.userName ==
                            snapshot.data!.docs[snapshot.data!.docs.length -
                                index -
                                1]['sender']);
                  }),
                ),
              )
            : Container();
      },
    );
  }

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        'message': messageController.text,
        'sender': widget.userName,
        'time': DateTime.now()
      };
      await DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
        _isLoading = false;
      });
    }
  }
}
