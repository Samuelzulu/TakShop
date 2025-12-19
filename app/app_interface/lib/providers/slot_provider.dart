import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/seller_slot.dart';

class SlotProvider with ChangeNotifier {
  List<SellerSlot> _slots = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SellerSlot> get slots => _slots;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchSlotsForSeller(String sellerId, DateTime date) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await SupabaseService.client
          .from('seller_slots')
          .select()
          .eq('seller_id', sellerId)
          .eq('is_active', true)
          .gte('start_time', startOfDay.toIso8601String())
          .lt('start_time', endOfDay.toIso8601String())
          .order('start_time');

      _slots = (response as List)
          .map((json) => SellerSlot.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createSlot({
    required DateTime startTime,
    required DateTime endTime,
    int capacity = 1,
  }) async {
    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Not authenticated');

      final user = await SupabaseService.client
          .from('users')
          .select('university_id')
          .eq('id', userId)
          .single();

      await SupabaseService.client.from('seller_slots').insert({
        'university_id': user['university_id'],
        'seller_id': userId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'capacity': capacity,
      });

      // Refresh slots
      await fetchSlotsForSeller(userId, startTime);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteSlot(String slotId) async {
    try {
      await SupabaseService.client
          .from('seller_slots')
          .delete()
          .eq('id', slotId);

      _slots.removeWhere((slot) => slot.id == slotId);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}

// Extension method for Order toJson (if needed)
extension OrderExtension on Order {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'listing_id': listingId,
      'slot_id': slotId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'status': status,
      'delivery_location_id': deliveryLocationId,
      'delivery_location_text': deliveryLocationText,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}