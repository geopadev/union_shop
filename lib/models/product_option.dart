/// Enum for types of product options
enum ProductOptionType {
  size,
  color,
  material,
}

/// Model representing a product option (size, color, material, etc.)
class ProductOption {
  final String id;
  final String name;
  final ProductOptionType type;
  final List<String> values;
  final bool required;

  const ProductOption({
    required this.id,
    required this.name,
    required this.type,
    required this.values,
    this.required = false,
  });

  /// Helper to get user-friendly label for option type
  String get typeLabel {
    switch (type) {
      case ProductOptionType.size:
        return 'Size';
      case ProductOptionType.color:
        return 'Color';
      case ProductOptionType.material:
        return 'Material';
    }
  }
}
