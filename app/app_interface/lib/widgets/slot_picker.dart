// ============================================================================
// SLOT PICKER WIDGET
// widgets/slot_picker.dart
// ============================================================================

class SlotPicker extends StatefulWidget {
  final Function(String) onSlotSelected;
  final String sellerId;

  const SlotPicker({
    super.key,
    required this.onSlotSelected,
    required this.sellerId,
  });

  @override
  State<SlotPicker> createState() => _SlotPickerState();
}

class _SlotPickerState extends State<SlotPicker> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlotId;
  List<dynamic> _slots = []; // Replace with your SellerSlot model
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Fetch slots from your service
    // final slots = await slotService.getSlotsForSeller(
    //   sellerId: widget.sellerId,
    //   date: _selectedDate,
    // );

    setState(() {
      // _slots = slots;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Delivery Time',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        const SizedBox(height: 16),

        // Date Selector
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index));
              final isSelected = _selectedDate.day == date.day &&
                  _selectedDate.month == date.month;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });
                  _loadSlots();
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
                        _getDayName(date),
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
                      Text(
                        _getMonthName(date),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.white : AppColors.gray600,
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

        // Time Slots
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (_slots.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No available slots for this date',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _slots.length,
            itemBuilder: (context, index) {
              final slot = _slots[index];
              final isSelected = _selectedSlotId == slot.id;
              final isAvailable = slot.bookedCount < slot.capacity;

              return GestureDetector(
                onTap: isAvailable
                    ? () {
                  setState(() {
                    _selectedSlotId = slot.id;
                  });
                  widget.onSlotSelected(slot.id);
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
                          '${_formatTime(slot.startTime)} - ${_formatTime(slot.endTime)}',
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
                            ? '${slot.capacity - slot.bookedCount} spots left'
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
            },
          ),
      ],
    );
  }

  String _getDayName(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  String _getMonthName(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}