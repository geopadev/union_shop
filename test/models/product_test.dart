import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product.dart';
import 'package:union_shop/models/product_option.dart';

void main() {
  group('Product Model Tests', () {
    // Test data setup
    final sizeOption = ProductOption(
      id: 'size1',
      name: 'Size',
      type: ProductOptionType.size,
      values: ['S', 'M', 'L', 'XL'],
      required: true,
    );

    final colorOption = ProductOption(
      id: 'color1',
      name: 'Color',
      type: ProductOptionType.color,
      values: ['Red', 'Blue', 'Green'],
      required: false,
    );

    final materialOption = ProductOption(
      id: 'material1',
      name: 'Material',
      type: ProductOptionType.material,
      values: ['Cotton', 'Polyester'],
      required: false,
    );

    group('Product Creation', () {
      test('should create product with required fields only', () {
        final product = Product(
          id: 'prod1',
          title: 'Test Product',
          price: '£25.00',
          imageUrl: 'https://example.com/image.jpg',
          description: 'A test product',
        );

        expect(product.id, 'prod1');
        expect(product.title, 'Test Product');
        expect(product.price, '£25.00');
        expect(product.imageUrl, 'https://example.com/image.jpg');
        expect(product.description, 'A test product');
        expect(product.isOnSale, false);
        expect(product.originalPrice, null);
        expect(product.options, null);
        expect(product.collectionIds, null);
      });

      test('should create product with all fields', () {
        final product = Product(
          id: 'prod1',
          title: 'Sale Product',
          price: '£20.00',
          imageUrl: 'https://example.com/image.jpg',
          description: 'A product on sale',
          isOnSale: true,
          originalPrice: '£30.00',
          options: [sizeOption, colorOption],
          collectionIds: ['col1', 'col2'],
        );

        expect(product.id, 'prod1');
        expect(product.title, 'Sale Product');
        expect(product.price, '£20.00');
        expect(product.isOnSale, true);
        expect(product.originalPrice, '£30.00');
        expect(product.options!.length, 2);
        expect(product.collectionIds!.length, 2);
      });

      test('should create product with single option', () {
        final product = Product(
          id: 'prod1',
          title: 'Simple Product',
          price: '£15.00',
          imageUrl: 'https://example.com/image.jpg',
          description: 'Product with one option',
          options: [sizeOption],
        );

        expect(product.options!.length, 1);
        expect(product.options!.first.type, ProductOptionType.size);
      });

      test('should create product with empty options list', () {
        final product = Product(
          id: 'prod1',
          title: 'Simple Product',
          price: '£15.00',
          imageUrl: 'https://example.com/image.jpg',
          description: 'Product with empty options',
          options: [],
        );

        expect(product.options, isNotNull);
        expect(product.options!.isEmpty, true);
      });

      test('should create product with empty collectionIds list', () {
        final product = Product(
          id: 'prod1',
          title: 'Simple Product',
          price: '£15.00',
          imageUrl: 'https://example.com/image.jpg',
          description: 'Product with no collections',
          collectionIds: [],
        );

        expect(product.collectionIds, isNotNull);
        expect(product.collectionIds!.isEmpty, true);
      });
    });

    group('hasOptions Getter', () {
      test('should return true when product has options', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption],
        );

        expect(product.hasOptions, true);
      });

      test('should return false when options is null', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
        );

        expect(product.hasOptions, false);
      });

      test('should return false when options is empty', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [],
        );

        expect(product.hasOptions, false);
      });

      test('should return true when product has multiple options', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption, colorOption, materialOption],
        );

        expect(product.hasOptions, true);
        expect(product.options!.length, 3);
      });
    });

    group('hasOptionType Method', () {
      test('should return true when product has specific option type', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption, colorOption],
        );

        expect(product.hasOptionType(ProductOptionType.size), true);
        expect(product.hasOptionType(ProductOptionType.color), true);
      });

      test('should return false when product does not have option type', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption],
        );

        expect(product.hasOptionType(ProductOptionType.color), false);
        expect(product.hasOptionType(ProductOptionType.material), false);
      });

      test('should return false when options is null', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
        );

        expect(product.hasOptionType(ProductOptionType.size), false);
        expect(product.hasOptionType(ProductOptionType.color), false);
        expect(product.hasOptionType(ProductOptionType.material), false);
      });

      test('should return false when options is empty', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [],
        );

        expect(product.hasOptionType(ProductOptionType.size), false);
      });
    });

    group('getOptionByType Method', () {
      test('should return option when type exists', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption, colorOption],
        );

        final option = product.getOptionByType(ProductOptionType.size);
        expect(option, isNotNull);
        expect(option!.id, 'size1');
        expect(option.type, ProductOptionType.size);
      });

      test('should return correct option when multiple options exist', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption, colorOption, materialOption],
        );

        final sizeOpt = product.getOptionByType(ProductOptionType.size);
        final colorOpt = product.getOptionByType(ProductOptionType.color);
        final materialOpt = product.getOptionByType(ProductOptionType.material);

        expect(sizeOpt!.id, 'size1');
        expect(colorOpt!.id, 'color1');
        expect(materialOpt!.id, 'material1');
      });

      test('should return null when option type does not exist', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [sizeOption],
        );

        final option = product.getOptionByType(ProductOptionType.color);
        expect(option, null);
      });

      test('should return null when options is null', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
        );

        final option = product.getOptionByType(ProductOptionType.size);
        expect(option, null);
      });

      test('should return null when options is empty', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [],
        );

        final option = product.getOptionByType(ProductOptionType.size);
        expect(option, null);
      });
    });

    group('displayPrice Getter', () {
      test('should return price when product is not on sale', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£25.00',
          imageUrl: 'url',
          description: 'desc',
        );

        expect(product.displayPrice, '£25.00');
      });

      test('should return sale price when product is on sale', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£30.00',
        );

        expect(product.displayPrice, '£20.00');
      });

      test('should always return current price regardless of sale status', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£15.99',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£25.99',
        );

        expect(product.displayPrice, '£15.99');
        expect(product.displayPrice, product.price);
      });
    });

    group('savings Getter', () {
      test('should calculate savings correctly for whole pounds', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£30.00',
        );

        expect(product.savings, 'Save £10.00');
      });

      test('should calculate savings correctly with pence', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£19.99',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£29.99',
        );

        expect(product.savings, 'Save £10.00');
      });

      test('should calculate savings with decimal precision', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£17.50',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£25.75',
        );

        expect(product.savings, 'Save £8.25');
      });

      test('should return null when product is not on sale', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: false,
        );

        expect(product.savings, null);
      });

      test('should return null when originalPrice is null', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
        );

        expect(product.savings, null);
      });

      test('should return null when originalPrice is null even if on sale', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: null,
        );

        expect(product.savings, null);
      });

      test('should handle invalid price format gracefully', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: 'invalid',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£30.00',
        );

        expect(product.savings, null);
      });

      test('should handle invalid original price format gracefully', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: 'invalid',
        );

        expect(product.savings, null);
      });

      test('should handle missing pound symbol in price', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '30.00',
        );

        expect(product.savings, 'Save £10.00');
      });

      test('should calculate small savings correctly', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£24.50',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£25.00',
        );

        expect(product.savings, 'Save £0.50');
      });

      test('should calculate large savings correctly', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£50.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£150.00',
        );

        expect(product.savings, 'Save £100.00');
      });
    });

    group('primaryCollectionId Getter', () {
      test('should return first collection ID when multiple exist', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          collectionIds: ['col1', 'col2', 'col3'],
        );

        expect(product.primaryCollectionId, 'col1');
      });

      test('should return only collection ID when one exists', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          collectionIds: ['col1'],
        );

        expect(product.primaryCollectionId, 'col1');
      });

      test('should return null when collectionIds is null', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
        );

        expect(product.primaryCollectionId, null);
      });

      test('should return null when collectionIds is empty', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          collectionIds: [],
        );

        expect(product.primaryCollectionId, null);
      });
    });

    group('Edge Cases and Complex Scenarios', () {
      test('should handle product with all features combined', () {
        final product = Product(
          id: 'prod_complex',
          title: 'Complex Product',
          price: '£45.99',
          imageUrl: 'https://example.com/complex.jpg',
          description: 'A product with all features',
          isOnSale: true,
          originalPrice: '£65.99',
          options: [sizeOption, colorOption, materialOption],
          collectionIds: ['col1', 'col2', 'col3'],
        );

        expect(product.hasOptions, true);
        expect(product.options!.length, 3);
        expect(product.hasOptionType(ProductOptionType.size), true);
        expect(product.getOptionByType(ProductOptionType.color), isNotNull);
        expect(product.displayPrice, '£45.99');
        expect(product.savings, 'Save £20.00');
        expect(product.primaryCollectionId, 'col1');
      });

      test('should handle product with special characters in fields', () {
        final product = Product(
          id: 'prod_special',
          title: 'Product & More "Special"',
          price: '£12.50',
          imageUrl: 'https://example.com/image.jpg?size=large&quality=high',
          description: 'Description with special chars: <>&"\'',
        );

        expect(product.title, 'Product & More "Special"');
        expect(product.description, 'Description with special chars: <>&"\'');
      });

      test('should handle empty string values', () {
        final product = Product(
          id: '',
          title: '',
          price: '',
          imageUrl: '',
          description: '',
        );

        expect(product.id, '');
        expect(product.title, '');
        expect(product.price, '');
        expect(product.displayPrice, '');
      });

      test('should handle very long values', () {
        final longDescription = 'A' * 1000;
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: longDescription,
        );

        expect(product.description.length, 1000);
      });

      test('should handle product with only required options', () {
        final requiredSizeOption = ProductOption(
          id: 'size1',
          name: 'Size',
          type: ProductOptionType.size,
          values: ['S', 'M', 'L'],
          required: true,
        );

        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£10.00',
          imageUrl: 'url',
          description: 'desc',
          options: [requiredSizeOption],
        );

        expect(product.hasOptions, true);
        expect(product.options!.first.required, true);
      });

      test('should handle zero price correctly', () {
        final product = Product(
          id: 'prod1',
          title: 'Free Product',
          price: '£0.00',
          imageUrl: 'url',
          description: 'desc',
        );

        expect(product.price, '£0.00');
        expect(product.displayPrice, '£0.00');
      });

      test('should handle sale with same price as original', () {
        final product = Product(
          id: 'prod1',
          title: 'Product',
          price: '£20.00',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£20.00',
        );

        expect(product.savings, 'Save £0.00');
      });

      test('should handle very large price values', () {
        final product = Product(
          id: 'prod1',
          title: 'Expensive Product',
          price: '£9999.99',
          imageUrl: 'url',
          description: 'desc',
          isOnSale: true,
          originalPrice: '£19999.99',
        );

        expect(product.savings, 'Save £10000.00');
      });
    });
  });
}
