import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/widgets/app_logo_widget.dart';
import 'package:jooblie_app/widgets/gradient_style_text_widget.dart';

import '../core/sized.dart';
import '../views/onboarding/onboarding_view.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? action;
  final bool centerTitle;
  final bool showLeadingIcon;
  final Color backGroundColor;
  final Color leadingIconColor;
  final Color textColor;
  final PreferredSizeWidget? bottom;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool showAppLogo;

  const AppBarWidget({
    super.key,
    required this.title,
    this.action,
    this.centerTitle = false,
    this.showLeadingIcon = true,
    this.backGroundColor = Colors.transparent,
    this.leadingIconColor = Colors.black,

    this.textColor = Colors.black,
    this.bottom,
    this.systemOverlayStyle,
    this.showAppLogo = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      scrolledUnderElevation: 0.0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: isDark ? Color(0xff20293C) : Colors.grey.shade300,
          height: 0.5,
        ),
      ),
      automaticallyImplyLeading: false,
      systemOverlayStyle: systemOverlayStyle,
      leading: showLeadingIcon
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_sharp,
                color: isDark ? Colors.white : Colors.black87,
              ),
              // color: AppColors.primary,
            )
          : null,
      backgroundColor: backGroundColor,
      // backgroundColor: isDark
      //     ? AppColors.darkBackground
      //     : AppColors.lightBackground,
      centerTitle: centerTitle,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkGradientBackground
              : AppColors.lightGradientBackground,
        ),
      ),
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      title: Row(
        children: [
          showAppLogo ? AppLogo() : SizedBox.shrink(),
          10.w,
          GradientStyleTextWidget(title: title, fontSize: 20),
          // Text(
          //   title,
          //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //     color: isDark ? Colors.white : Colors.black,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
        ],
      ),
      actions: action,
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 60);
}
