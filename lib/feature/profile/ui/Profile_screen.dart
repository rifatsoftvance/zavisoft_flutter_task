import 'package:flutter/material.dart';
import 'package:zavisoft_flutter_task/core/api_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final api = ApiClient();
  Map<String, dynamic>? user;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final u = await api.fetchUser(1);
    setState(() => user = u);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text("${user!['name']['firstname']} "
                "${user!['name']['lastname']}"),
            Text(user!['email']),
          ],
        ),
      ),
    );
  }
}