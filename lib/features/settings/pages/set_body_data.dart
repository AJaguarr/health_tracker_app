import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/features/settings/notifier/body_data_notifier.dart';
import 'package:itoju_mobile/features/settings/widgets/sign_value_widget.dart';
import 'package:itoju_mobile/features/settings/widgets/sign_widget.dart';
import 'package:itoju_mobile/features/widgets/app_loader.dart';
import 'package:itoju_mobile/features/widgets/back_button.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/features/widgets/custom_button.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/error_con.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';
import 'package:itoju_mobile/services/flush_bar_service.dart';

class SetBodyData extends ConsumerStatefulWidget {
  const SetBodyData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetBodyDataState();
}

class _SetBodyDataState extends ConsumerState<SetBodyData> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(bodyDataProvider.notifier).getBodyData();
      heightCtrl.text =
          (ref.read(bodyDataProvider).bodyDataModel?.height ?? 0).toString();
      weightCtrl.text =
          (ref.read(bodyDataProvider).bodyDataModel?.weight ?? 0).toString();
    });
    super.initState();
  }

  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  @override
  void dispose() {
    heightCtrl.dispose();
    weightCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bodyDataProvider);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: state.getStatus == Loader.loading
              ? AppLoader()
              : state.getStatus == Loader.error
                  ? ErrorCon(
                      func: () {
                        SchedulerBinding.instance
                            .addPostFrameCallback((timeStamp) async {
                          await ref
                              .read(bodyDataProvider.notifier)
                              .getBodyData();
                          heightCtrl.text = (ref
                                      .read(bodyDataProvider)
                                      .bodyDataModel
                                      ?.height ??
                                  0)
                              .toString();
                          weightCtrl.text = (ref
                                      .read(bodyDataProvider)
                                      .bodyDataModel
                                      ?.weight ??
                                  0)
                              .toString();
                        });
                      },
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        30.ph,
                        CustomText(
                          'Weight (lb)',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffEEAF4B),
                        ),
                        15.ph,
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            width: 280.w,
                            height: 122.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Color(0xffF8F8FC),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SignWigdet(
                                  isAdd: false,
                                  onTap: () {
                                    setState(() {
                                      if ((int.tryParse(heightCtrl.text) ??
                                              0) ==
                                          0) {
                                        return;
                                      }
                                      heightCtrl.text =
                                          ((int.tryParse(heightCtrl.text) ??
                                                      0) -
                                                  1)
                                              .toString();
                                    });
                                  },
                                ),
                                SignValueWigdet(ctrl: heightCtrl),
                                SignWigdet(
                                  isAdd: true,
                                  onTap: () {
                                    setState(() {
                                      heightCtrl.text =
                                          ((int.tryParse(heightCtrl.text)!) + 1)
                                              .toString();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        50.ph,
                        CustomText(
                          'Height (inch)',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xffEEAF4B),
                        ),
                        15.ph,
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.h),
                            width: 280.w,
                            height: 122.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              color: Color(0xffF8F8FC),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SignWigdet(
                                  isAdd: false,
                                  onTap: () {
                                    setState(() {
                                      if ((int.tryParse(weightCtrl.text) ??
                                              0) ==
                                          0) {
                                        return;
                                      }
                                      weightCtrl.text =
                                          ((int.tryParse(weightCtrl.text)!) - 1)
                                              .toString();
                                    });
                                  },
                                ),
                                SignValueWigdet(ctrl: weightCtrl),
                                SignWigdet(
                                  isAdd: true,
                                  onTap: () {
                                    setState(() {
                                      weightCtrl.text =
                                          ((int.tryParse(weightCtrl.text)!) + 1)
                                              .toString();
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        30.ph,
                        CurvedButton(
                            text: 'Update',
                            loading: ref.watch(bodyDataProvider).postStatus ==
                                Loader.loading,
                            onPressed: () async {
                              if (int.tryParse(heightCtrl.text) == null ||
                                  int.tryParse(weightCtrl.text) == null) {
                                getAlert('Both field\'s must be integers');
                                return;
                              }
                              final response = await ref
                                  .read(bodyDataProvider.notifier)
                                  .updateBodyData(int.parse(heightCtrl.text),
                                      int.parse(weightCtrl.text));

                              if (response.successMessage.isNotEmpty) {
                                getAlert(response.successMessage,
                                    isWarning: false);
                              } else if (response.responseMessage!.isNotEmpty) {
                                getAlert(response.responseMessage!);
                              } else {
                                getAlert(response.errorMessage);
                              }
                            })
                      ],
                    ),
        ),
      ),
    );
  }
}
