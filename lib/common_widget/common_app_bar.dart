import 'package:flutter/material.dart';

import '../utils/constants/image_strings.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Implement PreferredSizeWidget
  const CommonAppBar({
    super.key,
    this.height = 200,
  });
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: height,
      flexibleSpace: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Glow.png',
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              'assets/images/Glow.png',
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              TImages.blacklogo,
              height: 150,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(200);
}
