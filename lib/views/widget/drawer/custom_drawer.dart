import 'package:employee/consts/colors.dart';
import 'package:employee/utils/custom_dialog.dart';
import 'package:employee/utils/percentage_size_ext.dart';
import 'package:flutter/material.dart';
import '../../../consts/assets.dart';
import '../../../utils/localStorage/storage_consts.dart';
import '../../../utils/localStorage/storage_service.dart';
import 'drawer_header_widget.dart';
import 'drawer_menu_items.dart';
import 'drawer_footer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  }); //

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      child: Column(
        children: [
          const DrawerHeaderWidget(),
          Expanded(
            child: DrawerMenuItems(),
          ),
          const DrawerFooter(),
        ],
      ),
    );
  }
}
