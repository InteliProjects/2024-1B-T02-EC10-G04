import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile/controller/orders.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/models/medicines.dart';
import 'package:mobile/models/user.dart';
import 'package:mobile/services/orders.dart';
import 'package:mobile/services/user.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/widgets/role_dropdown.dart';
import 'package:mobile/widgets/selected_dropdown.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderNumber;
  final String orderDate;
  final String orderStatus;
  final VoidCallback onPressed;
  final Color color;
  final String priority;
  final String pyxis;
  final Icon iconStatus;
  final List<Medicines> medicines;
  final String role;
  final String orderId;
  final String observation;

  OrderDetailsPage({
    super.key,
    required this.orderNumber,
    required this.orderDate,
    required this.orderStatus,
    required this.onPressed,
    required this.color,
    required this.priority,
    required this.pyxis,
    required this.iconStatus,
    required this.medicines,
    required this.role,
    required this.orderId,
    required this.observation,
  });

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  late OrdersController _ordersController;
  List<User> users = [];
  String? selectedPriority;
  String? selectedCollectorId;

  @override
  void initState() {
    super.initState();
    _ordersController = OrdersController(orderService: OrderService());
    _initializeProfile();
    _initializePriority();
  }

  void _initializePriority() {
    setState(() {
      selectedPriority =
          widget.priority[0].toUpperCase() + widget.priority.substring(1);
    });
  }

  Future<void> _initializeProfile() async {
    var userList = await UserService().getAllUsers();
    setState(() {
      users = userList
          .where((user) => user['role'] == 'collector')
          .map((user) => User.fromJson(user))
          .toList();
    });
  }

  bool get isButtonEnabled =>
      selectedPriority != null && selectedCollectorId != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/orders');
            },
          ),
        ),
        title: const Text(
          'Order details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
            child: const Text(
              'Kindly select the medication you require',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.purple,
                                child: Text(
                                  'MS',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pixys - ${widget.pyxis}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                      fontSize: 18.0,
                                      color: AppColors.grey2,
                                    ),
                                  ),
                                  Text(
                                    'Order nº ${widget.orderNumber} - ${widget.orderDate}',
                                    style: const TextStyle(
                                      color: AppColors.grey3,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.grey5,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.iconStatus,
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.orderStatus,
                                    style: const TextStyle(
                                      color: AppColors.black50,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Medicines requested:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    color: AppColors.grey2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                for (Medicines medicine in widget.medicines)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Text(
                                      medicine.name!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Observation: ${widget.observation}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: AppColors.grey2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (widget.role == 'collector') ...[
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomButton(
                              receivedColor: AppColors.secondary,
                              isEnabled: true,
                              label: 'Finish Order',
                              onPressed: () {
                                _ordersController.updateOrder(
                                  context,
                                  widget.orderId,
                                  'completed',
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            RichText(
                              text: TextSpan(
                                text: 'Refuse order',
                                style: const TextStyle(
                                  color: AppColors.grey3,
                                  fontSize: 16,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    _ordersController.updateOrder(
                                      context,
                                      widget.orderId,
                                      'refused',
                                    );
                                  },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (widget.role == 'user') ...[
                      Center(
                        child: TextButton(
                          onPressed: widget.onPressed,
                          child: const Text(
                            'Request Again',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ] else if (widget.role == 'admin' ||
                        widget.role == 'manager') ...[
                      SelectedDropdown(
                        title: 'Priority',
                        items: const ['Green', 'Yellow', 'Red'],
                        value: selectedPriority!,
                        onChanged: (value) {
                          setState(() {
                            selectedPriority = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Dropdown(
                        title: 'Collector',
                        items: users
                            .map((user) => user.name)
                            .where((name) => name != null)
                            .cast<String>()
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCollectorId = users
                                .firstWhere((user) => user.name == value)
                                .id;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        receivedColor: AppColors.secondary,
                        isEnabled: isButtonEnabled,
                        label: 'Assign Order',
                        onPressed: () {
                          _ordersController.assignOrder(
                            context,
                            widget.orderId,
                            selectedCollectorId!,
                            selectedPriority!.toLowerCase(),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
