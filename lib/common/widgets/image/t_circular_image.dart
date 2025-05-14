import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_function.dart';


class TCircularimage extends StatelessWidget {
  const TCircularimage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetwork = false,
    this.overLayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
  });
  final BoxFit? fit;
  final String image;
  final bool isNetwork;
  final Color? overLayColor, backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (THelperFunctions.isDarkMode(context)
                ? TColors.black
                : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          child: isNetwork
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: fit,
                  color: overLayColor,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overLayColor,
                ),
        ),
      ),
    );
  }
}
