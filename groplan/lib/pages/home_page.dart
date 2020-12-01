import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:groplan/pages/add.dart';
import 'package:groplan/pages/calendar.dart';
import 'package:groplan/pages/lists.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'reminders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<String> remindersList = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var prefSearchKey = "userList";
  var remindSearchKey = "remindersList";
  var list;
  Map<DateTime, List> calDays;
  int _selectedIndex = 0;
  Future getStoredReminders() async {
    final SharedPreferences prefs = await _prefs;
    // Reminders remindObj = Reminders("Apples", DateTime.now(), "7");
    // remindersList.add(json.encode(remindObj));
    // prefs.setStringList(remindSearchKey, remindersList);
    remindersList = await prefs.getStringList(remindSearchKey);
    remindersList.forEach((element) {
      setState(() {
        Reminders obj = Reminders.fromJson(jsonDecode(element));
        if (DateTime.parse(obj.dateTime).isBefore(DateTime.now())) {
          remindersList.remove(element);
        }
      });
    });
    return remindersList;
  }

  getCalendarEvents() {
    remindersList.forEach((element) {
      DateTime dt =
          DateTime.parse(Reminders.fromJson(jsonDecode(element)).dateTime);
      DateTime date = DateTime(dt.year, dt.month, dt.day);
      calDays.addAll({
        date: [Reminders.fromJson(jsonDecode(element)).name]
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        if (list == null) {
          getLists();
          return CircularProgressIndicator();
        } else {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return ListsPage(list, _scaffoldKey);
            },
          ));
        }
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return CalendarPage(calDays);
          },
        ));
      }
    });
  }

  Future getLists() async {
    final SharedPreferences prefs = await _prefs;
    list = await prefs.getStringList(prefSearchKey);
    if (list == null) {
      list = List<String>();
      list.add("Tea");
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getStoredReminders();
    });
    getCalendarEvents();
    getLists().then((value) {
      setState(() {
        this.list = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("GroPlan"),
      ),
      body: FutureBuilder<dynamic>(
          future: getStoredReminders(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: remindersList.length,
                  itemBuilder: (context, index) {
                    if (index < remindersList.length) {
                      Reminders robj =
                          Reminders.fromJson(jsonDecode(remindersList[index]));
                      String days = DateTime.parse(robj.dateTime)
                          .difference(DateTime.now())
                          .inDays
                          .toString();
                      return new Column(
                        children: [
                          if (index == 0)
                            Column(
                              children: [
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 30)),
                                    Text(
                                      "Upcoming Reminders",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                  ],
                                )
                              ],
                            ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: 9 * MediaQuery.of(context).size.width / 10,
                            height: 80,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                        Color(0xff3850ec),
                                        Color(0xff54d3f3)
                                      ])),
                                  width: 5,
                                  height: 100,
                                ),
                                Padding(padding: EdgeInsets.only(left: 20)),
                                Text(
                                  robj.name,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Text(
                                  days,
                                  style: TextStyle(
                                      fontSize: 30, color: Color(0xff3850ec)),
                                ),
                                if (int.parse(days) > 1)
                                  Text(" days left")
                                else
                                  Text(" day left"),
                                Padding(
                                  padding: EdgeInsets.only(right: 20),
                                )
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 5,
                                  offset: Offset(0, 7),
                                )
                              ],
                              color: Color(0xffffffff),
                            ),
                          ),
                        ],
                      );
                    }
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          })

      //     Center(
      //         child: Column(
      //   children: <Widget>[
      //     SizedBox(
      //       height: 70,
      //     ),
      //     Image(
      //       image: AssetImage('images/homeImg.png'),
      //     ),
      //     Text(
      //       "No Reminders to Show",
      //       style: TextStyle(fontSize: 28),
      //     ),
      //     Container(
      //       width: 160,
      //       child: Text(
      //         "Click the + button to add new Items now!",
      //         style: TextStyle(fontSize: 15, color: Colors.grey),
      //       ),
      //     )
      //   ],
      // )),
      ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF72C077),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) {
              return AddPage();
            },
          ));
        },
        child: Icon(
          Icons.add,
          size: 40.0,
          color: Color(0xFFFFFFFF),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Color(0xFF72C077),
          unselectedFontSize: 14.0,
          selectedFontSize: 14.0,
          selectedItemColor: Color(0xFF72C077),
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.list,
                ),
                title: Text("My List")),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text("My Calendar"))
          ]),
    );
  }
}
