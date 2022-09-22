import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/auth/login_page.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isLoading = false;
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return SafeArea(
      child: Scaffold(
          body: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.h, vertical: 20.w),
                    child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Groupie",
                              style: TextStyle(
                                  fontSize: 40.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Create your account now to chat and explore",
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Image.asset(
                              'assets/images/welcome_screen.png',
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Full Name',
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onChanged: ((value) {
                                  setState(() {
                                    fullName = value;
                                    // print(email);
                                  });
                                }),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Email',
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Theme.of(context).primaryColor,
                                  )),
                              onChanged: ((value) {
                                setState(() {
                                  email = value;
                                  // print(email);
                                });
                              }),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required';
                                }

                                // using regular expression
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Please enter a valid email";
                                }

                                // the email is valid
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            TextFormField(
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                    labelText: 'Password',
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onChanged: ((value) {
                                  setState(() {
                                    password = value;
                                  });
                                }),
                                validator: ((value) {
                                  if (value!.length < 6) {
                                    return "Password must be at least 6 characters";
                                  } else {
                                    return null;
                                  }
                                })),
                            SizedBox(
                              height: 20.h,
                            ),
                            SizedBox(
                              // height: 20.h,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.r))),
                                  onPressed: register,
                                  child: Text(
                                    "Register",
                                    style: TextStyle(fontSize: 16.sp),
                                  )),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text.rich(
                              TextSpan(
                                  text: "Already have an account?",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Login Here",
                                        style: TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreenReplace(
                                                context, LoginPage());
                                          })
                                  ]),
                            ),
                          ],
                        )),
                  ),
                )),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserEmailSF(email);
          await HelperFunction.saveUserNameSF(fullName);
          nextScreenReplace(context, HomePage());
        } else {
          showSnackBar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
