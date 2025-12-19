import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final _client = SupabaseService.client;

  // Register new user
  Future<AuthResponse> register({
    required String name,
    required String phone,
    required String password,
    required String universityId,
    required String role,
  }) async {
    // Sign up with Supabase Auth
    final response = await _client.auth.signUp(
      email: '$phone@takshop.zm', // Using phone as email with domain
      password: password,
    );

    if (response.user != null) {
      // Insert user details into users table
      await _client.from('users').insert({
        'id': response.user!.id,
        'university_id': universityId,
        'role': role,
        'name': name,
        'phone': phone,
        'created_at': DateTime.now().toIso8601String(),
        'is_active': true,
      });
    }

    return response;
  }

  // Login
  Future<AuthResponse> login({
    required String phone,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: '$phone@takshop.zm',
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  // Get current user details from database
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from('users')
        .select('*, universities(*)')
        .eq('id', userId)
        .single();

    return response;
  }

  // Update user university
  Future<void> updateUniversity(String universityId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    await _client.from('users').update({
      'university_id': universityId,
    }).eq('id', userId);
  }
}