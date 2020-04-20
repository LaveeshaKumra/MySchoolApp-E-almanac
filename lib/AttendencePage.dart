import 'package:flutter/material.dart';
import 'package:school/CalenderPage.dart';
import 'Chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Attendence extends StatefulWidget {
  @override
  _AttendenceState createState() => _AttendenceState();
}


List<Chart> attendenceData=[
  Chart(
      subject:"English",
      percentage :80,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue)
  ),
  Chart(
      subject:"Maths",
      percentage :85,
      barColor: charts.ColorUtil.fromDartColor(Colors.orangeAccent)
  ),
  Chart(
      subject:"Science",
      percentage :75,
      barColor: charts.ColorUtil.fromDartColor(Colors.red)
  ),
  Chart(
      subject:"Social Science",
      percentage :75,
      barColor: charts.ColorUtil.fromDartColor(Colors.purple)
  ),
  Chart(
      subject:"Physical Education",
      percentage :75,
      barColor: charts.ColorUtil.fromDartColor(Colors.yellow)
  ),
  Chart(
      subject:"Hindi",
      percentage :75,
      barColor: charts.ColorUtil.fromDartColor(Colors.pink)
  ),

];


class _AttendenceState extends State<Attendence> {

  List<charts.Series<Chart,String>> series=[
    charts.Series(
      id:"Chart",
      data:attendenceData,
      domainFn: (Chart series,_)=>
      series.subject,
      measureFn: (Chart series,_)=>series.percentage,
      colorFn: (Chart series,_)=>series.barColor,
      labelAccessorFn: (Chart series,_)=>'${series.subject}: ${series.percentage.toString()}\%',
    )
  ];
//  height: MediaQuery.of(context).size.height * 0.68,
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendence"),
        backgroundColor:Colors.deepOrange,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.68,
          child: charts.BarChart(
            series,
            animate: true,
            vertical: false,
            selectionModels: [
              charts.SelectionModelConfig(
                changedListener: (charts.SelectionModel model){
                  if(model.hasDatumSelection){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CalenderPage(model.selectedSeries[0].domainFn(model.selectedDatum[0].index)),
                    ));
                    //print(model.selectedSeries[0].domainFn(model.selectedDatum[0].index));
                }
                  }
              )
            ],
            barRendererDecorator: new charts.BarLabelDecorator<String>(),
            domainAxis:
            new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
          ),
        ),
      ),
    );
  }
}
