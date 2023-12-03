import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../resources/strings_manager.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppStrings.cart.tr()),
    );
  }
}
