import 'package:flutter/material.dart';
import 'package:union_shop/models/product_option.dart';

/// Widget that displays option selectors (dropdowns) for a product
/// Handles size, color, and material selections
class ProductOptionsSelector extends StatefulWidget {
  final List<ProductOption> options;
  final Function(Map<String, String>) onOptionsChanged;
  final Map<String, String>? initialSelections;

  const ProductOptionsSelector({
    super.key,
    required this.options,
    required this.onOptionsChanged,
    this.initialSelections,
  });

  @override
  State<ProductOptionsSelector> createState() => _ProductOptionsSelectorState();
}

class _ProductOptionsSelectorState extends State<ProductOptionsSelector> {
  late Map<String, String> _selections;

  @override
  void initState() {
    super.initState();
    // Initialize selections from initial values or empty
    _selections = Map.from(widget.initialSelections ?? {});
  }

  void _updateSelection(String optionId, String value) {
    setState(() {
      _selections[optionId] = value;
    });
    widget.onOptionsChanged(_selections);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildOptionSelector(option),
        );
      }).toList(),
    );
  }

  Widget _buildOptionSelector(ProductOption option) {
    final currentValue = _selections[option.id];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Text(
              option.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (option.required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),

        // Dropdown based on option type
        if (option.type == ProductOptionType.size ||
            option.type == ProductOptionType.material)
          _buildDropdown(option, currentValue)
        else if (option.type == ProductOptionType.color)
          _buildColorSelector(option, currentValue),
      ],
    );
  }

  Widget _buildDropdown(ProductOption option, String? currentValue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          key: Key('option_${option.id}_dropdown'),
          value: currentValue,
          hint: Text('Select ${option.name}'),
          isExpanded: true,
          items: option.values.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              _updateSelection(option.id, newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildColorSelector(ProductOption option, String? currentValue) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: option.values.map((String colorName) {
        final isSelected = currentValue == colorName;
        final color = _getColorFromName(colorName);

        return GestureDetector(
          key: Key('option_${option.id}_$colorName'),
          onTap: () => _updateSelection(option.id, colorName),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: isSelected ? const Color(0xFF4d2963) : Colors.grey[300]!,
                width: isSelected ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }

  /// Helper method to convert color name to Color object
  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      case 'orange':
        return Colors.orange;
      case 'pink':
        return Colors.pink;
      case 'grey':
      case 'gray':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
