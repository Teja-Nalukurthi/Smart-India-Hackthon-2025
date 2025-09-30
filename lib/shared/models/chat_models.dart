class ChatMessage {
  final String id;
  final String sessionId;
  final String message;
  final bool isFromUser;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.message,
    required this.isFromUser,
    required this.timestamp,
    this.metadata,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sessionId: json['session_id'],
      message: json['message'],
      isFromUser: json['is_from_user'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'message': message,
      'is_from_user': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }
}

class ChatSession {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;
  final DateTime lastMessageAt;

  ChatSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
    required this.lastMessageAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      createdAt: DateTime.parse(json['created_at']),
      lastMessageAt: DateTime.parse(json['last_message_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'last_message_at': lastMessageAt.toIso8601String(),
    };
  }
}
