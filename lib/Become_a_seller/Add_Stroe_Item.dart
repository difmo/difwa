import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_color.dart';
import '../config/app_styles.dart';
import 'Controller/Item_Controller.dart';
import 'Models/Add_Store_Item.dart';


class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}
class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tiffinNameController = TextEditingController();
  final _customContentsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];
  bool _isLoading = false;
  String? _selectedCategory;
  final List<String> _categories = ['Tiffin', 'Water'];
  String? _selectedQuantity;
  final List<String> _quantities = ['500ml', '1L', '2L', '5L', '10L', '15L', '20L'];
  List<String> _tiffinContents = [];
  final ItemController _itemController = ItemController();
  String? storeUserId;
  String? merchantId;
  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }
  Future<void> _fetchUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      storeUserId = currentUser.uid;
      QuerySnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('difwastores')
          .where('userId', isEqualTo: storeUserId)
          .get();
      if (storeSnapshot.docs.isNotEmpty) {
        merchantId = storeSnapshot.docs.first.id;
      }
    }
    setState(() {});
  }
  Future<void> uploadImages() async {
    if (_images == null || _images!.isEmpty) return;
    setState(() {
      _isLoading = true;
    });
    try {
      List<String> downloadUrls = [];
      for (var image in _images!) {
        String downloadUrl = await _itemController.uploadImage(File(image.path));
        downloadUrls.add(downloadUrl);
      }
      Item newItem = Item(
        itemId: "",
        name: _nameController.text,
        price: _priceController.text,
        description: _descriptionController.text,
        imageUrls: downloadUrls,
        userId: storeUserId ?? '',
        storeUserId: storeUserId ?? '',
        merchantId: merchantId ?? '',
        category: _selectedCategory,
        quantity: _selectedQuantity,
        tiffinName: _selectedCategory == 'Tiffin' ? _tiffinNameController.text : null,
        tiffinContents: _tiffinContents.isNotEmpty ? _tiffinContents.join(', ') : null,
      );
      await _itemController.addItem(newItem);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Item Added')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages != null) {
      setState(() {
        _images = selectedImages;
      });
    }
  }
  void _addCustomContent() {
    final customContent = _customContentsController.text.trim();
    if (customContent.isNotEmpty && !_tiffinContents.contains(customContent)) {
      setState(() {
        _tiffinContents.add(customContent);
        _customContentsController.clear();
      });
    }
  }
  void _removeContent(String content) {
    setState(() {
      _tiffinContents.remove(content);
    });
  }
  Widget _buildTextField(
      String labelText,
      IconData icon,
      TextEditingController controller, {
        Color iconColor = AppColors.primary,
        Color borderColor = AppColors.primary,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: AppStyle.heading24Black,
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: iconColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide(color: borderColor),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Add Product' , style: AppStyle.headingBlack,
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Select Category',
                          style: AppStyle.heading24Black
                      ),
                      SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                            _tiffinContents.clear();
                          });
                        },
                        iconEnabledColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: 'Select Category',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                        ),
                        validator: (value) {
                          if (value == null) return 'Please select a category';
                          return null;
                        },
                      )
                    ],
                  ),
                ),
                if (_selectedCategory == 'Water')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Select Quantity',
                            style: AppStyle.heading24Black
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedQuantity,
                          items: _quantities.map((quantity) {
                            return DropdownMenuItem<String>(
                              value: quantity,
                              child: Text(quantity),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedQuantity = value;
                            });
                          },
                          iconEnabledColor: AppColors.primary, // Color of the dropdown arrow
                          // iconDisabledColor: Colors.grey,
                          decoration: InputDecoration(
                            labelText: 'Select Quantity',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                          ),
                          validator: (value) {
                            if (value == null) return 'Please select a quantity';
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                SizedBox(height: 5),
                if (_selectedCategory == 'Tiffin')
                  _buildTextField('Tiffin Name', Icons.fastfood, _tiffinNameController),
                if (_selectedCategory == 'Tiffin')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What is in Tiffin',
                          style: AppStyle.heading24Black,
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _customContentsController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lunch_dining,
                              color: AppColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: AppColors.primary,
                              ),
                              onPressed: _addCustomContent,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                if (_selectedCategory == 'Tiffin')
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _tiffinContents.map((content) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Chip(
                            label: Text(
                                content,
                                style: AppStyle.whiteText18
                            ),
                            deleteIcon: Icon(
                              Icons.clear,
                              color: Colors.white,
                            ),
                            onDeleted: () => _removeContent(content),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(
                                color: AppColors.primary,
                                width: 1.5,
                              ),
                            ),
                            backgroundColor: AppColors.primary,
                            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                _buildTextField('Dish Name',  Icons.fastfood, _nameController),
                SizedBox(height: 5),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0, bottom: 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Select Product Images',
                            style: AppStyle.heading24Black
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: pickImages,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Center(
                          child: _images!.isEmpty
                              ? Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.add_a_photo, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text('Tap to pick images', style: AppStyle.heading1Black,),
                              ],
                            ),
                          )
                              : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _images!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0, top: 8, left: 8),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.blue,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.file(
                                          File(_images![index].path),
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -3,
                                      right: -3,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _images!.removeAt(index);
                                          });
                                        },
                                        child: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildTextField('Price', Icons.currency_rupee, _priceController),
                _buildTextField('Description', Icons.description, _descriptionController),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadImages();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    minimumSize: Size(double.infinity, 48),
                  ),
                  child: Builder(
                      builder: (context) {
                        double screenWidth = MediaQuery.of(context).size.width;
                        double buttonWidth = screenWidth > 600 ? 0.7 * screenWidth : 0.9 * screenWidth;
                        return Container(
                          width: buttonWidth,
                          child: Center(
                            child: Text('Add Product', style: AppStyle.whiteText18),
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
