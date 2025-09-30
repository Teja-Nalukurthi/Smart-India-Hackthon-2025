import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/chat_models.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    // Add initial greeting message from Naradha
    setState(() {
      _messages.add(
        ChatMessage(
          id: '1',
          sessionId: 'session_1',
          message:
              "Hello there! I'm Naradha, your guide to all things local. How can I help you explore today?",
          isFromUser: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ask Naradha',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return _buildTypingIndicator();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Quick Suggestion Buttons
          if (!_isTyping) _buildQuickSuggestions(),

          // Message Input
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isFromUser = message.isFromUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isFromUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isFromUser) ...[_buildAvatar(false), const SizedBox(width: 8)],

          Flexible(
            child: Column(
              crossAxisAlignment: isFromUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  isFromUser ? 'You' : 'Naradha',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors
                        .primary, // Use primary color for better visibility
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isFromUser
                        ? AppColors.primary
                        : Colors.white, // White background for Naradha
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isFromUser ? 16 : 4),
                      bottomRight: Radius.circular(isFromUser ? 4 : 16),
                    ),
                    boxShadow: isFromUser
                        ? null
                        : [
                            // Add shadow to Naradha messages
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                    border: isFromUser
                        ? null
                        : Border.all(
color: AppColors.primary.withAlpha((255 * 0.2).round()),
                            width: 1,
                          ),
                  ),
                  child: Text(
                    message.message,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isFromUser ? Colors.white : AppColors.textLight,
                      fontSize: 16, // Slightly larger font
                      height: 1.4, // Better line height for readability
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isFromUser) ...[const SizedBox(width: 8), _buildAvatar(true)],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUser ? AppColors.primary : AppColors.accent,
        image: DecorationImage(
          image: NetworkImage(
            isUser
                ? 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80'
                : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=100&q=80',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildAvatar(false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white, // White background for better visibility
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
color: AppColors.primary.withAlpha((255 * 0.2).round()),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(200),
                const SizedBox(width: 4),
                _buildTypingDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -5 * (1 - value)),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.textSubtle,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickSuggestions() {
    final suggestions = [
      "What's the story of this place?",
      "Any festivals nearby?",
      "Best local food spots?",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: suggestions.map((suggestion) {
          return GestureDetector(
            onTap: () => _sendMessage(suggestion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha((255 * 0.1).round()),
                border: Border.all(color: AppColors.primary.withAlpha((255 * 0.5).round())),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                suggestion,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // White background for better contrast
        border: Border(
          top: BorderSide(
            color: AppColors.primary.withAlpha((255 * 0.2).round()),
            width: 1.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: 'Ask Naradha...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSubtle,
                    fontSize: 16,
                  ),
                  filled: true,
                  fillColor:
                      Colors.white, // White background for better visibility
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.primary.withAlpha((255 * 0.3).round()),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.primary.withAlpha((255 * 0.3).round()),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _sendMessage(value);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  final message = _messageController.text.trim();
                  if (message.isNotEmpty) {
                    _sendMessage(message);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sessionId: 'session_1',
          message: text,
          isFromUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    _simulateAIResponse(text);
  }

  void _simulateAIResponse(String userMessage) {
    // Simulate thinking time
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      String response = _generateResponse(userMessage);

      setState(() {
        _isTyping = false;
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            sessionId: 'session_1',
            message: response,
            isFromUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollToBottom();
    });
  }

  String _generateResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();

    if (lowerMessage.contains('jaipur') || lowerMessage.contains('rajasthan')) {
      return "Jaipur is a treasure trove! For a first-time visitor, I'd recommend the City Palace, Hawa Mahal, and Amber Fort. Each offers a unique glimpse into the city's rich history and architecture.";
    } else if (lowerMessage.contains('food') || lowerMessage.contains('eat')) {
      return "For authentic local cuisine, I'd recommend trying the street food at MI Road, dal baati churma at Chokhi Dhani, and don't miss the famous lassi at Lassiwala!";
    } else if (lowerMessage.contains('festival')) {
      return "There are several vibrant festivals happening this season! The Teej festival is particularly beautiful, with women in colorful attire celebrating the monsoon. Would you like specific dates and locations?";
    } else if (lowerMessage.contains('story') ||
        lowerMessage.contains('history')) {
      return "This region has fascinating stories! From ancient trade routes to royal legends, each corner has tales waiting to be told. What specific area or monument interests you?";
    } else {
      return "That's an interesting question! Let me help you discover the cultural richness of this region. Could you tell me more about what specific aspect of local culture interests you most?";
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
