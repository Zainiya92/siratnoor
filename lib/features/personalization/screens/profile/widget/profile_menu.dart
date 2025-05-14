import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.ontap,
    required this.title,
    required this.value,
    this.icon,
    this.child, // Added child parameter
  });

  final VoidCallback ontap;
  final String title, value;
  final IconData? icon;
  final Widget? child; // Child widget for customization

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: TSizes.spaceBtwItem / 1.5),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child:
                  child ?? // Display child if provided, otherwise display the value as text
                      Text(
                        value,
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
            ),
            if (icon != null) // Only show the icon if it's not null
              Expanded(
                child: Icon(
                  icon,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
