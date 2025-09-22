import 'package:flutter/material.dart';
import 'signup_password_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final darkColor = const Color.fromARGB(100, 2, 199, 174);
  final lightColor = const Color.fromARGB(20, 2, 199, 174);

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String? nameError;
  String? emailError;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Sign Up",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),
            LinearProgressIndicator(
              value: 1 / 2,
              backgroundColor: lightColor,
              color: darkColor,
              minHeight: 4,
            ),
            SizedBox(height: height * 0.04),
            const Text(
              "Enter the information\nfor your account.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.03),
            // Name input
            const Text("Full Name"),
            SizedBox(height: height * 0.01),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "At least 2 characters",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: lightColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: darkColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: darkColor, width: 2),
                ),
                errorText: nameError,
                errorStyle: const TextStyle(
                  color: Color.fromARGB(255, 250, 151, 151),
                  fontSize: 12,
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 253, 191, 191),
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 253, 191, 191),
                    width: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            // Email input
            const Text("Email Address"),
            SizedBox(height: height * 0.01),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "example@google.com",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: lightColor,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: darkColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: darkColor, width: 2),
                ),
                errorText: emailError,
                errorStyle: const TextStyle(
                  color: Color.fromARGB(255, 250, 151, 151),
                  fontSize: 12,
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 253, 191, 191),
                    width: 2,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 253, 191, 191),
                    width: 2,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    // 이름 비어있는지 체크
                    nameError = nameController.text.isEmpty
                        ? "Please enter your full name"
                        : null;

                    // 이메일 체크
                    if (emailController.text.isEmpty) {
                      emailError = "Please enter your email";
                    } else {
                      final emailRegex = RegExp(
                        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                      );
                      emailError = emailRegex.hasMatch(emailController.text)
                          ? null
                          : "Please enter a valid email";
                    }
                  });

                  if (nameError != null || emailError != null) {
                    return; // 오류 있으면 다음 화면으로 넘어가지 않음
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PasswordScreen(
                        name: nameController.text,
                        email: emailController.text,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }
}
