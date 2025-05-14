import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sirat_noor/features/splash_screen.dart';
import 'package:sirat_noor/utils/theme/theme.dart';

import 'bindings/general_bindings.dart';
import 'utils/constants/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(
          child: SplashScreen()
        ),
      ),
    );
  }
}
