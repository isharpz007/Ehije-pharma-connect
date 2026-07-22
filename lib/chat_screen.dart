import 'package:flutter/material.dart';

import 'app_bottom_nav.dart';

class _ChatMessage {
  final String text;
  final String time;
  final bool fromUser;

  const _ChatMessage({required this.text, required this.time, required this.fromUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);
  static const Color borderGrey = Color(0xFFE1E3EC);
  static const Color green = Color(0xFF1F8B3F);

  final TextEditingController _messageController = TextEditingController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hello! How can we help you today?',
      time: '10:12 AM',
      fromUser: false,
    ),
    const _ChatMessage(
      text: 'Hi, I wanted to know if Cetirizine 10mg is available?',
      time: '10:13 AM',
      fromUser: true,
    ),
    const _ChatMessage(
      text: 'Yes, it is in stock and ready to be delivered.',
      time: '10:14 AM',
      fromUser: false,
    ),
    const _ChatMessage(
      text: 'Great! Thank you.',
      time: '10:14 AM',
      fromUser: true,
    ),
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, time: 'now', fromUser: true));
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.maybePop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.arrow_back, color: darkNavy, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE9F7EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_pharmacy_outlined, color: green, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GreenCare Pharmacy',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: darkNavy,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(color: green, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Online',
                              style: TextStyle(fontSize: 11, color: green, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_vert, color: darkNavy, size: 20),
                ],
              ),
            ),
            const Divider(height: 1, color: borderGrey),

            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) => _MessageBubble(message: _messages[index]),
              ),
            ),

            // Input bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F6FB),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type a message...',
                                hintStyle: TextStyle(fontSize: 13, color: hintGrey),
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const Icon(Icons.attach_file, size: 18, color: hintGrey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),

            const AppBottomNav(current: AppTab.chat),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _ChatMessage message;
  const _MessageBubble({required this.message});

  static const Color primaryBlue = Color(0xFF3B3FE0);
  static const Color darkNavy = Color(0xFF1A1B3A);
  static const Color hintGrey = Color(0xFF9B9FB1);

  @override
  Widget build(BuildContext context) {
    final align = message.fromUser ? Alignment.centerRight : Alignment.centerLeft;
    final bubbleColor = message.fromUser ? primaryBlue : const Color(0xFFF4F6FB);
    final textColor = message.fromUser ? Colors.white : darkNavy;

    return Align(
      alignment: align,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.fromUser ? 16 : 4),
            bottomRight: Radius.circular(message.fromUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(fontSize: 13, color: textColor, height: 1.4),
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: TextStyle(
                fontSize: 10,
                color: message.fromUser ? Colors.white70 : hintGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}