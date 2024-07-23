import 'package:flutter/material.dart';
import 'package:order_up/classes/notificationService.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/widgets/cart_component/cart_button.dart';
import 'package:order_up/widgets/product_component/dropdown_quantity.dart';
import 'package:order_up/widgets/product_component/image_slider.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/widgets/product_component/text_builder.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});
  static const routeName = '/product-details';

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // Instantiate the notification service
  final NotificationService notificationService = NotificationService();
  // Define variable to store selected amount
  String? selectedAmount;
  int? amountIndex;

  // List to store shopping items

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Product;
    // final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    // Receive selected amount
    void onAmountSelected(String amount, int index) {
      setState(() {
        selectedAmount = amount;
        amountIndex = index;
      });
    }

    // Function to add product to the shopping cart
    void addToCart() {
      if (selectedAmount != null) {
        cart.addItem(
            routeArgs.id.toString(),
            double.parse(routeArgs.price.elementAt(amountIndex!)),
            routeArgs.title,
            routeArgs.image[0],
            selectedAmount!,
            routeArgs.supplier);
        NotificationService.showAddedToCartNotification(context);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Chose the amount you want'),
          duration: Duration(seconds: 2),
        ));
      }
    }

    Widget buildButton() {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: ElevatedButton(
          // Call addToCart function when button is pressed
          onPressed: () {
            addToCart();
          },
          style: ButtonStyle(
            padding: WidgetStatePropertyAll(EdgeInsets.all(12)),
            backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).iconTheme.color),
            foregroundColor: WidgetStatePropertyAll(Colors.black),
          ),
          child: const Text('Add to Cart'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: const [
          CartButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageSlider(routeArgs.image),
              TextBuilder('Title: ${routeArgs.title}', 18),
              Divider(),
              amountIndex != null
                  ? TextBuilder(
                      'Price: ${routeArgs.price[amountIndex!]} Rial', 18)
                  : TextBuilder(
                      'Price: ${routeArgs.price[0]} Rial', 18),
              Divider(),
              TextBuilder('Description', 18),
              TextBuilder(routeArgs.description, 16),
              Divider(),
              DropdownQuantity(
                routeArgs.amount,
                onAmountSelected: onAmountSelected,
              ),
              Divider(),
              buildButton(),
            ]),
      ),
    );
  }
}
