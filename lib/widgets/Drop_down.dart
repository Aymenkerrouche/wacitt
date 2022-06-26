import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wacitt/theme/color.dart';

import '../models/category.dart';

class DropDownCategory extends StatefulWidget {
  const DropDownCategory({Key? key}) : super(key: key);

  @override
  State<DropDownCategory> createState() => _DropDownCategoryState();
}

class _DropDownCategoryState extends State<DropDownCategory> {
  String? dropdown;
  Category? category;
  List categories = [];
  @override
  void initState() {
    super.initState();
    getCatrgories();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: GFDropdown(
          padding: const EdgeInsets.all(15),
          borderRadius: BorderRadius.circular(15),
          dropdownButtonColor: kPrimaryColor.withOpacity(0.15),
          value: dropdown,
          onChanged: (newValue) {
            setState(() {
              dropdown = newValue as String?;
            });
          },
          items: categories
              .map((value) => DropdownMenuItem(
                    value: value,
                    child: Text(value),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Future getCatrgories() async {
    await FirebaseFirestore.instance
        .collection("Catégories")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        setState(() {
          category = Category.fromJson(element.data());
          categories.add(category!.name);
        });
      });
    });
    print(categories);
  }
}
