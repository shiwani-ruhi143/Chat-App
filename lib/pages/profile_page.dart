import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/widgets.dart';
import 'auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({super.key, required this.userName, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27.sp),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.h),
          children: [
            Icon(Icons.account_circle,
                size: 150.h, color: Theme.of(context).primaryColor),
            SizedBox(
              height: 15.h,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.sp),
            ),
            SizedBox(
              height: 30.h,
            ),
            Divider(
              height: 2.h,
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(context, HomePage());
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              leading: Icon(Icons.group),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              leading: Icon(Icons.group),
              title: Text(
                "Profile Page",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Logout"),
                        content: Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await authService.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                    (route) => false);
                                // .whenComplete(() =>
                                //     nextScreenReplace(context, LoginPage()));
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
                // await authService.signOut().whenComplete(
                //     () => nextScreenReplace(context, LoginPage()));
              },
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              leading: Icon(Icons.exit_to_app),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 200.r,
              color:Theme.of(context).primaryColor
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Full Name",
                  style: TextStyle(fontSize: 17.sp),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(fontSize: 17.sp, color: Colors.grey),
                ),
              ],
            ),
            Divider(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 17.sp,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(fontSize: 17.sp, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
