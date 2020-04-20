import 'package:charts_flutter/flutter.dart'  as charts;
import 'package:flutter/foundation.dart';

class Chart{
  final String subject;
  final int percentage;
  final charts.Color barColor;
  Chart({
      @required this.subject,
      @required this.percentage,
      @required this.barColor,
});

}