extension StringExtension on String {
  bool isValidEmail() {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool isValidPassword() {
    return length >= 6;
  }

  bool isEmpty() {
    return trim().length == 0;
  }

  String capitalize() {
    if (isEmpty()) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension DateTimeExtension on DateTime {
  bool isToday() {
    final today = DateTime.now();
    return year == today.year && month == today.month && day == today.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  String toFormattedString() {
    return toString().split('.')[0];
  }
}

extension DoubleExtension on double {
  String toLatLngString() {
    return toStringAsFixed(6);
  }
}
