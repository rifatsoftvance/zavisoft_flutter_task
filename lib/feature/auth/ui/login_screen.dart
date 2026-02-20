import 'package:flutter/material.dart';
import 'package:zavisoft_flutter_task/core/api_client.dart';
import 'package:zavisoft_flutter_task/feature/home/ui/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final api = ApiClient();
  final username = TextEditingController(text: "mor_2314");
  final password = TextEditingController(text: "83r5^_");

  bool loading = false;

  void login() async {
    setState(() => loading = true);

    final res = await api.login(username.text, password.text);

    setState(() => loading = false);

    if (res['token'] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("FakeStore Login",
                style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TextField(controller: username),
            const SizedBox(height: 10),
            TextField(controller: password, obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loading ? null : login,
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            )
          ],
        ),
      ),
    );
  }
}