import 'package:darklet/src/config/config.dart';
import 'package:intl/intl.dart';

/// Formats [value] as currency, e.g. `$1,299.00`.
String money(double value) => NumberFormat.currency(
  symbol: AppConfig.currencySymbol,
  decimalDigits: value == value.roundToDouble() && value >= 100 ? 0 : 2,
).format(value);

String shortDate(DateTime d) => DateFormat.yMMMd().format(d);
String dateTime(DateTime d) => DateFormat.yMMMd().add_jm().format(d);
