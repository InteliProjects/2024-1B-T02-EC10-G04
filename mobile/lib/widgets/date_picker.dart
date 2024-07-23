import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile/logic/calendar_funcitons.dart';
import 'package:mobile/widgets/custom_button.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    var calendarLogic = Provider.of<CalendarLogic>(context, listen: true);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: DateFormat('MMMM').format(calendarLogic.selectedDate),
                items: calendarLogic.months.map((String month) {
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                        month),
                  );
                }).toList(),
                onChanged: calendarLogic.onMonthChanged,
              ),
              const SizedBox(width: 10),
              DropdownButton<int>(
                value: calendarLogic.selectedDate.year,
                items: calendarLogic.years.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text(
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                        year.toString()),
                  );
                }).toList(),
                onChanged: calendarLogic.onYearChanged,
              ),
            ],
          ),
          const SizedBox(height: 10),
          CustomButton(
            receivedColor: Colors.blue,
            minWidth: 200,
            height: 50,
            isEnabled: true,
            label: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
