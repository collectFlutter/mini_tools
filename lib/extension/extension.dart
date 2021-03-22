import 'package:mini_tools/date/date_util.dart';

extension StringExtension on String {
  bool isNullOrEmpty() => this == null || this.isEmpty;

  bool isNotNullAndNotEmpty() => this != null && this.isNotEmpty;

  String ellipsis([int length]) {
    if (isNullOrEmpty()) return '';
    if (length == null || this.length <= length) return this;
    length = (length / 2).floor() - 3;
    return this.substring(0, length) +
        '...' +
        this.substring(this.length - length);
  }

  String getDateStr() {
    if (this == null) return '';
    if (this.length > 10) return this.substring(0, 10).replaceAll("/", "-");
    return this;
  }

  String getTimeStr() {
    if (this == null) return '';
    if (this.length > 16) return this.substring(11, 16);
    return this;
  }
}

extension DateTimeExtension on DateTime {
  /// 时间转换，只支持以下字符串
  DateTime copy(
      {int year, int month, int day, int hour, int minute, int second}) {
    if (this == null) return null;
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
    );
  }

  String getFormatStr(
      {DateFormat format = DateFormat.NORMAL,
      String dateSeparate,
      String timeSeparate}) {
    if (this == null) return null;
    return DateUtil.getDateStrByDateTime(this,
        format: format, dateSeparate: dateSeparate, timeSeparate: timeSeparate);
  }

  String getDateStr({String dateSeparate, String timeSeparate}) =>
      DateUtil.getDateStrByDateTime(this,
          format: DateFormat.YEAR_MONTH_DAY,
          dateSeparate: dateSeparate,
          timeSeparate: timeSeparate);

  /// 是否时同一天
  bool isAtSameDayAs(DateTime other) =>
      this != null &&
      other != null &&
      this.day == other.day &&
      this.year == other.year &&
      this.month == other.month;

  DateTime minDate(DateTime other) {
    if (other == null) return this;
    return this.isBefore(other) ? this : other;
  }

  DateTime maxDate(DateTime other) {
    if (other == null) return this;
    return this.isAfter(other) ? this : other;
  }

// bool isAtSameMomentAs(other){
//
// }
}

extension IterableExtension<E> on Iterable<E> {
  bool get isNotNullAndEmpty {
    if (this == null) {
      return false;
    } else {
      return isNotEmpty;
    }
  }

  E get firstOrNull => isNotNullAndEmpty ? first : null;

  int get notNullLength => this == null ? 0 : length;
}

extension MapExtension<K, V> on Map<K, V> {
  bool get isNotNullAndEmpty {
    if (this == null) {
      return false;
    } else {
      return isNotEmpty;
    }
  }

  int get notNullLength => this == null ? 0 : length;
}
