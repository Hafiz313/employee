import 'package:employee/consts/lang.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/leave/leave_a_request_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../consts/colors.dart';
import '../../consts/assets.dart';
import '../../consts/fonts.dart';
import '../base_view/base_scaffold.dart';
import '../widget/buttons.dart';
import '../widget/text.dart';

class CourseVideoView extends StatelessWidget {
  const CourseVideoView({super.key});
  static const String routeName = '/CourseVideoView';

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: context.percentHeight * 1),
        child: SingleChildScrollView(
          child: Column(
            children: [
              video(context),
              list(context),
              btn(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget video(BuildContext context) {
    return Container(
      height: context.percentHeight * 20,
      width: context.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: const DecorationImage(image: AssetImage(AppAssets.videoDemo)),
      ),
    );
  }

  Widget btn(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.percentHeight * 1),
      child: AppElevatedButton(
          width: double.infinity,
          backgroundColor: AppColors.primary,
          onPressed: () {
            // Navigator.pushNamed(context,  LeaveARequestView.routeName);
          },
          title: Lang.resumeCourse),
    );
  }

  Widget listItem(BuildContext context, {required int index}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 1,
          vertical: context.percentHeight * 0.7),
      margin: EdgeInsets.only(top: context.percentHeight * 1),
      decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.borderColor)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            circleText(context, text: '${index + 1}'),
            SizedBox(
              width: context.percentWidth * 2,
            ),
            subText4("Lecture ${index + 1} - Introduction to HTML",
                fontWeight: FontWeight.bold),
          ],
        ),
        subText4("00:25 Hrs", fontWeight: FontWeight.bold),
      ]),
    );
  }

  Widget listItemSelect(BuildContext context, {required int index}) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: context.percentWidth * 1,
          vertical: context.percentHeight * 0.7),
      margin: EdgeInsets.only(top: context.percentHeight * 1),
      decoration: BoxDecoration(
          color: const Color(0xFFB2B9FF),
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.primary)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            circleText(
              context,
              text: '${index + 1}',
              colorCircle: AppColors.primary,
            ),
            SizedBox(
              width: context.percentWidth * 2,
            ),
            subText4("Lecture ${index + 1} - Introduction to HTML",
                color: AppColors.blackColor, fontWeight: FontWeight.bold),
          ],
        ),
        subText4("00:25 Hrs",
            color: AppColors.blackColor, fontWeight: FontWeight.bold),
      ]),
    );
  }

  Widget list(BuildContext context) {
    return SizedBox(
      height: 350,
      width: context.screenHeight,
      child: ListView.builder(
          itemCount: 9,
          itemBuilder: (context, index) {
            if (index < 2) {
              return listItem(context, index: index);
            } else {
              return listItemSelect(context, index: index);
            }
          }),
    );
  }

  Widget circleText(BuildContext context,
      {required String text, Color? colorCircle, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: colorCircle ?? const Color(0xFF8F8F8F),
          )),
      child: Container(
        decoration: BoxDecoration(
            color: colorCircle ?? const Color(0xFF8F8F8F),
            shape: BoxShape.circle),
        padding: const EdgeInsets.all(5),
        child: subText5(text, color: textColor ?? AppColors.white),
      ),
    );
  }
}
