class CheckoutScreen extends StatefulWidget {
  final Listing listing;
  final int quantity;

  const CheckoutScreen({
    super.key,
    required this.listing,
    required this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String? _selectedLocationId;
  String? _selectedLocationText;
  String? _selectedSlotId;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _customLocationController = TextEditingController();

  List<dynamic> _deliveryLocations = [];
  List<dynamic> _availableSlots = [];
  bool _isLoadingLocations = true;
  bool _isLoadingSlots = true;
  bool _isPlacingOrder = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadDeliveryLocations();
    _loadAvailableSlots();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customLocationController.dispose();
    super.dispose();
  }

  Future<void> _loadDeliveryLocations() async {
    // TODO: Load from your service
    setState(() {
      _isLoadingLocations = false;
    });
  }

  Future<void> _loadAvailableSlots() async {
    setState(() {
      _isLoadingSlots = true;
    });

    // TODO: Load slots from your service
    // final slots = await slotService.getSlotsForSeller(
    //   sellerId: widget.listing.sellerId,
    //   date: _selectedDate,
    // );

    setState(() {
      // _availableSlots = slots;
      _isLoadingSlots = false;
    });
  }

  Future<void> _placeOrder() async {
    if (_selectedSlotId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a delivery time slot'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedLocationId == null && _customLocationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a delivery location'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // TODO: Call your order service
      // await orderService.createOrder(
      //   listingId: widget.listing.id,
      //   quantity: widget.quantity,
      //   slotId: _selectedSlotId!,
      //   deliveryLocationId: _selectedLocationId,
      //   deliveryLocationText: _customLocationController.text.isEmpty
      //       ? _selectedLocationText
      //       : _customLocationController.text,
      //   notes: _notesController.text,
      // );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Navigate to orders screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPlacingOrder = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.listing.price * widget.quantity;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Order Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: widget.listing.photoUrls.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: widget.listing.photoUrls.first,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(Icons.shopping_bag),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.listing.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Quantity: ${widget.quantity}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.gray600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      'K${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Delivery Location
          const Text(
            'Delivery Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (_isLoadingLocations)
            const Center(child: CircularProgressIndicator())
          else ...[
            ..._deliveryLocations.map((location) {
              final isSelected = _selectedLocationId == location.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedLocationId = location.id;
                    _selectedLocationText = location.name;
                    _customLocationController.clear();
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.gray200,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: isSelected
                            ? AppColors.primaryBlue
                            : AppColors.gray400,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          location.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : AppColors.gray800,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primaryBlue,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),

            // Custom Location
            const SizedBox(height: 8),
            TextField(
              controller: _customLocationController,
              decoration: const InputDecoration(
                labelText: 'Or enter custom location',
                hintText: 'e.g., Room 12, Block C',
                prefixIcon: Icon(Icons.edit_location),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedLocationId = null;
                  });
                }
              },
            ),
          ],

          const SizedBox(height: 24),

          // Delivery Time Slot
          const Text(
            'Select Delivery Time',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          // Date Selector (simplified version)
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = DateTime.now().add(Duration(days: index));
                final isSelected = _selectedDate.day == date.day;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    _loadAvailableSlots();
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryBlue : AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryBlue : AppColors.gray200,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][date.weekday % 7],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? AppColors.white : AppColors.gray600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? AppColors.white : AppColors.gray900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          if (_isLoadingSlots)
            const Center(child: CircularProgressIndicator())
          else if (_availableSlots.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('No available slots for this date'),
              ),
            )
          else
            ..._availableSlots.map((slot) {
              final isSelected = _selectedSlotId == slot.id;
              final isAvailable = slot.bookedCount < slot.capacity;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                  setState(() {
                    _selectedSlotId = slot.id;
                  });
                }
                    : null,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryBlue.withOpacity(0.1)
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryBlue
                          : AppColors.gray200,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: isAvailable
                            ? (isSelected ? AppColors.primaryBlue : AppColors.gray600)
                            : AppColors.gray400,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Time Slot', // Format your time here
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isAvailable
                                ? (isSelected ? AppColors.primaryBlue : AppColors.gray900)
                                : AppColors.gray400,
                          ),
                        ),
                      ),
                      Text(
                        isAvailable
                            ? '${slot.capacity - slot.bookedCount} left'
                            : 'Full',
                        style: TextStyle(
                          fontSize: 12,
                          color: isAvailable ? AppColors.gray600 : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

          const SizedBox(height: 24),

          // Notes
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Additional Notes (Optional)',
              hintText: 'e.g., Call when you arrive',
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),

      // Place Order Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'K${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              CustomButton(
                text: 'Place Order',
                icon: Icons.check_circle,
                onPressed: _isPlacingOrder ? null : _placeOrder,
                isLoading: _isPlacingOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}