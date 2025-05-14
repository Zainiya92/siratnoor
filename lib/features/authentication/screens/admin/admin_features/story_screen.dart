import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

// Reusable confirmation dialog
Future<bool> showConfirmDialog(BuildContext context,
    {required String title, required String content}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Delete"),
            ),
          ],
        ),
      ) ??
      false;
}

class ManageStoriesScreen extends StatelessWidget {
  const ManageStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage SAW Stories"),
        iconTheme: IconThemeData(
          color: TColors.white,
        ),
      ),
      body: const CategoriesList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddCategoryDialog(context),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Category"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Category Name",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Enter category name"
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final name = nameController.text.trim();
                final description = descController.text.trim();

                await FirebaseFirestore.instance.collection('categories').add({
                  'title': name,
                  'description': description,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var categories = snapshot.data!.docs;

        // Optional: Sort by title alphabetically
        categories.sort((a, b) {
          return (a['title'] ?? '')
              .toString()
              .compareTo((b['title'] ?? '').toString());
        });

        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            var category = categories[index];
            return ListTile(
              title: Text(category['title'] ?? "No Category Name"),
              subtitle: category['description'] != null &&
                      category['description'].toString().isNotEmpty
                  ? Text(category['description'])
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _confirmDeleteCategory(context, category.id),
                  ),
                  const Icon(Icons.arrow_forward),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EventsList(
                      categoryId: category.id,
                      categoryName: category['title'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _confirmDeleteCategory(BuildContext context, String categoryId) async {
    bool confirmed = await showConfirmDialog(
      context,
      title: "Delete Category",
      content:
          "Are you sure you want to delete this category and all its events & stories?",
    );

    if (!confirmed) return;

    await _deleteCategoryWithNested(categoryId);
  }

  Future<void> _deleteCategoryWithNested(String categoryId) async {
    final categoryRef =
        FirebaseFirestore.instance.collection('categories').doc(categoryId);

    // Delete nested events and their stories
    final eventsSnapshot = await categoryRef.collection('events').get();
    for (final eventDoc in eventsSnapshot.docs) {
      final storiesSnapshot =
          await eventDoc.reference.collection('stories').get();
      for (final storyDoc in storiesSnapshot.docs) {
        await storyDoc.reference.delete();
      }
      await eventDoc.reference.delete();
    }

    // Delete category doc itself
    await categoryRef.delete();
  }
}

class EventsList extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const EventsList({
    required this.categoryId,
    required this.categoryName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events in $categoryName"),
        iconTheme: IconThemeData(
          color: TColors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryId)
            .collection('events')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              var event = events[index];
              return ListTile(
                title: Text(event['title'] ?? "No Event Name"),
                subtitle: event['description'] != null &&
                        event['description'].toString().isNotEmpty
                    ? Text(event['description'])
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          _confirmDeleteEvent(context, categoryId, event.id),
                    ),
                    const Icon(Icons.arrow_forward),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StoriesList(
                        categoryId: categoryId,
                        eventId: event.id,
                        eventName: event['title'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddEventDialog(context, categoryId),
      ),
    );
  }

  void _confirmDeleteEvent(
      BuildContext context, String categoryId, String eventId) async {
    bool confirmed = await showConfirmDialog(
      context,
      title: "Delete Event",
      content:
          "Are you sure you want to delete this event and all its stories?",
    );

    if (!confirmed) return;

    await _deleteEventWithNested(categoryId, eventId);
  }

  Future<void> _deleteEventWithNested(String categoryId, String eventId) async {
    final eventRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .collection('events')
        .doc(eventId);

    final storiesSnapshot = await eventRef.collection('stories').get();
    for (final storyDoc in storiesSnapshot.docs) {
      await storyDoc.reference.delete();
    }

    await eventRef.delete();
  }

  void _showAddEventDialog(BuildContext context, String categoryId) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Event"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Event Name",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? "Enter event name"
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: "Description",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final name = nameController.text.trim();
                final description = descController.text.trim();

                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
                    .collection('events')
                    .add({
                  'title': name,
                  'description': description,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class StoriesList extends StatelessWidget {
  final String categoryId;
  final String eventId;
  final String eventName;

  const StoriesList({
    required this.categoryId,
    required this.eventId,
    required this.eventName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stories in $eventName"),
        iconTheme: IconThemeData(
          color: TColors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryId)
            .collection('events')
            .doc(eventId)
            .collection('stories')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          var stories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              var story = stories[index].data() as Map<String, dynamic>;

              String contentPreview = (story['content'] ?? '').toString();
              if (contentPreview.length > 100) {
                contentPreview = contentPreview.substring(0, 100) + '...';
              }

              return ListTile(
                title: Text(story['title'] ?? "No Title"),
                subtitle: Text(contentPreview),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDeleteStory(
                      context, categoryId, eventId, stories[index].id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddStoryDialog(context, categoryId, eventId),
      ),
    );
  }

  void _confirmDeleteStory(
      BuildContext context, String categoryId, String eventId, String storyId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Story"),
        content: const Text("Are you sure you want to delete this story?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('categories')
                  .doc(categoryId)
                  .collection('events')
                  .doc(eventId)
                  .collection('stories')
                  .doc(storyId)
                  .delete();
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showAddStoryDialog(
      BuildContext context, String categoryId, String eventId) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Story"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: "Story Title"),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(hintText: "Story Content"),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Add"),
            onPressed: () async {
              final title = titleController.text.trim();
              final content = contentController.text.trim();
              if (title.isNotEmpty && content.isNotEmpty) {
                await FirebaseFirestore.instance
                    .collection('categories')
                    .doc(categoryId)
                    .collection('events')
                    .doc(eventId)
                    .collection('stories')
                    .add({
                  'title': title,
                  'content': content,
                  'createdAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
