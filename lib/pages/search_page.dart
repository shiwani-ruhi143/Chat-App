import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  bool isJoined = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getID(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        title: Text(
          "Search",
          style: TextStyle(fontSize: 27.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                        controller: searchController,
                        style: TextStyle(color: Colors.white),
                        decoration: textInputDecoration.copyWith(
                            hintText: ("Search Here"),
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 205, 201, 201))))),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                    print('object');
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: searchSnapshot!.docs.length,
              itemBuilder: ((context, index) {
                return groupTile(
                    userName,
                    searchSnapshot!.docs[index]['groupId'],
                    searchSnapshot!.docs[index]['groupName'],
                    searchSnapshot!.docs[index]['admin']);
              }),
            ),
          )
        : Container();
  }

  Future joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    //function to check whether user is in group or not
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      leading: CircleAvatar(
        radius: 20.r,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.sp),
      ),
      subtitle: Text("Admin: " + getName(admin)),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .toggleGroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(
                context, Colors.green[300], "Successfully joined the group");
            Future.delayed(Duration(seconds: 2), () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatPage(
                            groupId: groupId,
                            groupName: groupName,
                            userName: userName,
                          )));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
              showSnackBar(context, Colors.red, "Left successfully");
            });
          }
        },
        child: isJoined == true
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.green[400],
                    border: Border.all(color: Colors.white, width: 1.w)),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Theme.of(context).primaryColor),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: Text(
                  "Join Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }
}
