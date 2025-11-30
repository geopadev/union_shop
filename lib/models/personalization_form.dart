import 'package:union_shop/models/personalization_option.dart';

/// Model representing the complete personalization form
/// Manages all personalization options and calculates dynamic pricing
class PersonalizationForm {
  final String productName;
  final List<PersonalizationOption> options;
  final Map<String, double> sizePrices; // Pricing for different sizes

  PersonalizationForm({
    required this.productName,
    required this.options,
    required this.sizePrices,
  });

  /// Get a specific option by its ID
  PersonalizationOption? getOption(String id) {
    try {
      return options.firstWhere((opt) => opt.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Update an option's value
  void updateOption(String id, String value) {
    final option = getOption(id);
    if (option != null) {
      option.value = value;
    }
  }

  /// Calculate the total price based on the selected size
  double calculatePrice() {
    final sizeOption = getOption('size');
    if (sizeOption != null && sizeOption.value.isNotEmpty) {
      return sizePrices[sizeOption.value] ?? 0.0;
    }
    return 0.0;
  }

  /// Get formatted price string
  String get formattedPrice {
    final price = calculatePrice();
    return price > 0 ? '£${price.toStringAsFixed(2)}' : 'Select a size';
  }

  /// Check if all required options are filled
  bool get isComplete {
    return options.every((option) => option.value.isNotEmpty);
  }

  /// Get preview text showing current selections
  String getPreviewText() {
    final textOption = getOption('text');
    final fontOption = getOption('font');
    final colorOption = getOption('color');

    if (textOption == null || textOption.value.isEmpty) {
      return 'Enter your text to see preview';
    }

    String preview = 'Your Text: "${textOption.value}"';

    if (fontOption != null && fontOption.value.isNotEmpty) {
      preview += ' in ${fontOption.value}';
    }

    if (colorOption != null && colorOption.value.isNotEmpty) {
      preview += ' and ${colorOption.value} color';
    }

    return preview;
  }

  /// Create a default personalization form with standard options
  factory PersonalizationForm.createDefault() {
    return PersonalizationForm(
      productName: 'Personalized Text Item',
      options: [
        PersonalizationOption(
          id: 'text',
          type: PersonalizationOptionType.text,
          label: 'Your Text (max 20 characters)',
          value: '',
        ),
        PersonalizationOption(
          id: 'font',
          type: PersonalizationOptionType.dropdown,
          label: 'Font',
          options: ['Arial', 'Times New Roman', 'Courier'],
          value: '',
        ),
        PersonalizationOption(
          id: 'size',
          type: PersonalizationOptionType.dropdown,
          label: 'Size',
          options: ['S', 'M', 'L', 'XL'],
          value: '',
        ),
        PersonalizationOption(
          id: 'color',
          type: PersonalizationOptionType.dropdown,
          label: 'Text Color',
          options: ['Red', 'Blue', 'Black', 'White', 'Green'],
          value: '',
        ),
      ],
      sizePrices: {
        'S': 5.00,
        'M': 7.00,
        'L': 9.00,
        'XL': 11.00,
      },
    );
  }
}
