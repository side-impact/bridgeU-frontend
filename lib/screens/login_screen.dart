import 'package:flutter/material.dart';
import 'signup_screen.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

final bridgeUColor = const Color.fromARGB(100, 2, 199, 174);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    // 화면 크기 가져오기
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 로고 (화면 높이에 따라 비율 조정)
                Flexible(
                  flex: 2,
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: height * 0.18,
                  ),
                ),

                SizedBox(height: height * 0.02),

                Text(
                  "Welcome to BridgeU",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: bridgeUColor,
                    fontSize: height * 0.025, // 비율 기반 폰트
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: height * 0.05),
                // 이메일 입력
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    hintText: "Email address",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey), // 기본 테두리
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: bridgeUColor), // 포커스 시 색상
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                // 비밀번호 입력
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.grey,
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: bridgeUColor),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.04),

                // 로그인 버튼
                SizedBox(
                  width: double.infinity,
                  height: height * 0.05,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Please enter email and password"),
                          ),
                        );
                        return;
                      }

                      // 로그인 시도
                      bool success = await Provider.of<AuthProvider>(
                        context,
                        listen: false,
                      ).login(email, password);

                      if (success) {
                        // 로그인 성공 → JWT 저장 후 CommunityScreen으로 이동
                        Navigator.pushReplacementNamed(context, '/community');
                      } else {
                        // 로그인 실패
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Login failed. Check credentials."),
                          ),
                        );
                      }
                    },

                    child: Text(
                      "LogIn",
                      style: TextStyle(
                        fontSize: height * 0.018, // 글자 크기
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // 회원가입 / 비밀번호 찾기
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color.fromARGB(100, 2, 199, 174),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: null, // 동작 안 함
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.04),

                // // 소셜 로그인 (커스텀 버튼 스타일)
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     _buildSocialButton(
                //       onTap: () {},
                //       asset: "assets/images/apple_logo.png",
                //       text: "Apple",
                //     ),
                //     const SizedBox(width: 16),
                //     _buildSocialButton(
                //       onTap: () {},
                //       asset: "assets/images/google_logo.png",
                //       text: "Google",
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 소셜 버튼 위젯
  //   Widget _buildSocialButton({
  //     required VoidCallback onTap,
  //     required String asset,
  //     required String text,
  //   }) {
  //     return Expanded(
  //       child: GestureDetector(
  //         onTap: onTap,
  //         child: Container(
  //           height: 48,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             border: Border.all(color: Colors.grey.shade300),
  //             borderRadius: BorderRadius.circular(12),
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Image.asset(asset, height: 20),
  //               const SizedBox(width: 8),
  //               Text(text),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
}
