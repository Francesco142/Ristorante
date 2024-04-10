import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/cart_item.dart';
import '../controllers/cart_controller.dart';

class CartPage extends StatelessWidget {

  final CartController cartController = Get.find(); // Ottieni il controller del carrello

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrello'),
      ),
      body: Obx(() {

        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            CartItem cartItem = cartController.cartItems[index];
            return ListTile(
              title: Text( cartItem.quantity.toString() + "x " + cartItem.dish.title),
              subtitle: Text('\$${cartItem.dish.price}'),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  cartController.removeFromCart(cartItem);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
