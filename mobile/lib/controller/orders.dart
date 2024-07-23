import 'package:flutter/material.dart';
import 'package:mobile/logic/show_modal.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/services/orders.dart';

class OrdersController {
  final OrderService orderService;

  OrdersController({required this.orderService});

  Future<void> createOrder(BuildContext context, List<String> medicineIds, String observation, String pyxis_id) async {

    try {
      final response = await orderService.createOrder(medicineIds, observation, pyxis_id);

      if (response.isNotEmpty) {
        showModal(
            // ignore: use_build_context_synchronously
            context,
            "Order created!",
            "Your order were created successfully. You can check your orders in the orders page.",
            Icons.check,
            AppColors.success,
            "/orders");
        return;
      }
      showModal(
          // ignore: use_build_context_synchronously
          context,
          "Oops! Something Went Wrong",
          "Something went wrong while the order were created. Please try again or talk with an administrador.",
          Icons.error,
          AppColors.error,
          "");

      // Handle login success
    } catch (e) {
      // Handle login failure
    }
  }

  Future<void> updateOrder(
      BuildContext context, String orderId, String status) async {
    try {
      final response = await orderService.updateOrder(orderId, status);

      if (response.isNotEmpty) {
        showModal(
            // ignore: use_build_context_synchronously
            context,
            "Order Finished!",
            "Your order were finished successfully. You can check your orders in the orders page.",
            Icons.check,
            AppColors.success,
            "/orders");
        return;
      }
      showModal(
          // ignore: use_build_context_synchronously
          context,
          "Oops! Something Went Wrong",
          "Something went wrong while the order were finished. Please try again or talk with an administrador.",
          Icons.error,
          AppColors.error,
          "");

      // Handle login success
    } catch (e) {
      // Handle login failure
    }
  }

  Future<void> assignOrder(
      BuildContext context, String orderId, String userId, String priority) async {
    try {
      final response = await orderService.assignOrder(orderId, userId, priority);

      if (response.isNotEmpty) {
        showModal(
            // ignore: use_build_context_synchronously
            context,
            "Order Assigned!",
            "Your order were assigned successfully. You can check your orders in the orders page.",
            Icons.check,
            AppColors.success,
            "/orders");
        return;
      }
      showModal(
          // ignore: use_build_context_synchronously
          context,
          "Oops! Something Went Wrong",
          "Something went wrong while the order were assigned. Please try again or talk with an administrador.",
          Icons.error,
          AppColors.error,
          "");

      // Handle login success
    } catch (e) {
      // Handle login failure
    }
  }
}
