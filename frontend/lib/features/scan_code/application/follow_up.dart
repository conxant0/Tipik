import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void openFollowUpChat(BuildContext context, String codeExplanation) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // allow rounded corners to show
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6, // starts at 60% height
        minChildSize: 0.3,     // minimum 30% height
        maxChildSize: 0.95,    // can expand up to 95%
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: FollowUpChat(
              code: codeExplanation,
              scrollController: scrollController,
            ),
          );
        },
      );
    },
  );
}


class FollowUpChat extends StatefulWidget {
  final String code;
  final ScrollController scrollController;

  const FollowUpChat({Key? key, required this.code, required this.scrollController}) : super(key: key);

  @override
  State<FollowUpChat> createState() => _FollowUpChatState();
}


class _FollowUpChatState extends State<FollowUpChat> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // role: user/assistant, content
  bool _isSending = false;

  Future<void> _sendMessage() async {
    final question = _controller.text.trim();
    if (question.isEmpty || _isSending) return;

    setState(() {
      _messages.add({"role": "user", "content": question});
      _controller.clear();
      _isSending = true;
    });

    final host = dotenv.env['API_BASE_URL'] ?? 'http://localhost';
    final port = dotenv.env['CAMERA_PORT'] ?? '3000';
    final uri = Uri.parse('$host:$port/follow-up');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'code': widget.code,
        'question': question,
        'history': _messages
            .where((m) => m['role'] != 'user' || m != _messages.last) // exclude latest user message
            .toList(),
      }),
    );

    if (response.statusCode == 200) {
      final reply = jsonDecode(response.body)['reply'];
      setState(() => _messages.add({"role": "assistant", "content": reply}));
    } else {
      setState(() => _messages.add({"role": "assistant", "content": "Something went wrong."}));
    }

    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Follow-up Questions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['content'] ?? ''),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask a question...'
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              IconButton(
                onPressed: _isSending ? null : _sendMessage,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}