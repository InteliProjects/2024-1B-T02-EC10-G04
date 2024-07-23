import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile/widgets/day_card.dart';

class CalendarLogic extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  List<String> months = List.generate(
    12,
    (index) => DateFormat('MMMM').format(DateTime(0, index + 1)),
  );
  List<int> years = List.generate(5, (index) => DateTime.now().year - index);

  void onMonthChanged(String? newMonth) {
    if (newMonth != null) {
      int monthIndex = months.indexOf(newMonth) + 1;
      selectedDate = DateTime(selectedDate.year, monthIndex, 1);
      selectedDay = null;
      notifyListeners();
    }
  }

  void onYearChanged(int? newYear) {
    if (newYear != null) {
      selectedDate = DateTime(newYear, selectedDate.month, 1);
      selectedDay = null;
      notifyListeners();
    }
  }

  void onDaySelected(DateTime date) {
    selectedDay = date;
    notifyListeners();
  }

  List<Widget> generateDays() {
    int daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    List<Widget> dayWidgets = [];
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(selectedDate.year, selectedDate.month, i);
      String weekDay = DateFormat('E').format(date);
      bool isSelected = selectedDay != null &&
                        selectedDay!.year == date.year &&
                        selectedDay!.month == date.month &&
                        selectedDay!.day == date.day;
      dayWidgets.add(DayCard(
        day: i.toString(),
        weekDay: weekDay,
        date: date,
        isSelected: isSelected,
        onTap: () {
          onDaySelected(date);
        },
      ));
    }
    return dayWidgets;
  }
}
