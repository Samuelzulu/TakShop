import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/university.dart';

class UniversityProvider with ChangeNotifier {
  List<University> _universities = [];
  University? _selectedUniversity;
  bool _isLoading = false;
  String? _errorMessage;

  List<University> get universities => _universities;
  University? get selectedUniversity => _selectedUniversity;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchUniversities() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await SupabaseService.client
          .from('universities')
          .select()
          .eq('is_active', true)
          .order('name');

      _universities = (response as List)
          .map((json) => University.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectUniversity(University university) {
    _selectedUniversity = university;
    notifyListeners();
  }

  Future<void> loadUserUniversity(String universityId) async {
    try {
      final response = await SupabaseService.client
          .from('universities')
          .select()
          .eq('id', universityId)
          .single();

      _selectedUniversity = University.fromJson(response);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}