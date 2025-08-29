import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:get/get.dart';

import '../../../consts/colors.dart';
import '../../../consts/lang.dart';
import '../../../utils/my_loader.dart';
import '../../widget/text.dart';
import '../controller/attendancae_controller.dart';

class WeeklyList extends StatefulWidget {
  const WeeklyList({super.key});

  @override
  _WeeklyListState createState() => _WeeklyListState();
}

class _WeeklyListState extends State<WeeklyList> {
  final AttendanceController attendanceController = Get.find();

  @override
  void initState() {
    // TODO: implement initState

    debugPrint("======dddd========");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => attendanceController.isListLoading.value
        ? const MyLoader()
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: CircularPercentIndicator(
                    radius: 65.0,
                    lineWidth: 15.0,
                    animation: true,
                    percent:
                        double.parse(attendanceController.attendance.value),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(double.parse(attendanceController.attendance.value) * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: AppColors.primary),
                        ),
                        subText3(Lang.attendance, fontWeight: FontWeight.bold)
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.primary,
                  ),
                ),
              ),
              Card(
                elevation: 5,
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                  child: CircularPercentIndicator(
                    radius: 65.0,
                    lineWidth: 15.0,
                    animation: true,
                    percent:
                        double.parse(attendanceController.punctuality.value),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${(double.parse(attendanceController.punctuality.value) * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: AppColors.primary),
                        ),
                        subText3(Lang.punchtuality, fontWeight: FontWeight.bold)
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.green,
                  ),
                ),
              ),
            ],
          ));
  }
}
