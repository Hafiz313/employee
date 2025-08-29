import 'package:employee/consts/colors.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/auth/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DrawerMenuItemSvg extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const DrawerMenuItemSvg({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding:
                EdgeInsets.symmetric(vertical: context.percentHeight * 0.7),
            child: Row(
              children: [
                SizedBox(
                  width: context.percentWidth * 3,
                ),
                SizedBox(height: 20, width: 20, child: SvgPicture.asset(icon)),
                SizedBox(
                  width: context.percentWidth * 2,
                ),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.blackColor)),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.borderColor,
          )
        ],
      ),
    );
  }
}
