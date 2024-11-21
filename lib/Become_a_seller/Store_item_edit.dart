import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../config/app_color.dart';
import '../config/app_styles.dart';


class EditItemPage extends StatefulWidget {
  final String itemId;
  final String name;
  final String price;
  final String description;
  final List<String> imageUrls;

  EditItemPage({
    required this.itemId,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrls,
  });

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  List<File> _imageFiles = [];
  List<String> _newImageUrls = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _priceController = TextEditingController(text: widget.price);
    _descriptionController = TextEditingController(text: widget.description);
    _imageFiles = [];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<String> uploadImage(File image) async {
    String filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.png';
    final Reference storageReference =
    FirebaseStorage.instance.ref().child(filePath);
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;

    if (snapshot.state == TaskState.success) {
      return await snapshot.ref.getDownloadURL();
    } else {
      throw Exception('Image upload failed');
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null) {
      setState(() {
        _imageFiles = images.map((image) => File(image.path)).toList();
      });
    }
  }

  void _updateItem() async {
    if (_formKey.currentState!.validate()) {
      for (var imageFile in _imageFiles) {
        try {
          String newImageUrl = await uploadImage(imageFile);
          _newImageUrls.add(newImageUrl);
        } catch (e) {
          print("Error uploading image: $e");
        }
      }
      FirebaseFirestore.instance.collection('difwaitems').doc(widget.itemId).update({
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descriptionController.text,
        'imageUrls': _newImageUrls.isNotEmpty
            ? _newImageUrls
            : widget.imageUrls,
      }).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        print("Error updating item: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Item',
          style: AppStyle.headingBlack,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name',
                    style: AppStyle.heading24Black,
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price',
                        style: AppStyle.heading24Black,
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter item price';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Description',
                        style: AppStyle.heading24Black,
                      ),
                      SizedBox(height: 8,),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter item description';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Item Images',
                        style: AppStyle.heading24Black,
                      ),
                      GestureDetector(
                        onTap: _pickImages,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _imageFiles.isEmpty
                                ? widget.imageUrls.isNotEmpty
                                ? Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (screenWidth > 600) ? 4 : 3,
                                  childAspectRatio: 1,
                                ),
                                itemCount: widget.imageUrls.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == widget.imageUrls.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: IconButton(
                                        onPressed: _pickImages,
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          color: AppColors.primary,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show image from the list
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          widget.imageUrls[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )
                                : Center(child: Text('No Image Selected'))
                                : Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: (screenWidth > 600) ? 4 : 3,
                                  childAspectRatio: 1,
                                ),
                                itemCount: _imageFiles.length + 1, // +1 for the icon
                                itemBuilder: (context, index) {
                                  if (index == _imageFiles.length) {
                                    // Show the "Add Image" icon as the last item
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: IconButton(
                                        onPressed: _pickImages,
                                        icon: Icon(
                                          Icons.add_a_photo,
                                          color: AppColors.primary,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  } else {
                                    // Show image from the list
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          _imageFiles[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: _updateItem,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, 50),
                  backgroundColor: AppColors.primary,
                ),
                child: Text('Update Item', style: AppStyle.whiteText18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
