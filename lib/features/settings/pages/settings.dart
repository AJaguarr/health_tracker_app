import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/Storage/storage_class.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/auth/pages/add_conditions.dart';
import 'package:itoju_mobile/features/auth/pages/add_tracked_metrics.dart';
import 'package:itoju_mobile/features/auth/pages/change_password.dart';
import 'package:itoju_mobile/features/settings/pages/set_body_data.dart';
import 'package:itoju_mobile/features/settings/pages/set_menses.dart';
import 'package:itoju_mobile/features/settings/widgets/settings_tile.dart';
import 'package:itoju_mobile/features/widgets/back_button.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool switchValueAuth = false;
  bool switchValueFingerPrint =
      HiveStorage.get(HiveKeys.showBiometrics) ?? false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: CustomBackButton(), actions: [
        InkWell(
          onTap: () {
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              border:
                  Border.all(width: .5.w, color: AppColors.primaryColorPurple),
              borderRadius: BorderRadius.circular(5.r),
            ),
            margin: EdgeInsets.only(right: 10.w),
            child: Icon(
              Icons.logout_rounded,
              size: 20.r,
            ),
          ),
        )
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 120.w,
                  height: 60.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppColors.splash_underlay,
                  ),
                  child: Center(
                    child: CustomText(
                      'Settings',
                      color: AppColors.primaryColorPurple,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
              5.ph,
              SettingsTile(
                  image: 'blood',
                  text: 'Menstruation',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SetMenses();
                      },
                    ));
                  }),
              SettingsTile(
                  image: 'body',
                  text: 'Body Measurements',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return SetBodyData();
                      },
                    ));
                  }),
              SettingsTile(
                  image: 'medical',
                  text: 'Diagnosed Conditions',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AddConditions();
                      },
                    ));
                  }),
              SettingsTile(
                  image: 'tracks',
                  text: 'Tracking',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return AddTrackedMetrics();
                      },
                    ));
                  }),
              // SettingsTile(
              //     image: 'medical',
              //     text: 'Diagnosed Conditions',
              //     onTap: () {
              //       Navigator.push(context, MaterialPageRoute(
              //         builder: (context) {
              //           return AddDiagnosis();
              //         },
              //       ));
              //     }),
              SettingsTile(
                  image: 'padlock',
                  text: 'Change Password',
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChangePassword();
                      },
                    ));
                  }),
              Row(
                children: [
                  Text(
                    'Enable Biometrics',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColorPurple),
                  ),
                  Spacer(),
                  Switch.adaptive(
                      inactiveTrackColor: Colors.grey.withOpacity(.5),
                      activeColor: AppColors.primaryColorPurple,
                      value: switchValueFingerPrint,
                      onChanged: (e) async {
                        switchValueFingerPrint = !switchValueFingerPrint;
                        await HiveStorage.put(
                            HiveKeys.showBiometrics, switchValueFingerPrint);
                        setState(() {});
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
