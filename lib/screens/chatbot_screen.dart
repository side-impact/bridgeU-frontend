import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final schools = ["Korea University"];
  String selectedSchool = "Korea University";

  final TextEditingController questionController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final List<Map<String, dynamic>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "ToMo",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.black),
          onPressed: () {
            Navigator.pushNamed(context, '/community');
          },
        ),
      ),
      body: Column(
        children: [
          // 상단 학교 선택 영역
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: InkWell(
              onTap: _showSchoolSelection,
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/images/korea_logo.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$selectedSchool ToMo",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 스크롤 가능한 중앙 영역
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // ToMo 캐릭터 이미지
                  Image.asset(
                    'assets/images/korea_logo.png',
                    width: 120,
                    height: 120,
                  ),
                  const SizedBox(height: 16),

                  // 인사말
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Hello, I’m ToMo! \nHere to prepare your Tomorrow 🌍\nType your question about your university below.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 메시지 리스트
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isUser = msg["role"] == "user";
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isUser)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/korea_logo.png',
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              ),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color.fromARGB(100, 2, 199, 174)
                                      : const Color.fromARGB(
                                          200,
                                          253,
                                          191,
                                          191,
                                        ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  msg["text"],
                                  style: TextStyle(
                                    color: isUser
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser) const SizedBox(width: 32),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // 하단 입력 영역
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            margin: const EdgeInsets.only(bottom: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: questionController,
                    decoration: InputDecoration(
                      hintText: "Type your question...",
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(100, 2, 199, 174),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Color.fromARGB(100, 2, 199, 174),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.black),
                  onPressed: () => sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void sendMessage() async {
    final text = questionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": text});
      messages.add({"role": "bot", "text": "Typing..."});
    });
    questionController.clear();
    scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse("http://10.121.201.64:5000/ask"), // Flask API
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          messages.removeWhere((msg) => msg["text"] == "Typing...");
          messages.add({"role": "bot", "text": data["answer"]});
        });
      } else {
        setState(() {
          messages.removeWhere((msg) => msg["text"] == "Typing...");
          messages.add({
            "role": "bot",
            "text": "Sorry, something went wrong. Please try again.",
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.removeWhere((msg) => msg["text"] == "Typing...");
        messages.add({
          "role": "bot",
          "text": "Cannot connect to server. Check your network.",
        });
      });
    } finally {
      scrollToBottom();
    }
  }

  void _showSchoolSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade100,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: schools
              .map(
                (school) => ListTile(
                  title: Text(
                    school,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    setState(() {
                      selectedSchool = school;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
