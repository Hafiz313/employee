import 'package:employee/consts/colors.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/auth/splash_view.dart';
import 'package:flutter/material.dart';

class DrawerMenuItem extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;
  final bool enabled;

  const DrawerMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            padding:
                EdgeInsets.symmetric(vertical: context.percentHeight * 0.7),
            child: Row(
              children: [
                SizedBox(
                  width: context.percentWidth * 3,
                ),
                SizedBox(height: 20, width: 20, child: icon),
                SizedBox(
                  width: context.percentWidth * 3,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16, 
                    color: enabled ? AppColors.blackColor : AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1,
          color: AppColors.borderColor,
        )
      ],
    );
  }
}
