import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<Order> get buyerOrders {
    final userId = SupabaseService.currentUser?.id;
    return _orders.where((order) => order.buyerId == userId).toList();
  }

  List<Order> get sellerOrders {
    final userId = SupabaseService.currentUser?.id;
    return _orders.where((order) => order.sellerId == userId).toList();
  }

  Future<void> fetchOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = SupabaseService.currentUser?.id;
      if (userId == null) throw Exception('Not authenticated');

      final response = await SupabaseService.client
          .from('orders_with_details')
          .select()
          .or('buyer_id.eq.$userId,seller_id.eq.$userId')
          .order('created_at', ascending: false);

      _orders = (response as List)
          .map((json) => Order.fromJson(json))
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await SupabaseService.client
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      // Update local state
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index >= 0) {
        _orders[index] = Order.fromJson({
          ..._orders[index].toJson(),
          'status': newStatus,
        });
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      final userId = SupabaseService.currentUser?.id;

      await SupabaseService.client.rpc('cancel_order', params: {
        'p_order_id': orderId,
        'p_cancelled_by': userId,
        'p_reason': reason,
      });

      await fetchOrders(); // Refresh orders
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
