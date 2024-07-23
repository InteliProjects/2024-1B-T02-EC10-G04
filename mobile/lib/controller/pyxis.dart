import 'package:flutter/material.dart';
import 'package:mobile/logic/show_modal.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/services/pyxis.dart';
import 'package:mobile/models/pyxis.dart';

class PyxisController {
  final PyxisService pyxisService;

  PyxisController({required this.pyxisService});

  Future<Pyxis>? getPyxisById(
      BuildContext context, String id) async {
    try {
      final response = await pyxisService.getPyxisById(id);
      return response;

      // Handle login success
    } catch (e) {
      showModal(
          // ignore: use_build_context_synchronously
          context,
          "Oops! Something Went Wrong",
          "It was not possible to identify pyxis through the QR code read",
          Icons.error,
          AppColors.error,
          "");
      throw Exception('Failed to load Pyxis');
    }
  }


}
