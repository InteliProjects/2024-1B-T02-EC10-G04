import 'package:flutter/material.dart';
import 'package:mobile/logic/calendar_funcitons.dart';
import 'package:mobile/logic/local_storage.dart';
import 'package:provider/provider.dart';
import 'package:mobile/widgets/calendar.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/widgets/navbar.dart';
import 'package:mobile/models/order.dart';
import 'package:mobile/services/orders.dart';
import 'package:mobile/widgets/tab_session_history.dart';
import 'package:mobile/widgets/tab_session.dart';
import 'dart:async';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> futureMedicineOrders;
  final OrderService orderService = OrderService();
  late Timer _timer;

  String name = '';
  String role = '';

  @override
  void initState() {
    super.initState();

    _initializeName();
    futureMedicineOrders = orderService.getOrders();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchData();
    });
  }

  Future<void> _initializeName() async {
    name = await LocalStorageService().getValue('name') ?? '';
    role = await LocalStorageService().getValue('role') ?? '';
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      futureMedicineOrders = orderService.getOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CalendarLogic>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: const NavBarContainer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $name!',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black50),
                      ),
                    ],
                  )),
              buildCalendarSelector(context),
              const SizedBox(height: 10),
              buildDaysCalendar(context),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: AppColors.secondary,
                      labelColor: AppColors.secondary,
                      tabs: [
                        Tab(
                          child: Text(
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 14),
                              'Pedding orders'),
                        ),
                        Tab(
                          child: Text(
                              style: TextStyle(
                                  fontFamily: 'Poppins', fontSize: 14),
                              'History'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          TabSessionPendingOrders(
                            orders: futureMedicineOrders,
                            role: role,
                          ),
                          TabSessionHistory(
                            orders: futureMedicineOrders,
                            role: role,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
