import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:order_up/items/search_for_supplier.dart';
import 'package:order_up/providers/auth.dart';
import 'package:order_up/providers/cart.dart';
import 'package:order_up/providers/chatting_provider.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/providers/products.dart';
import 'package:order_up/providers/suppliers.dart';
import 'package:order_up/widgets/cart_component/shopping_cart_screen.dart';
import 'package:order_up/widgets/chat_component/chat_screen.dart';
import 'package:order_up/widgets/chat_component/chats_list_screen.dart';
import 'package:order_up/widgets/home_component/ordering_history.dart';
import 'package:order_up/widgets/home_component/resturant_mainpage_screen.dart';
import 'package:order_up/widgets/loading_component/loading_screen.dart';
import 'package:order_up/widgets/login_component/login_screen.dart';
import 'package:order_up/widgets/manage_product_componenet/add_edit_product.dart';
import 'package:order_up/widgets/manage_product_componenet/manage_product.dart';
import 'package:order_up/widgets/orders_component/order_progres.dart';
import 'package:order_up/widgets/product_component/product_details.dart';
import 'package:order_up/widgets/profile_component/profile_screen.dart';
import 'package:order_up/widgets/sales_component/sales_screen.dart';
import 'package:order_up/widgets/supplier_home_componenet/all_orders.dart';
import 'package:order_up/widgets/supplier_home_componenet/inprogress_orders.dart';
import 'package:order_up/widgets/supplier_home_componenet/supplier_homepage.dart';
import 'package:order_up/widgets/supplier_lists_component/suppliers_screens.dart';
import 'package:provider/provider.dart';

// void main() => runApp(MyApp());

Future main() async {
  // WidgetsBinding widgetsBinding =
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            update: (context, auth, previousProducts) => auth.isAuth
                ? (previousProducts!
                  ..setAuth(
                    auth.token ?? '',
                    auth.userId,
                    previousProducts == null ? [] : previousProducts.products,
                  ))
                : Products(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (context) => Orders(),
            update: (context, auth, previousOrders) => auth.isAuth
                ? (previousOrders!
                  ..setAuth(
                    auth.token ?? '',
                    auth.userId,
                    auth.userName ?? '',
                    auth.userType ?? '',
                    previousOrders == null ? [] : previousOrders.orders,
                  ))
                : Orders(),
          ),
          ChangeNotifierProvider(
            create: (context) => Suppliers(),
          ),
          ChangeNotifierProvider(
            create: (context) => ChattingProvider(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            title: 'Order Up',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color.fromARGB(0, 17, 161, 177)),
              iconTheme:
                  IconThemeData(color: const Color.fromARGB(255, 236, 198, 73)),
              useMaterial3: true,
            ),
            home: auth.isAuth
                ? (auth.userType == 'restaurant'
                    ? ResturantMainPageScreen()
                    : SupplierHomepage())
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? LoadingScreen()
                            : LoginScreen(),
                  ),
            // initialRoute: LoginScreen.routeName,
            routes: {
              // TwoUsers.routeName: (context) => TwoUsers(),
              LoginScreen.routeName: (context) => LoginScreen(),
              ResturantMainPageScreen.routeName: (context) =>
                  ResturantMainPageScreen(),
              SuppliersScreens.routeName: (context) => SuppliersScreens(),
              ProductDetails.routeName: (context) => ProductDetails(),
              SearchForSupplier.routeName: (context) => SearchForSupplier(),
              ShoppingCartScreen.routeName: (context) => ShoppingCartScreen(),
              OrderingHistory.routeName: (context) => OrderingHistory(),
              ProfileScreen.routeName: (context) => ProfileScreen(),
              OrderProgres.routeName: (context) => OrderProgres(),
              SupplierHomepage.routeName: (context) => SupplierHomepage(),
              ManageProduct.routeName: (context) => ManageProduct(),
              AddEditProduct.routeName: (context) => AddEditProduct(),
              SalesScreen.routeName: (context) => SalesScreen(),
              AllOrders.routeName: (context) => AllOrders(),
              ChatScreen.routeName: (context) => ChatScreen(),
              ChatsListScreen.routeName: (context) => ChatsListScreen(),
              InprogressOrders.routeName: (context) => InprogressOrders(),
            },
            onUnknownRoute: (settings) =>
                MaterialPageRoute(builder: (context) => LoginScreen()),
          ),
        ));
  }
}
