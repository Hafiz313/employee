import 'package:employee/consts/colors.dart';
import 'package:employee/core/viewmodels/controller/quiz_result_controller.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:employee/views/auth/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';

import '../../../consts/assets.dart';
import '../../../consts/lang.dart';
import '../../../networking/api_provider.dart';
import '../../../utils/my_loader.dart';
import '../../auth/login/controller/login_controller.dart';
import '../../home/controller/genral_controller.dart';
import 'drawer_menu_item_svg.dart';
import 'drawer_menu_item.dart';
import 'drawer_menu_items.dart';

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        // DrawerMenuItemV1(
        //   icon: AppAssets.settingIcon,
        //   title: 'Setting',
        //   onTap: () {
        //     print('Setting tapped');
        //   },
        // ),

        DrawerMenuItem(
          icon: const Icon(
            FontAwesomeIcons.trash,
            size: 15,
            color: AppColors.redColor,
          ),
          title: 'Delete Account',
          onTap: () async {
            await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(Lang.deleteAccount),
                  content: const Text(Lang.deleteYourAccount),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.put(GenralController()).deleteAccount();
                      }, // Dismiss dialog
                      child: const Text(Lang.yes),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(true), // Confirm exit
                      child: const Text(Lang.no),
                    ),
                  ],
                );
              },
            );
          },
        ),
        DrawerMenuItem(
          icon: Image.asset(AppAssets.logoutIcon),
          title: 'Log Out',
          onTap: () {
            var controller = Get.put(LoginController());
            controller.logout();
          },
        ),
        SizedBox(
          height: context.percentWidth * 7,
        ),
      ],
    );
  }
}
