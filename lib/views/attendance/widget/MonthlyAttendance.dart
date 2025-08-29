import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:get/get.dart';

import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/my_loader.dart';
import '../../widget/text.dart';
import '../controller/attendancae_controller.dart';

class MonthlyAttendance extends StatefulWidget {
  const MonthlyAttendance({super.key});

  @override
  _MonthlyAttendanceState createState() => _MonthlyAttendanceState();
}

class _MonthlyAttendanceState extends State<MonthlyAttendance> {
  final AttendanceController attendanceController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => attendanceController.isListLoading.value
        ? const MyLoader()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCard(
                context,
                double.parse(attendanceController.attendance.value),
                AppColors.primary,
                Lang.attendance,
              ),
              _buildCard(
                context,
                double.parse(attendanceController.punctuality.value),
                AppColors.green,
                Lang.punchtuality,
              ),
            ],
          ));
  }

  Widget _buildCard(
      BuildContext context, double value, Color color, String label) {
    return Card(
      elevation: 5,
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        child: CircularPercentIndicator(
          radius: 65.0,
          lineWidth: 15.0,
          animation: true,
          percent: value.clamp(
              0.0, 1.0), // Ensures the value is within the valid range
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${(value * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: AppColors.primary,
                ),
              ),
              subText3(label, fontWeight: FontWeight.bold),
            ],
          ),
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: color,
        ),
      ),
    );
  }
}
