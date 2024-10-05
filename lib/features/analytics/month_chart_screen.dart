import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/analytics/charts/month_charts/bowel_month_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/month_charts/food_month_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/month_charts/syms_month_chart.dart';
import 'package:itoju_mobile/features/analytics/widgets/yellow_warning.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';

class MonthAnalyticChart extends ConsumerStatefulWidget {
  const MonthAnalyticChart({
    super.key,
  });

  @override
  ConsumerState<MonthAnalyticChart> createState() => _DaysAnalyticChartState();
}

class _DaysAnalyticChartState extends ConsumerState<MonthAnalyticChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YellowWarning(
            text: 'Please scroll sideways to view all data in each chart',
          ),
          15.ph,
          CustomText(
            'Symptoms',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          10.ph,
          SymptomsMonthChart(),
          20.ph,
          CustomText(
            'Food Diary',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          FoodMonthChart(),
          20.ph,
          CustomText(
            'Bowel Movement',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          BowelMonthChart(),
          50.ph
        ],
      ),
    );
  }
}
