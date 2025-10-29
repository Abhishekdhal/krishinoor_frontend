import 'package:flutter/material.dart';
import '../services/api_service.dart';
class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({super.key});
  @override
  State<AdminFeedbackPage> createState() => _AdminFeedbackPageState();
}
class _AdminFeedbackPageState extends State<AdminFeedbackPage> {
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
                : _fetchFeedbacks,
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
                            if (data["image_url"] != null &&
                                data["image_url"].toString().isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Image.network(
                                  data[
                                      "image_url"],
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                          ],
                        ),
                        trailing: Text(
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