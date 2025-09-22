import 'package:flutter/material.dart';
import 'signup_complete_screen.dart';

class PasswordScreen extends StatefulWidget {
  final String name;
  final String email;

  const PasswordScreen({super.key, required this.name, required this.email});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final darkColor = const Color.fromARGB(100, 2, 199, 174);
  final lightColor = const Color.fromARGB(20, 2, 199, 174);

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  String? passwordError;
  String? confirmError;

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
              value: 2 / 2,
              backgroundColor: lightColor,
              color: darkColor,
              minHeight: 4,
            ),
            SizedBox(height: height * 0.04),
            const Text(
              "Set your password",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: height * 0.03),

            // Password input
            const Text("Password"),
            SizedBox(height: height * 0.01),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Enter your password",
                prefixIcon: const Icon(Icons.lock),
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
                errorText: passwordError,
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

            // Confirm Password input
            const Text("Confirm Password"),
            SizedBox(height: height * 0.01),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Confirm your password",
                prefixIcon: const Icon(Icons.lock),
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
                errorText: confirmError,
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

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(200, 144, 231, 219),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: height * 0.05,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        final password = passwordController.text;
                        final confirm = confirmController.text;

                        setState(() {
                          passwordError = password.isEmpty
                              ? "Please enter a password"
                              : null;
                          confirmError = confirm.isEmpty
                              ? "Please confirm your password"
                              : (password != confirm
                                    ? "Passwords do not match"
                                    : null);
                        });

                        if (passwordError != null || confirmError != null) {
                          return;
                        }

                        // 모두 통과하면 다음 화면으로
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpCompleteScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }
}
