import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final supabase = Supabase.instance.client;

  /// ✅ Upload image to Supabase Storage
  Future<String?> uploadImage(File imageFile) async {
    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Upload file to Supabase storage bucket
      await supabase.storage
          .from('feedback_images') // bucket name in Supabase
          .upload(fileName, imageFile);

      // Get public URL for the uploaded file
      final publicUrl =
          supabase.storage.from('feedback_images').getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Image upload error: $e");
      }
      return null;
    }
  }

  /// ✅ Add feedback with optional image
  Future<void> addFeedback(String name, String message, {String? imageUrl}) async {
    try {
      await supabase.from('feedback').insert({
        "name": name,
        "message": message,
        "image_url": imageUrl,
        "created_at": DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception("Error adding feedback: $e");
    }
  }

  /// ✅ Get feedbacks in real-time (Supabase stream)
  Stream<List<Map<String, dynamic>>> getFeedbackStream() {
    return supabase
        .from('feedback')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
  }

  /// ✅ Get feedbacks once (not real-time)
  Future<List<Map<String, dynamic>>> getFeedbackOnce() async {
    try {
      final response = await supabase
          .from('feedback')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception("Error fetching feedback: $e");
    }
  }
}
