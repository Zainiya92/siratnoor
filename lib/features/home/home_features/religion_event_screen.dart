import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sirat_noor/utils/constants/colors.dart';
import '../../personalization/controllers/user_controller.dart';

class ReligiousEventsScreen extends StatelessWidget {
  const ReligiousEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final String userReligion = controller.user.value.religion;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Religious Events',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: TColors.white),
        ),
        backgroundColor: TColors.primary,
        iconTheme: const IconThemeData(color: TColors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Events')
            .where('religion', isEqualTo: userReligion)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: _getReligionIcon(userReligion),
                  title: Text(
                    event['title'],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    event['description'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: const Icon(Iconsax.arrow_right_3),
                  onTap: () {
                    _showEventDetails(
                        context, event['title'], event['description']);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Show Event Full Detail Popup
  void _showEventDetails(
      BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  /// Return Different Icon Based on Religion
  Widget _getReligionIcon(String religion) {
    switch (religion) {
      case 'Sunni':
        return const Icon(Iconsax.moon, color: TColors.grey, size: 32);
      case 'Shia':
        return const Icon(Iconsax.flag, color: Colors.red, size: 32);
      case 'Wahhabi':
        return const Icon(Iconsax.book, color: Colors.green, size: 32);
      default:
        return const Icon(Iconsax.book, color: TColors.primary, size: 32);
    }
  }
}
