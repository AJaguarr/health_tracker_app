import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/Storage/storage_class.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/auth/notifiers/add_conditions_notifier.dart';
import 'package:itoju_mobile/features/auth/notifiers/get_conditions_notifier.dart';
import 'package:itoju_mobile/features/auth/notifiers/profile_notifier.dart';
import 'package:itoju_mobile/features/landing/landing_page.dart';
import 'package:itoju_mobile/features/widgets/app_loader.dart';
import 'package:itoju_mobile/features/widgets/back_button.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/features/widgets/custom_button.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/error_con.dart';
import 'package:itoju_mobile/features/widgets/margins.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';
import 'package:itoju_mobile/services/flush_bar_service.dart';

class AddConditions extends ConsumerStatefulWidget {
  const AddConditions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddConditionsState();
}

class _AddConditionsState extends ConsumerState<AddConditions> {
  Set<int> conditionsList = {};
  Set<int> deleteList = {};

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.watch(getConditionsProvider.notifier).getConditions();
      await ref.watch(getConditionsProvider.notifier).getUserConditions();
      final userConditions =
          ref.read(getConditionsProvider).userConditionsLists;
      for (GetConditionsModel condition in userConditions!) {
        conditionsList.add(condition.id!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(getConditionsProvider);
    return Scaffold(
      appBar: AppBar(
        leading: CustomBackButton(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: AppColors.splash_underlay,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "Welcome ${ref.watch(profileProvider).userModel!.firstName}",
                        fontSize: 16.sp,
                        color: AppColors.primaryColorPurple,
                        fontWeight: FontWeight.w700,
                      ),
                      10.pw,
                      CustomText(
                        "👋",
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                      )
                    ],
                  ),
                  verticalSpaceSmall,
                  CustomText(
                    "Have you been diagnosed with any condition?",
                    fontSize: 12.sp,
                    color: AppColors.hintGrey,
                  ),
                ],
              ),
            ),
            20.ph,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    state.status == Loader.loading
                        ? AppLoader()
                        : state.status == Loader.error
                            ? ErrorCon(
                                func: () {
                                  SchedulerBinding.instance
                                      .addPostFrameCallback((timeStamp) async {
                                    await ref
                                        .watch(getConditionsProvider.notifier)
                                        .getConditions();
                                    await ref
                                        .watch(getConditionsProvider.notifier)
                                        .getUserConditions();
                                    final userConditions = ref
                                        .read(getConditionsProvider)
                                        .userConditionsLists;
                                    for (GetConditionsModel condition
                                        in userConditions!) {
                                      conditionsList.add(condition.id!);
                                    }
                                  });
                                },
                              )
                            : Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: List.generate(
                                    state.conditionsLists!.length, (index) {
                                  final condition =
                                      state.conditionsLists![index];
                                  return ActionChip(
                                    label: Text(condition.name!),
                                    labelStyle: TextStyle(
                                        color: conditionsList
                                                .contains(condition.id!)
                                            ? Colors.white
                                            : Colors.black),
                                    backgroundColor:
                                        conditionsList.contains(condition.id!)
                                            ? AppColors.primaryColorPurple
                                                .withOpacity(.85)
                                            : null,
                                    onPressed: () {
                                      setState(() {
                                        if (conditionsList
                                            .contains(condition.id!)) {
                                          conditionsList.remove(condition.id!);
                                          deleteList.add(condition.id!);
                                          return;
                                        }
                                        conditionsList.add(condition.id!);
                                        deleteList.remove(condition.id!);
                                      });
                                    },
                                  );
                                }),
                              ),
                    60.ph,
                    CurvedButton(
                      text: "Save",
                      loading: ref.watch(addConditionsProvider).loadStatus ==
                          Loader.loading,
                      onPressed: () async {
                        if (conditionsList.isEmpty) {
                          getAlert('You haven\'t chosen any selection!');
                          return;
                        }
                        final response = await ref
                            .read(addConditionsProvider.notifier)
                            .addConditions(
                                conditionsList.toList(), deleteList.toList());
                        if (response.successMessage.isNotEmpty) {
                          if (!mounted) return;
                          bool setMetrics =
                              HiveStorage.get(HiveKeys.setMetrics) ?? false;
                          if (!setMetrics)
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LandingPage();
                                },
                              ),
                              (route) => false,
                            );
                          await HiveStorage.put(HiveKeys.setMetrics, true);
                          getAlert(response.successMessage, isWarning: false);
                        } else if (response.responseMessage!.isNotEmpty) {
                          getAlert(response.responseMessage!);
                        } else {
                          getAlert(response.errorMessage);
                        }
                      },
                    ),
                    80.ph,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OptionsButton extends StatefulWidget {
  final String? option;
  final int? selectedIndex;
  final bool? userSelected;
  // final VoidCallback? onTap;
  const OptionsButton({
    Key? key,
    this.option,
    this.selectedIndex,
    this.userSelected,
    //  this.onTap,
  }) : super(key: key);

  @override
  _OptionsButtonState createState() => _OptionsButtonState();
}

class _OptionsButtonState extends State<OptionsButton> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
        // widget.onTap!();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height(45),
          width: width(214),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryColorPurple
                  : AppColors.borderGrey,
            ),
            color:
                isSelected ? AppColors.primaryColorPurple : Colors.transparent,
          ),
          child: Center(
            child: CustomText(
              widget.option,
              fontSize: 12,
              color: isSelected ? Colors.white : AppColors.primaryColorPurple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
