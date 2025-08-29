import 'package:employee/consts/lang.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/overTime/overtime_request_view.dart';
import 'package:employee/views/auth/sing_up/signup_view.dart';
import 'package:employee/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../consts/assets.dart';
import '../consts/colors.dart';
import 'base_view/base_scaffold.dart';
import 'base_view/base_scaffold_auth.dart';
import 'widget/buttons.dart';
import 'widget/text.dart';
import 'widget/text_fields.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});
  static const String routeName = '/NotificationView';
  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;
    return BaseScaffold(
      backgroundColor: AppColors.homeBG,
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: context.percentHeight * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: context.percentHeight * 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  headline5(Lang.notification.toUpperCase()),
                ],
              ),
              SizedBox(
                height: context.percentHeight * 1,
              ),
              Container(
                height: 1,
                color: AppColors.textColor,
              ),
              SizedBox(
                height: context.percentHeight * 1,
              ),
              notificationList(context),
            ],
          )),
    );
  }

  Widget notificationList(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return notificationListItems(context);
          }),
    );
  }

  Widget notificationListItems(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OvertimeRequestView.routeName);
        // _showDynamicDialog(
        //   context,
        //   title: 'Your leave request has been Approved',
        //   message: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
        //   buttonText: 'OK',
        // );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: context.percentWidth * 2,
            vertical: context.percentHeight * 1),
        margin: EdgeInsets.only(bottom: context.percentHeight * 1),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor, width: 1),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: context.percentHeight * 5,
                  width: context.percentWidth * 10,
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage(AppAssets.profile)),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 1)),
                ),
                SizedBox(
                  width: context.percentWidth * 1,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subText4(Lang.welcome,
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.bold),
                    subText5("02:12 PM | Sep 12, 2024"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDynamicDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String buttonText,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, OvertimeRequestView.routeName);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(color: AppColors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
