import 'package:flutter/material.dart';
import 'package:order_up/items/side_bar_supplier.dart';
import 'package:order_up/providers/order.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  static const routeName = '/sales-screen';

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    final confirmedOrders = ordersData.confirmedOrders;

    final totalOrders = confirmedOrders.length;
    final totalRevenue = confirmedOrders.fold<double>(
        0, (previousValue, order) => previousValue + order.amount);
    final totalSoldProducts = confirmedOrders.fold<int>(
        0, (previousValue, order) => previousValue + order.products.length);

    final totalRevenueYear =
        _calculateTotalRevenueForYear(confirmedOrders, DateTime.now().year);
    final totalRevenueMonth = _calculateTotalRevenueForMonth(
        confirmedOrders, DateTime.now().year, DateTime.now().month);
    final totalRevenueWeek =
        _calculateTotalRevenueForWeek(confirmedOrders, DateTime.now());
    final totalRevenueDay =
        _calculateTotalRevenueForDay(confirmedOrders, DateTime.now());

    return Scaffold(
      drawer: SideBarSupplier(),
      appBar: AppBar(
        title: Text('Sales Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Number of Confirmed Orders: $totalOrders',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Revenue: Rial ${totalRevenue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Number of Sold Products: $totalSoldProducts',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Sales Summary:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListTile(
                    title: Text('Yearly Sales'),
                    subtitle: Text(
                        'Total Revenue: Rial ${totalRevenueYear.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Monthly Sales'),
                    subtitle: Text(
                        'Total Revenue: Rial ${totalRevenueMonth.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Weekly Sales'),
                    subtitle: Text(
                        'Total Revenue: Rial ${totalRevenueWeek.toStringAsFixed(2)}'),
                  ),
                  ListTile(
                    title: Text('Daily Sales'),
                    subtitle: Text(
                        'Total Revenue: Rial ${totalRevenueDay.toStringAsFixed(2)}'),
                  ),
                ],
              ),
            ),
    );
  }

  double _calculateTotalRevenueForYear(List<OrdersItem> orders, int year) {
    return orders.where((order) => order.dateTime.year == year).fold<double>(
        0, (previousValue, order) => previousValue + order.amount);
  }

  double _calculateTotalRevenueForMonth(
      List<OrdersItem> orders, int year, int month) {
    return orders
        .where((order) =>
            order.dateTime.year == year && order.dateTime.month == month)
        .fold<double>(
            0, (previousValue, order) => previousValue + order.amount);
  }

  double _calculateTotalRevenueForWeek(List<OrdersItem> orders, DateTime now) {
    final currentWeek = _getWeekNumber(now);
    return orders
        .where((order) =>
            order.dateTime.year == now.year &&
            _getWeekNumber(order.dateTime) == currentWeek)
        .fold<double>(
            0, (previousValue, order) => previousValue + order.amount);
  }

  double _calculateTotalRevenueForDay(List<OrdersItem> orders, DateTime day) {
    return orders
        .where((order) =>
            order.dateTime.year == day.year &&
            order.dateTime.month == day.month &&
            order.dateTime.day == day.day)
        .fold<double>(
            0, (previousValue, order) => previousValue + order.amount);
  }

  int _getWeekNumber(DateTime dateTime) {
    final firstDayOfYear = DateTime(dateTime.year, 1, 1);
    final daysDifference = dateTime.difference(firstDayOfYear).inDays;
    return (daysDifference / 7).ceil();
  }
}
