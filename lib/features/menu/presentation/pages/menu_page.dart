import 'package:ordini_ristorante/features/login/presentation/pages/login_page.dart';
import 'package:ordini_ristorante/features/menu/presentation/controllers/menu_restaurant_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ordini_ristorante/features/cart/presentation/controllers/cart_controller.dart';
import 'package:ordini_ristorante/features/menu/data/models/dish.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuRestaurantController>(
        builder: (menuController) {
      return Scaffold(
          backgroundColor: Colors.grey.shade300,
          appBar: AppBar(
            toolbarHeight: 70,
            title: const Text(
              "Francesco's Restaurant",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 22
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 6),
              child: menuController.logoUrl.isEmpty
                  ? SizedBox(width: 20)
                  : Image.network(menuController.logoUrl),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.white),
                onPressed: () {
                  Get.toNamed("/cart");
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
            ],
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: menuController.streamDishes(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

              if (snapshot.hasData) {

                Map<String, int> categoriesCount = menuController.countCategories(snapshot.data!.docs);

                List<Dish> dishItems = menuController.dishFilterItems(snapshot, menuController.selectedCategory.value);

                cartController.initializeQuantity(dishItems);

                return Column(
                  children: [
                    Container(
                      height: 100,
                      width: 380,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesCount.length,
                        itemBuilder: (context, index) {
                          String category = categoriesCount.keys.toList()[index];
                          return InkWell(
                             onTap: () {
                               menuController.setSelectedCategory(category);
                             },
                            child: Container(
                                alignment: Alignment.center,
                                width: 100,
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: category == menuController.selectedCategory.value ? Theme.of(context).primaryColor : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
                                      BoxShadow(
                                          offset: Offset(3, 3),
                                          color: Colors.grey,
                                          blurRadius: 6),
                                    ]),
                                child: Text(
                                  category.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 17, fontWeight: FontWeight.bold),
                                )),
                          );

                        },
                      ),
                    ),
                    Text(
                      menuController.getSelectedCategory().toUpperCase(),
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GridView.builder(
                            itemCount: dishItems.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 9 / 21),
                            itemBuilder: (BuildContext context, int index) {

                              Dish dish = dishItems[index];

                              return Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(3, 3),
                                            color: Colors.grey,
                                            blurRadius: 6),
                                      ],
                                      color: Colors.white
                                  ),
                                  child: Material(
                                    child: InkWell(
                                      // onTap: () {
                                      //   Get.to(LoginPage());
                                      // },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(10),
                                              child: Image.network(
                                                dish.pictureUrl,
                                                height: 147,
                                              )),
                                          Text(
                                            dish.title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              //Se il testo ha più di una riga va in overflow
                                              fontSize: dish.title.length > 17
                                                  ? 13.0
                                                  : 22.0,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8, top: 8),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 71,
                                              child: Wrap(
                                                children: [
                                                  for (int i = 0;
                                                  i < dish.ingredients.length;
                                                  i++)
                                                    Text(
                                                      dish.ingredients[i] + ", ",
                                                      style: TextStyle(
                                                          fontSize: dish.ingredients
                                                              .join(', ')
                                                              .length >
                                                              50
                                                              ? 11
                                                              : 13,
                                                          color:
                                                          Colors.grey.shade600),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(width: 4),
                                              Text(
                                                "\$" + dish.price.toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green),
                                              ),
                                              SizedBox(width: 4),
                                              IconButton(
                                                  onPressed: () {
                                                    cartController
                                                        .decreaseQuantity(index);
                                                  },
                                                  icon: Icon(Icons.remove_circle)),
                                              Obx(
                                                    () => Text(
                                                  cartController.quantity[index]
                                                      .toString(),
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    cartController
                                                        .increaseQuantity(index);
                                                  },
                                                  icon: Icon(Icons.add_circle)),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          ElevatedButton(
                                              onPressed: () {
                                                cartController.addToCart(dish,
                                                    cartController.quantity[index]);
                                              },
                                              child: Text("Aggiungi")),
                                        ],
                                      ),
                                    ),
                                  ),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ));
    });
  }
}
