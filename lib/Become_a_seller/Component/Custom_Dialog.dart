import 'package:flutter/material.dart';

import '../../config/app_color.dart';

class CustomEditDialog extends StatelessWidget {
  final String title;
  final String currentValue;
  final TextEditingController controller;
  final String field;
  final Function(String) onSave;

  CustomEditDialog({
    required this.title,
    required this.currentValue,
    required this.controller,
    required this.field,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    controller.text = currentValue;

    double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: Colors.white,
      elevation: 16,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit $title',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Nexa'
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            if (field == 'gender')
              DropdownButton<String>(
                value: currentValue,
                isExpanded: true,
                onChanged: (String? newValue) {
                  controller.text = newValue!;
                },
                items: <String>['Select Gender', 'Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            if (field != 'gender')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 1.0, bottom: 8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nexa',
                      ),
                    ),
                  ),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    cursorColor: AppColors.primary,
                    keyboardType: TextInputType.text,
                    maxLines: 1,
                  )
                ],
              ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: screenWidth * 0.25,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    String updatedValue = controller.text;
                    onSave(updatedValue);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: screenWidth * 0.25,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
