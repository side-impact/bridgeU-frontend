import 'package:flutter/material.dart';
<<<<<<< Updated upstream
=======
import '../widgets/navigator.dart';
import '../widgets/screen_title.dart';
>>>>>>> Stashed changes

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final schools = [
    "Korea University",
    "Seoul National University",
    "Yonsei University",
  ];
  String selectedSchool = "Korea University";

  final TextEditingController questionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< Updated upstream
      appBar: AppBar(
        title: Text("$selectedSchool FAQ Chatbot"),
        backgroundColor: _getSchoolColor(selectedSchool),
        actions: [
          TextButton(
            onPressed: () => _showSchoolSelection(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: const Size(100, 40),
            ),
            child: Text(
              selectedSchool,
              style: TextStyle(color: _getSchoolColor(selectedSchool)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildSchoolChatbot(selectedSchool),
=======
      appBar: AppBar(title: const ScreenTitle('Chatbot')),
      body: const Center(child: Text('Chatbot Screen')),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
>>>>>>> Stashed changes
    );
  }

  Color _getSchoolColor(String school) {
    switch (school) {
      case "Seoul National University":
        return Colors.blue;
      case "Yonsei University":
        return Colors.purple;
      default: // Korea University
        return const Color.fromARGB(255, 2, 199, 174);
    }
  }

  Widget _buildSchoolChatbot(String school) {
    final lightColor = _getSchoolColor(school).withOpacity(0.2);

    // 학교별 FAQ 예시
    final faqList = {
      "Korea University": [
        "KU: How to apply?",
        "KU: Scholarships?",
        "KU: Dormitory info?",
      ],
      "Seoul National University": [
        "SNU: Application guide",
        "SNU: Scholarships",
        "SNU: Campus clubs",
      ],
      "Yonsei University": [
        "Yonsei: Required documents",
        "Yonsei: Visa info",
        "Yonsei: Student life",
      ],
    };

    return Column(
      children: [
        // 안내 영역
        Container(
          color: lightColor,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(
            "Welcome to $school FAQ Chatbot!\nType your question or select a popular topic.",
            style: const TextStyle(fontSize: 16),
          ),
        ),

        // FAQ 카테고리 버튼
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            children:
                [
                      "Application",
                      "Scholarship",
                      "Accommodation",
                      "Campus Life",
                      "Visa & Immigration",
                    ]
                    .map(
                      (title) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: 카테고리 선택 시 관련 FAQ 표시
                          },
                          child: Text(title),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),

        // 채팅 영역
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: faqList[school]!
                .map(
                  (q) => Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(q),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // 입력 영역
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: questionController,
                  decoration: const InputDecoration(
                    hintText: "Type your question...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: _getSchoolColor(selectedSchool)),
                onPressed: () {
                  // TODO: 질문 전송 기능
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showSchoolSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: schools
              .map(
                (school) => ListTile(
                  title: Text(school),
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
