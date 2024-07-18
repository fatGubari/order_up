import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:order_up/items/side_bar.dart';
import 'package:order_up/providers/order.dart';
import 'package:order_up/widgets/cart_component/cart_button.dart';
import 'package:provider/provider.dart';

class OrderingHistory extends StatefulWidget {
  const OrderingHistory({super.key});

  static const routeName = '/ordering-history';

  @override
  State<OrderingHistory> createState() => _OrderingHistoryState();
}

class _OrderingHistoryState extends State<OrderingHistory> {
  DateTime? _startDate;
  List<bool> _expandedList = [];
  
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    final orders = ordersData.orders;

    if (_expandedList.length != orders.length) {
      _expandedList = List<bool>.filled(orders.length, false);
    }

    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text('Ordering History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          CartButton(),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showDateFilter,
          ),
        ],
      ),
      body:FutureBuilder(
              future: _ordersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.error != null) {
                    return Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          if (_startDate != null &&
                              order.dateTime.isBefore(_startDate!)) {
                            return Container();
                          }
                          return _buildOrderItem(order, index, context);
                        },
                      ),
                    );
                  }
                }
              },
            ),
    );
  }

  Widget _buildOrderItem(OrdersItem order, int index, BuildContext context) {
    final orderDetails =
        Provider.of<Orders>(context).getSupplierAndAmount(order);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 9.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          children: [
            ListTile(
              title: Text(
                order.id,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Date: ${DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)}',
                  ),
                  SizedBox(width: 20.0),
                  Text('Price: \$${order.amount}'),
                ],
              ),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _expandedList[index] = !_expandedList[index];
                  });
                },
                icon: Icon(
                  _expandedList[index] ? Icons.expand_less : Icons.expand_more,
                ),
              ),
            ),
            if (_expandedList[index])
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...orderDetails.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(),
                            Text('Supplier: ${entry.key}'),
                            Text('Product Info: ${entry.value.join(', ')}'),
                            SizedBox(height: 4.0),
                          ],
                        )),
                    Divider(),
                    SizedBox(height: 4.0),
                    Text('Order Number: ${order.id}'),
                    SizedBox(height: 6.0),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDateFilter() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }
}
