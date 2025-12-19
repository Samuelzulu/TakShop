class RatingWidget extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(
              Icons.star,
              size: size,
              color: AppColors.accentOrange,
            );
          } else if (index < rating) {
            return Icon(
              Icons.star_half,
              size: size,
              color: AppColors.accentOrange,
            );
          } else {
            return Icon(
              Icons.star_border,
              size: size,
              color: AppColors.accentOrange,
            );
          }
        }),

        const SizedBox(width: 4),

        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: size * 0.9,
            fontWeight: FontWeight.w600,
          ),
        ),

        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: size * 0.75,
              color: AppColors.gray400,
            ),
          ),
        ],
      ],
    );
  }
}