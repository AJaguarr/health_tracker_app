import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/features/auth/notifiers/signup_notifier.dart';
import 'package:itoju_mobile/features/auth/pages/signUp_Page.dart.dart';
import 'package:itoju_mobile/features/auth/pages/login.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/features/widgets/date_pick_widget.dart';
import 'package:itoju_mobile/features/widgets/dates.dart';
import 'package:itoju_mobile/features/widgets/margins.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';
import 'package:itoju_mobile/services/flush_bar_service.dart';
import 'package:itoju_mobile/features/widgets/custom_button.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/custom_text_field.dart';
import 'package:itoju_mobile/features/widgets/dialog.dart';
import 'package:itoju_mobile/features/widgets/my_checkBox.dart';

enum Oauth { Google, faceBook, apple }

class OauthSignUpPage extends StatefulWidget {
  const OauthSignUpPage({Key? key, required this.auth}) : super(key: key);
  final Oauth auth;
  @override
  _OauthSignUpPageState createState() => _OauthSignUpPageState();
}

class _OauthSignUpPageState extends State<OauthSignUpPage> {
  GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  bool terms = false;
  bool privacy = false;
  bool research = false;
  DateTime? dob;
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.ph,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.ph,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "Create your account",
                      color: AppColors.primaryColorPurple,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    verticalSpaceSmall,
                    CustomText(
                      "Join us by Signing Up using",
                      color: AppColors.hintGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ],
            ),
            25.ph,
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        filled: true,
                        title: "First Name",
                        hintText: "Yourname",
                        controller: firstNameController,
                        valdator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                      verticalSpaceTiny,
                      CustomTextField(
                        filled: true,
                        title: "Last Name",
                        hintText: "Surname",
                        controller: lastNameController,
                        valdator: (value) {
                          if (value!.isEmpty) {
                            return "Field cannot be empty";
                          }
                          return null;
                        },
                      ),
                      verticalSpaceTiny,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(
                            "Date of Birth",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColorPurple,
                          ),
                          10.ph,
                          DatePickWidget(
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                setState(() {});
                                if (value != null) {
                                  dob = value;
                                }
                              });
                            },
                            title: dob != null
                                ? DateFormatter.format(dob.toString())
                                : "Enter date",
                          ),
                        ],
                      ),
                      20.ph,
                      MyCeckBox(
                        term: "I agree to the ",
                        linkText: "Terms and Conditions",
                        onTap: () {
                          termsDialog(
                            context,
                          );
                        },
                        onChanged: (bool? value) {
                          setState(() {
                            terms = value!;
                          });
                        },
                        isChecked: terms,
                      ),
                      MyCeckBox(
                        term: "I agree to the",
                        linkText: " Privacy policy",
                        onTap: () {
                          termsDialog(
                            context,
                          );
                        },
                        onChanged: (bool? value) {
                          setState(() {
                            privacy = value!;
                          });
                        },
                        isChecked: privacy,
                      ),
                      SpecialCustomCheckBox(
                        firstTerm: "while\n",
                        firstlinkText: " Research Purposes ",
                        secondTerm: "understanding my rights and ",
                        secondLinkText: "How My Data Is Being Used",
                        firstLink: () {
                          termsDialog(
                            context,
                          );
                        },
                        lastLink: () {
                          termsDialog(
                            context,
                          );
                        },
                        onChanged: (bool? value) {
                          setState(() {
                            research = value!;
                          });
                        },
                        isChecked: research,
                      ),
                      verticalSpaceMedium,
                      Consumer(builder: (context, ref, child) {
                        final state = ref.watch(registerProvider);
                        return CurvedButton(
                          color: (!terms || !privacy)
                              ? Colors.grey
                              : AppColors.primaryColorPurple,
                          icon: Row(
                            children: [
                              widget.auth == Oauth.Google
                                  ? GoogleContainer()
                                  : widget.auth == Oauth.faceBook
                                      ? FaceBookContainer()
                                      : AppleContainer(),
                              10.pw
                            ],
                          ),
                          loading: state.loadStatus == Loader.loading,
                          text: 'Continue to ' +
                              (widget.auth == Oauth.Google
                                  ? 'Google'
                                  : widget.auth == Oauth.faceBook
                                      ? 'FaceBook'
                                      : 'Apple'),
                          onPressed: () async {
                            if (!terms || !privacy) {
                              return;
                            }
                            if (lastNameController.text.isEmpty ||
                                firstNameController.text.isEmpty ||
                                dob == null) {
                              getAlert('All fields are required');

                              return;
                            }
                            final response = widget.auth == Oauth.Google
                                ? await ref
                                    .read(registerProvider.notifier)
                                    .registerUpWithGoogle(
                                      firstNameController.text,
                                      lastNameController.text,
                                      dob!,
                                    )
                                : widget.auth == Oauth.faceBook
                                    ? await ref
                                        .read(registerProvider.notifier)
                                        .registerUpWithFB(
                                          firstNameController.text,
                                          lastNameController.text,
                                          dob!,
                                        )
                                    : await ref
                                        .read(registerProvider.notifier)
                                        .registerUpWithApple(
                                          firstNameController.text,
                                          lastNameController.text,
                                          dob!,
                                        );

                            if (response.successMessage.isNotEmpty) {
                              if (!mounted) return;
                              getAlert(response.successMessage,
                                  isWarning: false);

                              Timer(const Duration(seconds: 1), () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return SignUpSuccess(
                                      () {
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return SignInPage();
                                            },
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      name: response.data,
                                    );
                                  },
                                );
                              });
                            } else if (response.responseMessage!.isNotEmpty) {
                              getAlert(response.responseMessage!);
                            } else {
                              getAlert(response.errorMessage);
                            }
                          },
                        );
                      }),
                      verticalSpaceSmall,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            "Already have an account? ",
                            fontSize: 12.h,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primaryColorPurple,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                                (route) => false,
                              );
                            },
                            child: CustomText(
                              " Log In",
                              fontSize: 13.h,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColorPurple,
                            ),
                          ),
                        ],
                      ),
                      100.ph
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  termsDialog(BuildContext context) {
    return customDialog(context, const Terms());
  }
}

class AppleContainer extends StatelessWidget {
  const AppleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.black),
      child: Center(
        child: Icon(
          Icons.apple,
          color: Colors.white,
          size: 20.r,
        ),
      ),
    );
  }
}

class GoogleContainer extends StatelessWidget {
  const GoogleContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Image.asset(
        "asset/png/Google.png",
        height: 30.h,
        width: 20.w,
      ),
    );
  }
}

class FaceBookContainer extends StatelessWidget {
  const FaceBookContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 40.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r), color: Colors.white),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.r),
        child: Image.asset(
          "asset/png/Facebook.png",
          height: 30.h,
          width: 20.w,
        ),
      ),
    );
  }
}
