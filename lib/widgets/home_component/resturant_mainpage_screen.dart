// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:order_up/widgets/cart_component/cart_button.dart';
import 'package:order_up/items/side_bar.dart';
import 'package:order_up/widgets/home_component/home_slides.dart';
import 'package:order_up/widgets/home_component/ordering_history.dart';
import 'package:order_up/widgets/home_component/tap_search_bar.dart';
import 'package:order_up/widgets/supplier_lists_component/list_of_suppliers.dart';

class ResturantMainPageScreen extends StatefulWidget {
  const ResturantMainPageScreen({super.key});
  static const routeName = '/resturant-home';

  @override
  State<ResturantMainPageScreen> createState() =>
      _ResturantMainPageScreenState();
}

class _ResturantMainPageScreenState extends State<ResturantMainPageScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text("Order UP",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        actions: const [
          CartButton(),
        ],
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.1),
            child: TapSearchBar()),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: SizedBox(
        height: screenHeight * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.2,
              child: HomeSlides(),
            ),
            Expanded(child: ListOfSuppliers()),
          ],
        ),
      ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .pushReplacementNamed(OrderingHistory.routeName),
        tooltip: 'Ordering Histroy',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          
        ),
        backgroundColor: Theme.of(context).iconTheme.color,
        child: Icon(Icons.calendar_month_outlined),
      ),
    );
  }
}
