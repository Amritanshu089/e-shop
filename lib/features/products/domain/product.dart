class Product {
  final int id;
  final String title;
  final String category;
  final String description;
  final double price;
  final double discountPercentage;
  final double rating;
  final String brand;
  final String thumbnail;

  const Product({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.brand,
    required this.thumbnail,
  });
}