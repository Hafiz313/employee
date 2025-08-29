import 'package:employee/consts/assets.dart';
import 'package:employee/utils/localStorage/storage_service.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../consts/colors.dart';
import '../../../utils/localStorage/storage_consts.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          margin: EdgeInsets.only(
            top: context.percentHeight * 5,
            bottom: context.percentHeight * 3,
          ),
          // child: Container(
          //     height: context.percentHeight * 5,
          //     child: Image.asset(AppAssets.logoBlue))
        ),
        Container(
          height: 1,
          color: AppColors.textColor,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: context.percentHeight * 2,
          ),
          padding: EdgeInsets.symmetric(horizontal: context.percentWidth * 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: AppColors.primary,
                child: Icon(
                  FontAwesomeIcons.user,
                  color: AppColors.white,
                ),
                // child: Image.asset(AppAssets.profile),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    '${StorageService().getData(StorageConsts.kName).toString()} ${StorageService().getData(StorageConsts.kUserSurName).toString()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  // const Text(
                  //   'HEAD OF DESIGN',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: AppColors.blackColor,
                  //   ),
                  // ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
