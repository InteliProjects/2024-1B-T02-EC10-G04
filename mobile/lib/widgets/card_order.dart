import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/pages/details_page.dart';
import 'package:mobile/models/medicines.dart';
import 'package:mobile/services/pyxis.dart';
import 'package:intl/intl.dart';
import 'package:mobile/models/pyxis.dart';

class CardOrder extends StatefulWidget {
  final String id;
  final String orderNumber;
  final String orderDate;
  final String orderStatus;
  final VoidCallback onPressed;
  final Color color;
  final String priority;
  final String pyxis;
  final Icon iconStatus;
  final List<Medicines> medicines;
  final String date;
  final String role;
  final String orderId;
  final String observation;

  const CardOrder({
    super.key,
    required this.id,
    required this.orderNumber,
    required this.orderDate,
    required this.orderStatus,
    required this.onPressed,
    required this.color,
    required this.priority,
    required this.pyxis,
    required this.iconStatus,
    required this.medicines,
    required this.date,
    required this.role,
    required this.orderId,
    required this.observation,
  });

  @override
  _CardOrderState createState() => _CardOrderState();
}

class _CardOrderState extends State<CardOrder> {
  late Future<Pyxis?> pyxisData;
  final PyxisService pyxisService = PyxisService();

  @override
  void initState() {
    super.initState();
    pyxisData = pyxisService.getPyxisById(widget.pyxis);
  }

  String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Pyxis?>(
      future: pyxisData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading pyxis data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        } else {
          Pyxis? pyxis = snapshot.data;

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.grey, width: 0.5),
            ),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                              pyxis?.label?.substring(0, 2).toUpperCase() ??
                                  'MS',
                              style: const TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: 'Poppins'),
                          '${pyxis?.label ?? 'N/A'} - ${widget.orderNumber.substring(0, 7)}',
                        )
                      ]),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.priority == "red"
                              ? Colors.red[100]
                              : widget.priority == "green"
                                  ? Colors.green[100]
                                  : Colors.yellow[100],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: widget.priority == "red"
                                ? AppColors.error
                                : widget.priority == "green"
                                    ? AppColors.success
                                    : AppColors.warning,
                          ),
                        ),
                        child: Text(
                          widget.priority == "red"
                              ? "Urgent"
                              : widget.priority == "green"
                                  ? "Normal"
                                  : "Moderate",
                          style: TextStyle(
                            color: widget.priority == "red"
                                ? AppColors.error
                                : widget.priority == "green"
                                    ? AppColors.success
                                    : AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            widget.iconStatus,
                            const SizedBox(width: 5),
                            Text(
                                style: const TextStyle(
                                    fontSize: 14, fontFamily: 'Poppins'),
                                widget.orderStatus.toLowerCase()),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(left: 30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (Medicines medicine in widget.medicines)
                                Padding(
                                    padding: const EdgeInsets.only(
                                      top: 2.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.medication,
                                            color: AppColors.black50, size: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'Poppins'),
                                            medicine.name!)
                                      ],
                                    ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsPage(
                                orderNumber: widget.orderNumber.substring(0, 7),
                                orderDate: formatDateString(widget.orderDate),
                                orderStatus: widget.orderStatus,
                                medicines: widget.medicines,
                                onPressed: () {},
                                color: AppColors.warning,
                                priority: widget.priority,
                                pyxis: pyxis?.label ?? 'N/A',
                                iconStatus: widget.iconStatus,
                                role: widget.role,
                                orderId: widget.orderId,
                                observation: widget.observation,
                              ),
                            ),
                          );
                        },
                        child: const Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'View details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: AppColors.black50,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      4), // Espaçamento opcional entre o texto e o ícone
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.black50,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
