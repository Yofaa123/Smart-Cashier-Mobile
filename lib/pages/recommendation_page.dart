import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../config/api.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({super.key});

  @override
  State<RecommendationPage> createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  List recommendations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecommendations();
  }

  Future<void> fetchRecommendations() async {
    setState(() {
      isLoading = true;
    });
    final token = context.read<AuthProvider>().token;
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/recommendations'),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        recommendations = data['recommendations'] ?? [];
        isLoading = false;
      });
    } else {
      setState(() {
        recommendations = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekomendasi Belajar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : recommendations.isEmpty
            ? const Center(child: Text('Belum ada rekomendasi'))
            : ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final rec = recommendations[index];
                  return Card(
                    child: ListTile(
                      title: Text(rec['title']),
                      subtitle: Text(
                        'Level: ${rec['level']}\nAlasan: ${rec['reason']}',
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
