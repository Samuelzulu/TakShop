class OrderCard extends StatelessWidget {
  final dynamic order; // Replace with your Order model

  const OrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 8)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildStatusBadge(order.status),
            ],
          ),

          const SizedBox(height: 12),

          // Order Details
          Text(
            order.listingTitle ?? 'Item',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.gray800,
            ),
          ),

          const SizedBox(height: 8),

          // Delivery Info
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.gray400,
              ),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(order.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: AppColors.gray400,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.deliveryLocationText ?? 'Location',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Price
          Text(
            'K${order.unitPrice.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color backgroundColor;
    Color textColor;

    switch (status.toUpperCase()) {
      case 'PENDING':
        backgroundColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        break;
      case 'CONFIRMED':
        backgroundColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        break;
      case 'OUT_FOR_DELIVERY':
        backgroundColor = AppColors.primaryBlue.withOpacity(0.1);
        textColor = AppColors.primaryBlue;
        break;
      case 'DELIVERED':
        backgroundColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        break;
      case 'CANCELLED':
        backgroundColor = AppColors.error.withOpacity(0.1);
        textColor = AppColors.error;
        break;
      default:
        backgroundColor = AppColors.gray100;
        textColor = AppColors.gray600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      return 'Today, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}