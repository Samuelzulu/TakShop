class ListingCard extends StatelessWidget {
  final dynamic listing; // Replace with your Listing model

  const ListingCard({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to listing detail
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentOrange.withOpacity(0.2),
                    AppColors.accentOrange.withOpacity(0.3),
                  ],
                ),
              ),
              child: listing.photoUrls.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  listing.photoUrls.first,
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Icon(
                  _getCategoryIcon(listing.category),
                  size: 40,
                  color: AppColors.accentOrange,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.gray900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    listing.sellerName ?? 'Seller',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.gray600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Rating
                      if (listing.rating != null) ...[
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: AppColors.accentOrange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          listing.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${listing.reviewCount ?? 0})',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.gray400,
                          ),
                        ),
                        const Spacer(),
                      ],

                      // Price
                      Text(
                        'K${listing.price.toStringAsFixed(0)}',
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
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'books':
        return Icons.book;
      case 'clothes':
        return Icons.checkroom;
      case 'accessories':
        return Icons.watch;
      default:
        return Icons.shopping_bag;
    }
  }
}