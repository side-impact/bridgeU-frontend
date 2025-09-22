import 'package:flutter/material.dart';

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const Spacer(), // 위 내용은 화면 중앙으로
              Text(
                'Sign-up Completed!',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Welcome to BridgeU!\n'
                'Your go-to app for international exchange and study abroad students, connecting you with info and a global community.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  // fontWeight: FontWeight.bold,
                  height: 1.5, // 줄 간격 조정
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),

              const Spacer(), // 내용과 버튼 사이 공간 확보

              SizedBox(
                width: double.infinity,
                height: height * 0.05, // Next/Back 버튼과 동일 높이
                child: ElevatedButton(
                  onPressed: () {
                    // Confirm 버튼 눌렀을 때 로그인 화면으로 이동
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Next/Back 버튼과 동일
                    ),
                  ),
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01), // 버튼 아래 간격
            ],
          ),
        ),
      ),
    );
  }
}
