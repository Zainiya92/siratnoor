import 'package:flutter/material.dart';
import 'package:sirat_noor/utils/constants/colors.dart';

class TashbihCounterScreen extends StatefulWidget {
  const TashbihCounterScreen({super.key});

  @override
  _TashbihCounterScreenState createState() => _TashbihCounterScreenState();
}

class _TashbihCounterScreenState extends State<TashbihCounterScreen> {
  int counter = 0;
  int limit = 33;
  String recitation = 'SubhanAllah';

  void incrementCounter() {
    if (counter < limit) {
      setState(() {
        counter++;
      });
    } else {
      _showLimitReachedDialog();
    }
  }

  void resetCounter() {
    setState(() {
      counter = 0;
    });
  }

  void _showLimitReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limit Reached"),
        content: Text("You have reached the limit of $limit."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    TextEditingController limitController =
        TextEditingController(text: limit.toString());
    TextEditingController recitationController =
        TextEditingController(text: recitation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: recitationController,
              decoration: const InputDecoration(labelText: "Tashbih Text"),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: limitController,
              decoration: const InputDecoration(labelText: "Counter Limit"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                recitation = recitationController.text;
                limit = int.tryParse(limitController.text) ?? 33;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tashbih Counter",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/Mosque.png'),
            const SizedBox(height: 40),
            Text(
              recitation,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: TColors.golden),
            ),
            const SizedBox(height: 40),
            // Custom Islamic Tasbih Counter
            CustomPaint(
              size: const Size(200, 300),
              painter: TasbihCounterPainter(),
              child: Container(
                width: 200,
                height: 300,
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 60,
                      child: Row(
                        children: [
                          Text(
                            "$counter",
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: TColors.primary,
                            ),
                          ),
                          Text(
                            " /$limit",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 140,
                      right: 20,
                      child: GestureDetector(
                        onTap: _showSettingsDialog,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: TColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.settings,
                              size: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 45,
                      child: GestureDetector(
                        onTap: incrementCounter,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: TColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.touch_app_rounded,
                              size: 32, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 140,
                      left: 20,
                      child: GestureDetector(
                        onTap: resetCounter,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: TColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.refresh,
                              size: 24, color: Colors.white),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   "Limit: $limit",
                    //   style:
                    //       const TextStyle(fontSize: 16, color: TColors.primary),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Islamic Tasbih Shape
class TasbihCounterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = TColors.golden
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(size.width * 0.7, 0);
    path.quadraticBezierTo(0, size.height * 0.1, 0, size.height * 0.5);
    path.quadraticBezierTo(0, size.height * 0.8, size.width * 0.3, size.height);
    path.lineTo(size.width * 0.3, size.height);
    path.quadraticBezierTo(
        size.width, size.height * 0.9, size.width, size.height * 0.5);
    path.quadraticBezierTo(size.width, size.height * 0.2, size.width * 0.7, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
