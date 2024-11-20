import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner/utils/product_dialogbox_utils.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import '../routes/app_routes.dart';
import 'Product_Controller/Product_Controller.dart';
import 'Product_Delet_dialog.dart';
import 'Store_item_edit.dart';

class ProductScreen extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showExitConfirmationDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Products',
            style: TextStyle(color: Colors.black,
                fontWeight: FontWeight.bold, fontFamily: 'Nexa'),
          ),
          elevation: 0,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.items.isEmpty) {
            return const Center(child: Text('No items available.'));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: controller.items.map((item) {
                  final itemData = item?.data() as Map<String, dynamic>;
                  final itemId = item?.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10), // Space between rows
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white, // Background color
                        borderRadius: BorderRadius.circular(10), // Border radius to round the corners
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.25), // Border color
                          width: 1, // Border width
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.0),
                            blurRadius: 0,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: itemData['imageUrls'] != null && (itemData['imageUrls'] as List).isNotEmpty
                              ? Image.network(
                            itemData['imageUrls'][0], // Display first image
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                          )
                              : Container(
                            width: 60,
                            height: 60,
                            color: AppColors.inactive.withOpacity(0.5),
                            child: const Center(child: Text('No Image')),
                          ),
                        ),
                        title: Text(
                          itemData['name'] ?? 'No Name',
                          style: AppStyle.heading24Black,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: ₹${itemData['price'] ?? 'N/A'}',
                                style: AppStyle.unSelectedTabStyle),
                            const SizedBox(height: 5),
                            Text(
                              itemData['description'] ?? 'No Description',
                              style: AppStyle.heading3Black,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.myGreen.withOpacity(0.8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.mywhite),
                                onPressed: () {
                                  final List<String> imageUrls = itemData['imageUrls'] != null
                                      ? List<String>.from(itemData['imageUrls'])
                                      : [];
                                  Get.to(() => EditItemPage(
                                    itemId: itemId,
                                    name: itemData['name'] ?? '',
                                    price: itemData['price'] ?? '',
                                    description: itemData['description'] ?? '',
                                    imageUrls: imageUrls,
                                  ));
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.8),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: AppColors.mywhite),
                                onPressed: () {
                                  showDeleteConfirmationDialog(
                                    context,
                                    itemId,
                                        () => controller.deleteItem(itemId),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AppRoutes.additem);
          },
          child: Icon(Icons.add, color: AppColors.mywhite),
          tooltip: 'Add Item',
          backgroundColor: AppColors.primary,
        ),
      ),
    );
  }
}
