class UserModel {
  final String userId; // Add this
  final String upiId;
  final String mobile;
  final String email;
  final String shopName;
  final String ownerName;
  final String merchantId;
  final String uid;
  final String? imageUrl; // Add this line
  final String? storeaddress; // Add this line

  UserModel({
    required this.userId,
    required this.upiId,
    required this.mobile,
    required this.email,
    required this.shopName,
    required this.ownerName,
    required this.merchantId,
    required this.uid,
    required this.imageUrl, // Add this line
    required this.storeaddress, // Add this line
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'upiId': upiId,
      'mobile': mobile,
      'email': email,
      'shopName': shopName,
      'ownerName': ownerName,
      'merchantId': merchantId,
      'uid': uid,
      'imageUrl': imageUrl, // Include uid in the map
      'storeaddress': storeaddress, // Include uid in the map
    };
  }
}
