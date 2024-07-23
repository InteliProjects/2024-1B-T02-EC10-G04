import 'package:flutter/material.dart';
import 'package:mobile/models/colors.dart';
import 'package:mobile/widgets/custom_button.dart';
import 'package:mobile/models/qrcode.dart';
import 'package:mobile/widgets/card_medicines.dart';
import 'package:mobile/services/pyxis.dart';
import 'package:mobile/models/medicines.dart';
import 'package:mobile/models/order_details.dart';
import 'package:mobile/pages/check_orders_page.dart';

class NewOrderPage extends StatefulWidget {
  static const routeName = '/new-order';

  const NewOrderPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _NewOrderPageState createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  String? selectedAnswer;
  String? selectedMedicineId;
  int quantity = 0;
  late Future<List<Medicines>> medicinesFuture;
  final PyxisService medicines2 = PyxisService();
  List<String> selectedMedicineIds = [];
  List<String> selectedMedicineNames = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as QRCodeArguments;
    medicinesFuture = PyxisService().getMedicinesByPyxisId(args.idPyxis);
  }

  void handleCardTap(String id, String name) {
    setState(() {
      if (selectedMedicineIds.contains(id)) {
        selectedMedicineIds.remove(id);
        selectedMedicineNames.remove(name);
      } else {
        selectedMedicineIds.add(id);
        selectedMedicineNames.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as QRCodeArguments;

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
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text(
          'New Order',
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.grey5,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.home,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Pixys ${args.pyxis}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                        fontSize: 18.0,
                                        color: AppColors.grey2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Choose the necessary medicines',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    fontSize: 18.0,
                                  ),
                                ),
                                SizedBox(height: 2),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FutureBuilder<List<Medicines>>(
                            future: medicinesFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading medicines'));
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text('No medicines available'));
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: snapshot.data!.map((medicine) {
                                    String id = medicine.id!;
                                    return CardMedicines(
                                      medicine: medicine.name!,
                                      lote: medicine.batch!,
                                      isChecked:
                                          selectedMedicineIds.contains(id),
                                      onTap: () =>
                                          handleCardTap(id, medicine.name!),
                                    );
                                  }).toList(),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  icon: const Icon(Icons.arrow_back),
                                  label: 'Back',
                                  receivedColor: AppColors.grey3,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  isEnabled: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomButton(
                                  icon: const Icon(Icons.arrow_forward),
                                  label: 'Submit',
                                  receivedColor: AppColors.secondary,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, CheckOrderPage.routeName,
                                        arguments: OrderDetailsArguments(
                                            selectedMedicineIds,
                                            selectedMedicineNames,
                                            args.idPyxis,
                                            args.pyxis));
                                  },
                                  isEnabled: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
