import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';

class TRoundedContainer extends StatelessWidget {
  const TRoundedContainer({
    super.key,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.child,
    this.showBoder =false,
    this.radius = TSizes.cardRadiusLg,
    this.backgroundcolor = TColors.white,
    this.bodercolor = TColors.borderPrimary,
  });
  final double? width, height;
  final double radius;
  final Widget? child;
  final bool showBoder;
  final Color backgroundcolor, bodercolor;
  final EdgeInsetsGeometry? margin, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundcolor,
        borderRadius: BorderRadius.circular(radius),
        border: showBoder ? Border.all(color: bodercolor) : null,
      ),
      child: child,
    );
  }
}
