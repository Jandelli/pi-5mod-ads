class Chat {
  final String id;
  // Add additional fields as needed

  Chat({required this.id});

  factory Chat.fromMap(Map<String, dynamic> map) {
    // Convert map to Chat (customize based on your fields)
    return Chat(id: map['id'] as String);
  }
}
