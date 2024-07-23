import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:mobile/logic/calendar_funcitons.dart';
import 'package:mobile/widgets/date_picker.dart';
import 'package:mobile/models/colors.dart';

Widget buildCalendarSelector(BuildContext context) {
  var calendarLogic = Provider.of<CalendarLogic>(context);

  return Padding(
    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(calendarLogic.selectedDate),
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.black50,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt),
          onPressed: () => _showMonthYearPicker(context),
        ),
      ],
    ),
  );
}

void _showMonthYearPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return const DatePicker();
    },
  );
}

Widget buildDaysCalendar(BuildContext context) {
  var calendarLogic = Provider.of<CalendarLogic>(context);

  ScrollController scrollController = ScrollController();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (calendarLogic.selectedDay != null) {
      int dayIndex = calendarLogic.selectedDay!.day - 1;
      double initialOffset = dayIndex * 60;
      scrollController.jumpTo(initialOffset);
    }
  });

  return SizedBox(
    height: 65,
    child: ListView.builder(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      itemCount: calendarLogic.generateDays().length,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 60,
          child: calendarLogic.generateDays()[index],
        );
      },
    ),
  );
}
