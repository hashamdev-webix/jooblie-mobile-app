import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:jooblie_app/core/app_colors.dart';
import 'package:jooblie_app/core/utils/routes_name.dart';

class HeaderAppBarWidget extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;
  final String blackTitle;
  final String blueTitle;
  final bool showSetting;
  final bool showLeadingIcon;
  const HeaderAppBarWidget({
    super.key,
    required this.theme,
    required this.isDark,  this.blackTitle="Job",  this.blueTitle="lie",  this.showSetting=true,
    this.showLeadingIcon=false
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: FadeInDown(
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment:showSetting ?  MainAxisAlignment.spaceBetween:MainAxisAlignment.start,
          children: [

            if (showLeadingIcon)
              IconButton(
                onPressed: () =>Navigator.pop(context),
                icon: Icon(
                  Platform.isAndroid
                      ? Icons.arrow_back
                      : Icons.arrow_back_ios,
                ),
              ),
            RichText(
              text: TextSpan(

                children: [
                  TextSpan(
                    text: blackTitle,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  TextSpan(
                    text:blueTitle,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightPrimary,
                    ),
                  ),
                ],
              ),
            ),

            showSetting ?   IconButton(onPressed: (){
              Navigator.pushNamed(context, RoutesName.settings);
            }, icon: Icon(Icons.settings_outlined)):SizedBox.shrink()

          ],
        ),
      ),
    );
  }
}
