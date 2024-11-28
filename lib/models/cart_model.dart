import 'products_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  bool increaseQuantity() {
    if (quantity < product.stock) {
      quantity++;
      return true;
    }
    return false;
  }

  // Decrease quantity (down to 0)
  bool decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      return true;
    }
    return false;
  }

  double get priceAfterDiscount {
    return double.parse(
        (product.price - (product.price * (product.discountPercentage / 100)))
            .toStringAsFixed(2));
  }

  double get totalPrice {
    return priceAfterDiscount * quantity;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
      'price': priceAfterDiscount,
      'totalPrice': totalPrice,
    };
  }
}
