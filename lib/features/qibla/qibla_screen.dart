import 'package:flutter/material.dart';

import '../../common_widget/common_app_bar.dart';
import 'widget/compus.dart';

class QiblaDirectionScreen extends StatelessWidget {
  const QiblaDirectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: QiblahCompass(),
    );
  }
}
