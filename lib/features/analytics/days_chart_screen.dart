import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:itoju_mobile/core/colors/colors.dart';
import 'package:itoju_mobile/features/analytics/charts/7days_chart/bowel_7_days_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/7days_chart/food_7_days_chart.dart';
import 'package:itoju_mobile/features/analytics/charts/7days_chart/syms_7_days_chart.dart';
import 'package:itoju_mobile/features/widgets/custom_text.dart';
import 'package:itoju_mobile/features/widgets/utills.dart';

class DaysAnalyticChart extends ConsumerStatefulWidget {
  const DaysAnalyticChart({
    super.key,
  });

  @override
  ConsumerState<DaysAnalyticChart> createState() => _DaysAnalyticChartState();
}

class _DaysAnalyticChartState extends ConsumerState<DaysAnalyticChart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Symptoms7DaysChart(),
          20.ph,
          CustomText(
            'Food Diary',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          Food7DaysChart(),
          20.ph,
          CustomText(
            'Bowel Movement',
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColorPurple,
          ),
          20.ph,
          Bowel7DaysChart(),
          50.ph
        ],
      ),
    );
  }
}
