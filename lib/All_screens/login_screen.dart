import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class Loginscreenapi extends StatelessWidget {
  Loginscreenapi({super.key});

  //حفظ المدخلات
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Login'),
      ),
      body: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //signupScreen
              const Text(
                'Login Screen',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text.trim();
                  String pass = passwordController.text.trim();

                  if (email.isEmpty || pass.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("❌ Email and Password required")),
                    );
                    return;
                  }

                  try {
                    // 🔹 استدعاء الـ API
                    var url = Uri.parse(
                        "https://pk122j13-7109.euw.devtunnels.ms/api/Account/Login?email=$email&password=$pass");

                    var response = await http.get(url);

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("✅ Welcome ${data['firstName']}")),
                      );

                      // مثال: الانتقال للـ HomeScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    } else {
                      print('Faild');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("❌ ${response.body}")),
                      );
                      print("❌ ${response.body}");
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("⚠️ Error: $e")),
                    );
                  }
                },
                child: const Text('Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
