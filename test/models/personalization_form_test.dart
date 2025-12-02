import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/personalization_form.dart';
import 'package:union_shop/models/personalization_option.dart';

void main() {
  group('PersonalizationOption Tests', () {
    group('PersonalizationOption Creation', () {
      test('should create text option with required fields', () {
        final option = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
        );

        expect(option.id, 'text1');
        expect(option.type, PersonalizationOptionType.text);
        expect(option.label, 'Enter text');
        expect(option.options, null);
        expect(option.value, '');
      });

      test('should create dropdown option with options list', () {
        final option = PersonalizationOption(
          id: 'size',
          type: PersonalizationOptionType.dropdown,
          label: 'Size',
          options: ['S', 'M', 'L'],
        );

        expect(option.id, 'size');
        expect(option.type, PersonalizationOptionType.dropdown);
        expect(option.label, 'Size');
        expect(option.options, ['S', 'M', 'L']);
        expect(option.value, '');
      });

      test('should create color option', () {
        final option = PersonalizationOption(
          id: 'color',
          type: PersonalizationOptionType.color,
          label: 'Color',
          options: ['Red', 'Blue', 'Green'],
        );

        expect(option.type, PersonalizationOptionType.color);
        expect(option.options!.length, 3);
      });

      test('should create option with initial value', () {
        final option = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
          value: 'Initial',
        );

        expect(option.value, 'Initial');
      });

      test('should allow empty options list', () {
        final option = PersonalizationOption(
          id: 'custom',
          type: PersonalizationOptionType.dropdown,
          label: 'Custom',
          options: [],
        );

        expect(option.options, isNotNull);
        expect(option.options!.isEmpty, true);
      });
    });

    group('PersonalizationOption copyWith', () {
      test('should create copy with updated value', () {
        final original = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
          value: 'Original',
        );

        final copy = original.copyWith(value: 'Updated');

        expect(copy.id, 'text1');
        expect(copy.type, PersonalizationOptionType.text);
        expect(copy.label, 'Enter text');
        expect(copy.value, 'Updated');
        expect(original.value, 'Original'); // Original unchanged
      });

      test('should create copy with updated id', () {
        final original = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
        );

        final copy = original.copyWith(id: 'text2');

        expect(copy.id, 'text2');
        expect(original.id, 'text1');
      });

      test('should create copy with updated options list', () {
        final original = PersonalizationOption(
          id: 'size',
          type: PersonalizationOptionType.dropdown,
          label: 'Size',
          options: ['S', 'M'],
        );

        final copy = original.copyWith(options: ['S', 'M', 'L', 'XL']);

        expect(copy.options!.length, 4);
        expect(original.options!.length, 2);
      });

      test('should keep original values when no parameters provided', () {
        final original = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
          value: 'Value',
        );

        final copy = original.copyWith();

        expect(copy.id, original.id);
        expect(copy.type, original.type);
        expect(copy.label, original.label);
        expect(copy.value, original.value);
      });

      test('should update multiple fields simultaneously', () {
        final original = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Old Label',
          value: 'Old Value',
        );

        final copy = original.copyWith(
          label: 'New Label',
          value: 'New Value',
        );

        expect(copy.label, 'New Label');
        expect(copy.value, 'New Value');
        expect(copy.id, original.id);
      });
    });

    group('PersonalizationOption Value Mutation', () {
      test('should allow direct value modification', () {
        final option = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
          value: 'Initial',
        );

        option.value = 'Modified';

        expect(option.value, 'Modified');
      });

      test('should handle empty string value', () {
        final option = PersonalizationOption(
          id: 'text1',
          type: PersonalizationOptionType.text,
          label: 'Enter text',
          value: 'Something',
        );

        option.value = '';

        expect(option.value, '');
        expect(option.value.isEmpty, true);
      });
    });
  });

  group('PersonalizationForm Tests', () {
    group('PersonalizationForm Creation', () {
      test('should create form with required fields', () {
        final form = PersonalizationForm(
          productName: 'Test Product',
          options: [],
          sizePrices: {},
        );

        expect(form.productName, 'Test Product');
        expect(form.options.isEmpty, true);
        expect(form.sizePrices.isEmpty, true);
      });

      test('should create form with multiple options', () {
        final options = [
          PersonalizationOption(
            id: 'text',
            type: PersonalizationOptionType.text,
            label: 'Text',
          ),
          PersonalizationOption(
            id: 'size',
            type: PersonalizationOptionType.dropdown,
            label: 'Size',
            options: ['S', 'M', 'L'],
          ),
        ];

        final form = PersonalizationForm(
          productName: 'Product',
          options: options,
          sizePrices: {'S': 5.0, 'M': 7.0, 'L': 9.0},
        );

        expect(form.options.length, 2);
        expect(form.sizePrices.length, 3);
      });

      test('should create default form with factory method', () {
        final form = PersonalizationForm.createDefault();

        expect(form.productName, 'Personalized Text Item');
        expect(form.options.length, 4); // text, font, size, color
        expect(form.sizePrices.length, 4); // S, M, L, XL
        expect(form.sizePrices['S'], 5.00);
        expect(form.sizePrices['M'], 7.00);
        expect(form.sizePrices['L'], 9.00);
        expect(form.sizePrices['XL'], 11.00);
      });

      test('should create default form with correct option IDs', () {
        final form = PersonalizationForm.createDefault();

        expect(form.getOption('text'), isNotNull);
        expect(form.getOption('font'), isNotNull);
        expect(form.getOption('size'), isNotNull);
        expect(form.getOption('color'), isNotNull);
      });

      test('should create default form with correct option types', () {
        final form = PersonalizationForm.createDefault();

        expect(form.getOption('text')!.type, PersonalizationOptionType.text);
        expect(
            form.getOption('font')!.type, PersonalizationOptionType.dropdown);
        expect(
            form.getOption('size')!.type, PersonalizationOptionType.dropdown);
        expect(
            form.getOption('color')!.type, PersonalizationOptionType.dropdown);
      });

      test('should create default form with correct dropdown options', () {
        final form = PersonalizationForm.createDefault();

        expect(form.getOption('font')!.options,
            ['Arial', 'Times New Roman', 'Courier']);
        expect(form.getOption('size')!.options, ['S', 'M', 'L', 'XL']);
        expect(form.getOption('color')!.options,
            ['Red', 'Blue', 'Black', 'White', 'Green']);
      });
    });

    group('getOption Method', () {
      test('should return option when ID exists', () {
        final form = PersonalizationForm.createDefault();

        final textOption = form.getOption('text');

        expect(textOption, isNotNull);
        expect(textOption!.id, 'text');
      });

      test('should return null when ID does not exist', () {
        final form = PersonalizationForm.createDefault();

        final option = form.getOption('nonexistent');

        expect(option, null);
      });

      test('should return correct option among multiple options', () {
        final form = PersonalizationForm.createDefault();

        final sizeOption = form.getOption('size');
        final colorOption = form.getOption('color');

        expect(sizeOption!.id, 'size');
        expect(colorOption!.id, 'color');
        expect(sizeOption.label, 'Size');
        expect(colorOption.label, 'Text Color');
      });

      test('should handle empty string ID', () {
        final form = PersonalizationForm.createDefault();

        final option = form.getOption('');

        expect(option, null);
      });

      test('should handle case-sensitive IDs', () {
        final form = PersonalizationForm.createDefault();

        final option = form.getOption('TEXT'); // Uppercase

        expect(option, null); // Should not match 'text'
      });
    });

    group('updateOption Method', () {
      test('should update option value when ID exists', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello World');

        expect(form.getOption('text')!.value, 'Hello World');
      });

      test('should update multiple options independently', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'My Text');
        form.updateOption('font', 'Arial');
        form.updateOption('size', 'M');

        expect(form.getOption('text')!.value, 'My Text');
        expect(form.getOption('font')!.value, 'Arial');
        expect(form.getOption('size')!.value, 'M');
      });

      test('should do nothing when ID does not exist', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('nonexistent', 'value');

        // Should not throw error, just do nothing
        expect(form.getOption('nonexistent'), null);
      });

      test('should allow updating to empty string', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Something');
        form.updateOption('text', '');

        expect(form.getOption('text')!.value, '');
      });

      test('should handle special characters in value', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello & "World" <tag>');

        expect(form.getOption('text')!.value, 'Hello & "World" <tag>');
      });

      test('should update option value multiple times', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('size', 'S');
        expect(form.getOption('size')!.value, 'S');

        form.updateOption('size', 'M');
        expect(form.getOption('size')!.value, 'M');

        form.updateOption('size', 'XL');
        expect(form.getOption('size')!.value, 'XL');
      });
    });

    group('calculatePrice Method', () {
      test('should calculate price for size S', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'S');

        expect(form.calculatePrice(), 5.00);
      });

      test('should calculate price for size M', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'M');

        expect(form.calculatePrice(), 7.00);
      });

      test('should calculate price for size L', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'L');

        expect(form.calculatePrice(), 9.00);
      });

      test('should calculate price for size XL', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'XL');

        expect(form.calculatePrice(), 11.00);
      });

      test('should return 0 when no size selected', () {
        final form = PersonalizationForm.createDefault();

        expect(form.calculatePrice(), 0.0);
      });

      test('should return 0 when invalid size selected', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'XXL'); // Not in sizePrices map

        expect(form.calculatePrice(), 0.0);
      });

      test('should update price when size changes', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('size', 'S');
        expect(form.calculatePrice(), 5.00);

        form.updateOption('size', 'L');
        expect(form.calculatePrice(), 9.00);
      });

      test('should handle custom size prices', () {
        final form = PersonalizationForm(
          productName: 'Custom Product',
          options: [
            PersonalizationOption(
              id: 'size',
              type: PersonalizationOptionType.dropdown,
              label: 'Size',
              options: ['Small', 'Large'],
            ),
          ],
          sizePrices: {
            'Small': 10.50,
            'Large': 20.99,
          },
        );

        form.updateOption('size', 'Small');
        expect(form.calculatePrice(), 10.50);

        form.updateOption('size', 'Large');
        expect(form.calculatePrice(), 20.99);
      });

      test('should return 0 when size option does not exist', () {
        final form = PersonalizationForm(
          productName: 'No Size Product',
          options: [
            PersonalizationOption(
              id: 'text',
              type: PersonalizationOptionType.text,
              label: 'Text',
            ),
          ],
          sizePrices: {'S': 5.0},
        );

        expect(form.calculatePrice(), 0.0);
      });
    });

    group('formattedPrice Getter', () {
      test('should return formatted price for size S', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'S');

        expect(form.formattedPrice, '£5.00');
      });

      test('should return formatted price for size M', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'M');

        expect(form.formattedPrice, '£7.00');
      });

      test('should return formatted price for size L', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'L');

        expect(form.formattedPrice, '£9.00');
      });

      test('should return formatted price for size XL', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'XL');

        expect(form.formattedPrice, '£11.00');
      });

      test('should return placeholder when no size selected', () {
        final form = PersonalizationForm.createDefault();

        expect(form.formattedPrice, 'Select a size');
      });

      test('should handle decimal prices correctly', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [
            PersonalizationOption(
              id: 'size',
              type: PersonalizationOptionType.dropdown,
              label: 'Size',
              options: ['A'],
            ),
          ],
          sizePrices: {'A': 12.50},
        );

        form.updateOption('size', 'A');

        expect(form.formattedPrice, '£12.50');
      });

      test('should format price with two decimal places', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [
            PersonalizationOption(
              id: 'size',
              type: PersonalizationOptionType.dropdown,
              label: 'Size',
              options: ['A'],
            ),
          ],
          sizePrices: {'A': 10.0},
        );

        form.updateOption('size', 'A');

        expect(form.formattedPrice, '£10.00');
      });

      test('should return placeholder for invalid size', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('size', 'Invalid');

        expect(form.formattedPrice, 'Select a size');
      });
    });

    group('isComplete Getter', () {
      test('should return false when all options are empty', () {
        final form = PersonalizationForm.createDefault();

        expect(form.isComplete, false);
      });

      test('should return false when some options are empty', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello');
        form.updateOption('font', 'Arial');
        // size and color still empty

        expect(form.isComplete, false);
      });

      test('should return true when all options are filled', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello');
        form.updateOption('font', 'Arial');
        form.updateOption('size', 'M');
        form.updateOption('color', 'Red');

        expect(form.isComplete, true);
      });

      test('should return false if any option becomes empty', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello');
        form.updateOption('font', 'Arial');
        form.updateOption('size', 'M');
        form.updateOption('color', 'Red');

        expect(form.isComplete, true);

        form.updateOption('size', ''); // Clear size

        expect(form.isComplete, false);
      });

      test('should return true for form with no options', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [],
          sizePrices: {},
        );

        expect(form.isComplete, true); // No options means all are complete
      });

      test('should handle single option form', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [
            PersonalizationOption(
              id: 'text',
              type: PersonalizationOptionType.text,
              label: 'Text',
            ),
          ],
          sizePrices: {},
        );

        expect(form.isComplete, false);

        form.updateOption('text', 'Value');

        expect(form.isComplete, true);
      });
    });

    group('getPreviewText Method', () {
      test('should return placeholder when text is empty', () {
        final form = PersonalizationForm.createDefault();

        expect(form.getPreviewText(), 'Enter your text to see preview');
      });

      test('should return text only when other options empty', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Hello');

        expect(form.getPreviewText(), 'Your Text: "Hello"');
      });

      test('should return text with font when both provided', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Hello');
        form.updateOption('font', 'Arial');

        expect(form.getPreviewText(), 'Your Text: "Hello" in Arial');
      });

      test('should return text with color when both provided', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Hello');
        form.updateOption('color', 'Red');

        expect(form.getPreviewText(), 'Your Text: "Hello" and Red color');
      });

      test('should return complete preview with all options', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Hello World');
        form.updateOption('font', 'Times New Roman');
        form.updateOption('color', 'Blue');

        expect(
          form.getPreviewText(),
          'Your Text: "Hello World" in Times New Roman and Blue color',
        );
      });

      test('should handle text with font but no color', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Test');
        form.updateOption('font', 'Courier');

        expect(form.getPreviewText(), 'Your Text: "Test" in Courier');
      });

      test('should handle special characters in text', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Hello & "World"');

        expect(form.getPreviewText(), 'Your Text: "Hello & "World""');
      });

      test('should handle single character text', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'A');
        form.updateOption('font', 'Arial');
        form.updateOption('color', 'Red');

        expect(form.getPreviewText(), 'Your Text: "A" in Arial and Red color');
      });

      test('should handle maximum length text', () {
        final form = PersonalizationForm.createDefault();
        final maxText = 'A' * 20;
        form.updateOption('text', maxText);
        form.updateOption('font', 'Arial');

        expect(form.getPreviewText(), 'Your Text: "$maxText" in Arial');
      });

      test('should return placeholder if text option missing', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [
            PersonalizationOption(
              id: 'font',
              type: PersonalizationOptionType.dropdown,
              label: 'Font',
              options: ['Arial'],
            ),
          ],
          sizePrices: {},
        );

        expect(form.getPreviewText(), 'Enter your text to see preview');
      });

      test('should update preview when text changes', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'First');
        expect(form.getPreviewText(), 'Your Text: "First"');

        form.updateOption('text', 'Second');
        expect(form.getPreviewText(), 'Your Text: "Second"');
      });
    });

    group('Complex Scenarios and Edge Cases', () {
      test('should handle complete workflow from empty to filled', () {
        final form = PersonalizationForm.createDefault();

        expect(form.isComplete, false);
        expect(form.calculatePrice(), 0.0);
        expect(form.getPreviewText(), 'Enter your text to see preview');

        form.updateOption('text', 'Union Shop');
        expect(form.isComplete, false);
        expect(form.getPreviewText(), 'Your Text: "Union Shop"');

        form.updateOption('font', 'Arial');
        expect(form.isComplete, false);

        form.updateOption('size', 'M');
        expect(form.calculatePrice(), 7.00);
        expect(form.formattedPrice, '£7.00');

        form.updateOption('color', 'Blue');
        expect(form.isComplete, true);
        expect(
          form.getPreviewText(),
          'Your Text: "Union Shop" in Arial and Blue color',
        );
      });

      test('should handle form with all sizes', () {
        final form = PersonalizationForm.createDefault();

        final sizes = ['S', 'M', 'L', 'XL'];
        final prices = [5.00, 7.00, 9.00, 11.00];

        for (int i = 0; i < sizes.length; i++) {
          form.updateOption('size', sizes[i]);
          expect(form.calculatePrice(), prices[i]);
        }
      });

      test('should handle form with all fonts', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Test');

        final fonts = ['Arial', 'Times New Roman', 'Courier'];

        for (final font in fonts) {
          form.updateOption('font', font);
          expect(form.getPreviewText(), 'Your Text: "Test" in $font');
        }
      });

      test('should handle form with all colors', () {
        final form = PersonalizationForm.createDefault();
        form.updateOption('text', 'Test');

        final colors = ['Red', 'Blue', 'Black', 'White', 'Green'];

        for (final color in colors) {
          form.updateOption('color', color);
          expect(form.getPreviewText(), 'Your Text: "Test" and $color color');
        }
      });

      test('should maintain option independence', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Text1');
        form.updateOption('font', 'Arial');

        form.updateOption('text', 'Text2');

        expect(form.getOption('font')!.value, 'Arial'); // Font unchanged
      });

      test('should handle resetting form values', () {
        final form = PersonalizationForm.createDefault();

        form.updateOption('text', 'Hello');
        form.updateOption('font', 'Arial');
        form.updateOption('size', 'M');
        form.updateOption('color', 'Red');

        expect(form.isComplete, true);

        // Reset all
        form.updateOption('text', '');
        form.updateOption('font', '');
        form.updateOption('size', '');
        form.updateOption('color', '');

        expect(form.isComplete, false);
        expect(form.calculatePrice(), 0.0);
        expect(form.getPreviewText(), 'Enter your text to see preview');
      });

      test('should handle very long product name', () {
        final longName = 'A' * 200;
        final form = PersonalizationForm(
          productName: longName,
          options: [],
          sizePrices: {},
        );

        expect(form.productName.length, 200);
      });

      test('should handle empty product name', () {
        final form = PersonalizationForm(
          productName: '',
          options: [],
          sizePrices: {},
        );

        expect(form.productName, '');
      });

      test('should handle large number of options', () {
        final options = List.generate(
          10,
          (i) => PersonalizationOption(
            id: 'option$i',
            type: PersonalizationOptionType.text,
            label: 'Option $i',
          ),
        );

        final form = PersonalizationForm(
          productName: 'Product',
          options: options,
          sizePrices: {},
        );

        expect(form.options.length, 10);
        expect(form.getOption('option5'), isNotNull);
      });

      test('should handle fractional prices', () {
        final form = PersonalizationForm(
          productName: 'Product',
          options: [
            PersonalizationOption(
              id: 'size',
              type: PersonalizationOptionType.dropdown,
              label: 'Size',
              options: ['A'],
            ),
          ],
          sizePrices: {'A': 5.99},
        );

        form.updateOption('size', 'A');

        expect(form.calculatePrice(), 5.99);
        expect(form.formattedPrice, '£5.99');
      });

      test('should handle zero price', () {
        final form = PersonalizationForm(
          productName: 'Free Product',
          options: [
            PersonalizationOption(
              id: 'size',
              type: PersonalizationOptionType.dropdown,
              label: 'Size',
              options: ['Free'],
            ),
          ],
          sizePrices: {'Free': 0.0},
        );

        form.updateOption('size', 'Free');

        expect(form.calculatePrice(), 0.0);
        expect(form.formattedPrice, 'Select a size');
      });
    });
  });
}
