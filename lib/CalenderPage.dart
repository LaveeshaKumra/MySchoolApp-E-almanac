import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';


class CalenderPage extends StatefulWidget {
  var subject;
  CalenderPage(data){
    this.subject=data;
  }
  @override
  _CalenderPageState createState() => _CalenderPageState(this.subject);
}



class _CalenderPageState extends State<CalenderPage> {

  List<DateTime> presentDates = [
    DateTime(2020, 4, 1),
    DateTime(2020, 4, 3),
    DateTime(2020, 4, 4),
    DateTime(2020, 4, 5),
    DateTime(2020, 4, 6),
    DateTime(2020, 4, 9),
    DateTime(2020, 4, 10),
    DateTime(2020, 4, 11),
  ];
  List<DateTime> absentDates = [
    DateTime(2020, 4, 2),
    DateTime(2020, 4, 7),
    DateTime(2020, 4, 8),
    DateTime(2020, 4, 12),
    DateTime(2020, 4, 13),
    DateTime(2020, 4, 14),
  ];
  DateTime _currentDate2 = DateTime.now();
  var subject;

  static Widget _presentIcon(String day) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  static Widget _absentIcon(String day) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );

  EventList<Event> _markedDateMap = new EventList<Event>(
    events: {},
  );

  CalendarCarousel _calendarCarouselNoHeader;

  double cHeight;

  _CalenderPageState(data) {
    this.subject = data;
  }

  @override
  Widget build(BuildContext context) {
    cHeight = MediaQuery
        .of(context)
        .size
        .height;
    for (int i = 0; i < presentDates.length; i++) {
      _markedDateMap.add(
        presentDates[i],
        new Event(
          date: presentDates[i],
          title: 'Event 5',
          icon: _presentIcon(
            presentDates[i].day.toString(),
          ),
        ),
      );
    }

    for (int i = 0; i < absentDates.length; i++) {
      _markedDateMap.add(
        absentDates[i],
        new Event(
          date: absentDates[i],
          title: 'Event 5',
          icon: _absentIcon(
            absentDates[i].day.toString(),
          ),
        ),
      );
    }


    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      height: cHeight * 0.65,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      todayButtonColor: Colors.blue[200],
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal:
      null,
      // null for not showing hidden events indicator
      markedDateIconBuilder: (event) {
        return event.icon;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("$subject Attendence"),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _calendarCarouselNoHeader,
            markerRepresent(Colors.red, "Absent"),
            markerRepresent(Colors.green, "Present"),
          ],
        ),
      ),
    );
  }


  Widget markerRepresent(Color color, String data) {
    return new ListTile(
      leading: new CircleAvatar(
        backgroundColor: color,
        radius: cHeight * 0.022,
      ),
      title: new Text(
        data,
      ),
    );
  }
}