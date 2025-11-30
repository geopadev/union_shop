/// Model representing a single personalization option in the form
/// Can be a text input, dropdown selection, or color picker
class PersonalizationOption {
  final String id; // Unique identifier for the option
  final PersonalizationOptionType type;
  final String label; // Display label for the option
  final List<String>?
      options; // Available choices for dropdown (null for text input)
  String value; // Current selected/entered value

  PersonalizationOption({
    required this.id,
    required this.type,
    required this.label,
    this.options,
    this.value = '',
  });

  /// Create a copy of this option with updated value
  PersonalizationOption copyWith({
    String? id,
    PersonalizationOptionType? type,
    String? label,
    List<String>? options,
    String? value,
  }) {
    return PersonalizationOption(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      options: options ?? this.options,
      value: value ?? this.value,
    );
  }
}

/// Enum defining the types of personalization options
enum PersonalizationOptionType {
  text, // Text input field
  dropdown, // Dropdown selection
  color, // Color picker
}
