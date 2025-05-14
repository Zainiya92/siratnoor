import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addData() async {
    List<Map<String, dynamic>> categories = [
      {
        "id": "age_3_5",
        "title": "Ages 3-5",
        "description": "Simple stories for young kids"
      },
      {
        "id": "age_6_9",
        "title": "Ages 6-9",
        "description": "More detailed stories for kids"
      },
      {
        "id": "age_10_15",
        "title": "Ages 10-15",
        "description": "Advanced stories for teens"
      },
      {
        "id": "age_16_25",
        "title": "Ages 16-25",
        "description": "Young adulthood & prophethood"
      },
      {
        "id": "age_26_39",
        "title": "Ages 26-39",
        "description": "Before the Prophethood"
      },
      {
        "id": "age_40_50",
        "title": "Ages 40-50",
        "description": "First 10 years of Prophethood"
      },
      {
        "id": "age_51_55",
        "title": "Ages 51-55",
        "description": "Migration & early battles"
      },
      {
        "id": "age_56_60",
        "title": "Ages 56-60",
        "description": "Major battles & Islamic expansion"
      },
      {
        "id": "age_61_63",
        "title": "Ages 61-63",
        "description": "Final years & farewell"
      },
    ];

    Map<String, List<Map<String, dynamic>>> events = {
      "age_3_5": [
        {
          "id": "event_1",
          "title": "Birth of the Prophet",
          "description": "The blessed birth in the Year of the Elephant"
        },
        {
          "id": "event_2",
          "title": "Raised by Halimah (RA)",
          "description": "The Prophet was sent to live in the desert"
        },
        {
          "id": "event_3",
          "title": "Death of his Mother Amina",
          "description": "Orphaned at a young age"
        },
      ],
      "age_6_9": [
        {
          "id": "event_4",
          "title": "Care of Abu Talib",
          "description": "Raised by his uncle after his grandfather’s passing"
        },
        {
          "id": "event_5",
          "title": "First Business Trip to Syria",
          "description": "Accompanied Abu Talib for trading"
        },
        {
          "id": "event_6",
          "title": "Earning the Title of Al-Amin",
          "description": "People trusted him for honesty"
        },
      ],
      "age_10_15": [
        {
          "id": "event_7",
          "title": "Hilf al-Fudul",
          "description": "Joined an alliance for justice"
        },
        {
          "id": "event_8",
          "title": "Helping in the Kaaba Reconstruction",
          "description": "Placed the Black Stone (Hajr Aswad)"
        },
      ],
      "age_16_25": [
        {
          "id": "event_9",
          "title": "Marriage to Khadijah (RA)",
          "description": "Blessed marriage with a noble woman"
        },
        {
          "id": "event_10",
          "title": "Becoming a successful trader",
          "description": "Gained fame for his honesty in business"
        },
      ],
      "age_26_39": [
        {
          "id": "event_11",
          "title": "First Spiritual Retreats",
          "description": "Spent time in Cave Hira for meditation"
        },
      ],
      "age_40_50": [
        {
          "id": "event_12",
          "title": "First Revelation",
          "description":
              "Angel Jibreel (AS) brings the first verses of the Quran"
        },
        {
          "id": "event_13",
          "title": "The Early Muslims",
          "description": "First few people accept Islam"
        },
        {
          "id": "event_14",
          "title": "Persecution of Muslims",
          "description": "Quraysh start oppressing believers"
        },
      ],
      "age_51_55": [
        {
          "id": "event_15",
          "title": "Isra and Miraj",
          "description": "The miraculous Night Journey"
        },
        {
          "id": "event_16",
          "title": "Migration to Madinah",
          "description": "The great Hijrah"
        },
      ],
      "age_56_60": [
        {
          "id": "event_17",
          "title": "Battle of Badr",
          "description": "The first major battle in Islam"
        },
        {
          "id": "event_18",
          "title": "Battle of Uhud",
          "description": "A lesson in patience"
        },
      ],
      "age_61_63": [
        {
          "id": "event_19",
          "title": "Final Sermon",
          "description": "The last message to the Ummah"
        },
        {
          "id": "event_20",
          "title": "The Prophet’s Passing",
          "description": "The greatest loss for the Ummah"
        },
      ]
    };

    Map<String, List<Map<String, dynamic>>> stories = {
      "event_1": [
        {
          "id": "story_1",
          "title": "The Birth",
          "content":
              "Prophet Muhammad (SAW) was born in the year of the Elephant..."
        },
        {
          "id": "story_2",
          "title": "A Light in Makkah",
          "content": "His birth brought blessings to the land..."
        },
      ],
      "event_2": [
        {
          "id": "story_3",
          "title": "Raised by Halimah",
          "content": "He was raised in the desert for a few years..."
        },
        {
          "id": "story_4",
          "title": "A Childhood of Honesty",
          "content": "Even as a child, he was known for his honesty..."
        },
      ],
      "event_12": [
        {
          "id": "story_5",
          "title": "The First Revelation",
          "content": "Jibreel (AS) appeared to the Prophet in Cave Hira..."
        },
        {
          "id": "story_6",
          "title": "The First Muslims",
          "content": "His wife Khadijah (RA) was the first to accept Islam..."
        },
      ],
      "event_16": [
        {
          "id": "story_7",
          "title": "The Migration",
          "content": "The Prophet left Makkah under the cover of night..."
        },
        {
          "id": "story_8",
          "title": "A Safe Arrival",
          "content": "The Muslims were welcomed in Madinah with open arms..."
        },
      ],
      "event_20": [
        {
          "id": "story_9",
          "title": "The Prophet’s Farewell",
          "content": "The final days of the Messenger of Allah..."
        },
        {
          "id": "story_10",
          "title": "The Greatest Loss",
          "content": "The Ummah mourned his passing..."
        },
      ],
    };

    try {
      for (var category in categories) {
        await _firestore
            .collection('categories')
            .doc(category['id'])
            .set(category);
        if (events.containsKey(category['id'])) {
          for (var event in events[category['id']]!) {
            await _firestore
                .collection('categories')
                .doc(category['id'])
                .collection('events')
                .doc(event['id'])
                .set(event);
            if (stories.containsKey(event['id'])) {
              for (var story in stories[event['id']]!) {
                await _firestore
                    .collection('categories')
                    .doc(category['id'])
                    .collection('events')
                    .doc(event['id'])
                    .collection('stories')
                    .doc(story['id'])
                    .set(story);
              }
            }
          }
        }
      }
      print("✅ Data added successfully!");
    } catch (e) {
      print("❌ Error adding data: $e");
    }
  }
}
