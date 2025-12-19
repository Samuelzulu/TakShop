import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/listing.dart';

class ListingProvider with ChangeNotifier {
  List<Listing> _listings = [];
  List<Listing> _filteredListings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _currentCategory;
  String? _searchQuery;

  List<Listing> get listings => _filteredListings.isEmpty ? _listings : _filteredListings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchListings({String? universityId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var query = SupabaseService.client
          .from('listings_with_details')
          .select()
          .eq('is_active', true);

      if (universityId != null) {
        query = query.eq('university_id', universityId);
      }

      final response = await query.order('created_at', ascending: false);

      _listings = (response as List)
          .map((json) => Listing.fromJson(json))
          .toList();

      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void filterByCategory(String? category) {
    _currentCategory = category;
    _applyFilters();
  }

  void searchListings(String query) {
    _searchQuery = query.isEmpty ? null : query.toLowerCase();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredListings = _listings.where((listing) {
      bool matchesCategory = _currentCategory == null ||
          listing.category == _currentCategory;

      bool matchesSearch = _searchQuery == null ||
          listing.title.toLowerCase().contains(_searchQuery!) ||
          listing.description.toLowerCase().contains(_searchQuery!);

      return matchesCategory && matchesSearch;
    }).toList();

    notifyListeners();
  }

  Future<Listing> getListingById(String id) async {
    final response = await SupabaseService.client
        .from('listings_with_details')
        .select()
        .eq('id', id)
        .single();

    return Listing.fromJson(response);
  }
}