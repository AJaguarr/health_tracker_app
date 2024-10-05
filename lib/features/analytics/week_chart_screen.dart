import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/colors/colors.dart';

import 'package:itoju_mobile/features/analytics/charts/week_charts/bowel_week_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/week_charts/food_week_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/week_charts/syms_week_chart.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';

class WeekAnalyticChart extends ConsumerStatefulWidget {
  const WeekAnalyticChart({
    super.key,
  });

  @override
  ConsumerState<WeekAnalyticChart> createState() => _WeekAnalyticChartState();
}

class _WeekAnalyticChartState extends ConsumerState<WeekAnalyticChart>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    print('llll');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Symptoms',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          10.ph,
          SymptomsWeekChart(),
          20.ph,
          CustomText(
            'Food Diary',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          FoodWeekChart(),
          20.ph,
          CustomText(
            'Bowel Movement',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          BowelWeekChart(),
          50.ph
        ],
      ),
    );
  }
}
