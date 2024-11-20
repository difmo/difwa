// item_model.dart

class Item {
  final String itemId;
  final String name;
  final String price;
  final String description;
  final List<String> imageUrls;
  final String userId;
  final String storeUserId;
  final String? merchantId;
  final String? category;
  final String? quantity;
  final String? tiffinName;
  final String? tiffinContents;

  Item({
    required this.itemId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrls,
    required this.userId,
    required this.storeUserId,
    required this.merchantId,
    this.category,
    this.quantity,
    this.tiffinName,
    this.tiffinContents,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'name': name,
      'price': price,
      'description': description,
      'imageUrls': imageUrls,
      'userId': userId,
      'storeUserId': storeUserId,
      'merchantId': merchantId,
      'category': category,
      'quantity': quantity,
      'tiffinName': tiffinName,
      'tiffinContents': tiffinContents,
    };
  }
}
