import 'package:flutter/material.dart';
import '../models/listing.dart';

class CartItem {
  final Listing listing;
  int quantity;
  String? selectedSlotId;
  String? deliveryLocationId;
  String? deliveryLocationText;
  String? notes;

  CartItem({
    required this.listing,
    this.quantity = 1,
    this.selectedSlotId,
    this.deliveryLocationId,
    this.deliveryLocationText,
    this.notes,
  });

  double get totalPrice => listing.price * quantity;
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  int get itemCount => _items.length;
  double get totalAmount => _items.fold(0, (sum, item) => sum + item.totalPrice);

  void addItem(Listing listing, {int quantity = 1}) {
    final existingIndex = _items.indexWhere(
          (item) => item.listing.id == listing.id,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(listing: listing, quantity: quantity));
    }

    notifyListeners();
  }

  void removeItem(String listingId) {
    _items.removeWhere((item) => item.listing.id == listingId);
    notifyListeners();
  }

  void updateQuantity(String listingId, int quantity) {
    final index = _items.indexWhere((item) => item.listing.id == listingId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void updateSlot(String listingId, String slotId) {
    final index = _items.indexWhere((item) => item.listing.id == listingId);
    if (index >= 0) {
      _items[index].selectedSlotId = slotId;
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
