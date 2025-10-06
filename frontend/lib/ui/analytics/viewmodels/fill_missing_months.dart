List<Map<String, dynamic>> fillMissingMonths(List<Map<String, dynamic>> data, {int? year}) {
  final Map<String, int> monthPoints = {
    for (var item in data) item['month_year']: item['sale_point']
  };
  const List<String> monthNames = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  List<String> monthsToFill = [];

  if (year != null) {
    // Fill all 12 months for the given year
    for (int m = 1; m <= 12; m++) {
      String monthYear = "$year-${m.toString().padLeft(2, '0')}";
      monthsToFill.add(monthYear);
    }
  } else {
    // Fill last 12 months from today
    DateTime now = DateTime.now();
    for (int i = 0; i < 12; i++) {
      DateTime date = DateTime(now.year, now.month - i, 1);
      String monthYear = "${date.year}-${date.month.toString().padLeft(2, '0')}";
      monthsToFill.add(monthYear);
    }
  }

  // Build final list with existing or default point values
  List<Map<String, dynamic>> result = monthsToFill.map((monthYear) {
        int month = int.parse(monthYear.split('-')[1]);
    String monthName = monthNames[month - 1];

    return {
      "month_year": monthYear,
      "sale_point": monthPoints[monthYear] ?? 0,
      "month_name": monthName
    };
  }).toList();

  // Optional: sort by date
  result.sort((a, b) => a['month_year'].compareTo(b['month_year']));

  return result;
}