import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  late final String name;
  late final String description;
  late final String ownerId;
  late final Timestamp createdAt;
  late final Timestamp updatedAt;

  Project({
    required this.name,
    this.description = '',
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });
}
