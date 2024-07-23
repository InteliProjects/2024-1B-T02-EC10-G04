import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/card_order.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/models/order.dart';
import 'package:provider/provider.dart';
import 'package:mobile/logic/calendar_funcitons.dart';

class TabSessionPendingOrders extends StatefulWidget {
  final Future<List<Order>> orders;
  final String role;

  @override
  // ignore: library_private_types_in_public_api
  _TabSessionPendingOrdersState createState() =>
      _TabSessionPendingOrdersState();

  const TabSessionPendingOrders({
    super.key,
    required this.orders,
    required this.role,
  });
}

class _TabSessionPendingOrdersState extends State<TabSessionPendingOrders> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(),
      child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<List<Order>>(
                      future: widget.orders,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.secondary,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          DateTime selectedDate =
                              Provider.of<CalendarLogic>(context).selectedDay ??
                                  DateTime.now();
                          List<Order> filteredOrders =
                              snapshot.data!.where((order) {
                            return DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(order.createdAt!)) ==
                                    DateFormat('yyyy-MM-dd')
                                        .format(selectedDate) &&
                                order.status != "completed" &&
                                order.status != "refused";
                          }).toList();
                          return ListView.builder(
                            itemCount: filteredOrders.length,
                            itemBuilder: (context, index) {
                              return CardOrder(
                                id: filteredOrders[index].id!,
                                orderId: filteredOrders[index].orderId!,
                                role: widget.role,
                                orderNumber:
                                    "Nº ${filteredOrders[index].id!.substring(0, 6).toUpperCase()}",
                                orderDate: filteredOrders[index].createdAt!,
                                orderStatus:
                                    filteredOrders[index].status!.toUpperCase(),
                                onPressed: () {},
                                color: filteredOrders[index].priority == "red"
                                    ? AppColors.error
                                    : filteredOrders[index].priority == "green"
                                        ? AppColors.success
                                        : AppColors.warning,
                                priority: filteredOrders[index].priority!,
                                pyxis: filteredOrders[index].pyxis_id!,
                                iconStatus: filteredOrders[index].status ==
                                        "ongoing"
                                    ? const Icon(
                                        Icons.change_circle,
                                        color: AppColors.warning,
                                      )
                                    : filteredOrders[index].status == "pending"
                                        ? const Icon(
                                            Icons.change_circle,
                                            color: AppColors.warning,
                                          )
                                        : filteredOrders[index].status ==
                                                "completed"
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: AppColors.success,
                                              )
                                            : filteredOrders[index].status ==
                                                    "refused"
                                                ? const Icon(
                                                    Icons.cancel,
                                                    color: AppColors.error,
                                                  )
                                                : const Icon(
                                                    Icons.cancel,
                                                    color: AppColors.error,
                                                  ),
                                medicines: filteredOrders[index].medicines!,
                                date: filteredOrders[index].createdAt!,
                                observation: filteredOrders[index].observation!,
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              'Orders not found!',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.black50,
                              ),
                            ),
                          );
                        }
                        return const CircularProgressIndicator();
                      })),
            ],
          )),
    );
  }
}
