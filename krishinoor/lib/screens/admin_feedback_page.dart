// lib/screens/admin_feedback_page.dart

import 'package:flutter/material.dart';
// Note: We renamed supabase_service.dart to api_service.dart
import '../services/api_service.dart';

class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({super.key});

  @override
  State<AdminFeedbackPage> createState() => _AdminFeedbackPageState();
}

class _AdminFeedbackPageState extends State<AdminFeedbackPage> {
  // 💡 MIGRATED: Use the new ApiService class
  final ApiService apiService = ApiService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _feedbacks = [];

  @override
  void initState() {
    super.initState();
    _fetchFeedbacks();
  }

  Future<void> _fetchFeedbacks() async {
    setState(() => _isLoading = true);

    try {
      // 💡 MIGRATED: Call the new apiService.getFeedbackOnce()
      final feedbacks = await apiService.getFeedbackOnce();

      if (mounted) {
        setState(() {
          _feedbacks = feedbacks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Show error message on fetch failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                "Failed to load feedback: ${e.toString().replaceFirst('Exception: ', '')}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Feedback"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading
                ? null
                : _fetchFeedbacks, // Disable refresh while loading
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feedbacks.isEmpty
              ? const Center(child: Text("No feedback yet"))
              : ListView.builder(
                  itemCount: _feedbacks.length,
                  itemBuilder: (context, index) {
                    final data = _feedbacks[index];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data["name"] ?? "Anonymous"),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data["message"] ?? ""),
                            // Use "image_url" which is the standard field name used in api_service.dart
                            if (data["image_url"] != null &&
                                data["image_url"].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  data[
                                      "image_url"], // 💡 CHECK: Ensure key matches your Node.js response
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
                          // Use "created_at" which is the standard field name used in api_service.dart
                          data["created_at"] != null
                              ? DateTime.parse(data["created_at"])
                                  .toLocal()
                                  .toString()
                              : "",
                          style:
                              const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}