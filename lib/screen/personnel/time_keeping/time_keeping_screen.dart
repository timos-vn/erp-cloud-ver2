import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:sse/screen/personnel/time_keeping/component/home_test.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_bloc.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_event.dart';
import 'package:sse/screen/personnel/time_keeping/time_keeping_state.dart';
import 'package:sse/utils/extension/upper_case_to_title.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../themes/colors.dart';
import '../../../utils/const.dart';
import '../../../utils/utils.dart';
import '../../widget/custom_question.dart';
import '../../widget/pending_action.dart';

class TimeKeepingScreen extends StatefulWidget {
  const TimeKeepingScreen({Key? key}) : super(key: key);

  @override
  _TimeKeepingScreenState createState() => _TimeKeepingScreenState();
}

class _TimeKeepingScreenState extends State<TimeKeepingScreen> {

  late TimeKeepingBloc _bloc;

  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final _controller = ScrollController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (_controller.position.atEdge) {
        bool isTop = _controller.position.pixels == 0;
        if (isTop) {
          print('At the top');
        } else {
          print('At the bottom');
        }
      }
    });

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
    _bloc = TimeKeepingBloc(context);
    // _bloc.dateFrom =  DateTime.now().add(Duration(days: -30));
    // _bloc.dateTo =  DateTime.now();
    _bloc.add(GetPrefsTimeKeeping());
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }


  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: FloatingActionButton(
          onPressed:() {
            showDialog(
                context: context,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async => false,
                    child: CustomQuestionComponent(
                      showTwoButton: true,
                      iconData: Icons.warning_amber_outlined,
                      title: 'Bạn đang thực hiện chấm công!!!',
                      content: 'Thời gian chấm công: ${DateTime.now().hour}:${DateTime.now().minute < 10 ? ('0' + DateTime.now().minute.toString()) :DateTime.now().minute  }:${DateTime.now().second}',
                    ),
                  );
                }).then((value)async{
              if(value != null){
                if(!Utils.isEmpty(value) && value == 'Yeah'){
                  _bloc.add(LoadingTimeKeeping(uId: Const.uId));
                }
              }
            });
          } ,
          backgroundColor: mainColor,
          tooltip: 'Increment',
          child: Icon(Icons.app_registration,color: Colors.white,),
        ),
      ),
      body: BlocListener<TimeKeepingBloc,TimeKeepingState>(
        bloc: _bloc,
        listener: (context, state){
          if(state is GetPrefsSuccess){
           // _bloc.add(GetListDNC(dateFrom: Utils.parseDateToString(_bloc.dateFrom, Const.DATE_SV_FORMAT),dateTo: Utils.parseDateToString(_bloc.dateTo, Const.DATE_SV_FORMAT),type: _bloc.transactionType));
          }
        },
        child: BlocBuilder<TimeKeepingBloc,TimeKeepingState>(
          bloc: _bloc,
          builder: (BuildContext context, TimeKeepingState state){
            return Stack(
              children: [
                buildBody(context, state),
                // Visibility(
                //   visible: state is GetListDNCEmpty,
                //   child: Center(
                //     child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                //   ),
                // ),
                Visibility(
                  visible: state is TimeKeepingLoading,
                  child: PendingAction(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,TimeKeepingState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.shade200,
                        offset: Offset(2, 4),
                        blurRadius: 5,
                        spreadRadius: 2)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [subColor,Color.fromARGB(255, 150, 185, 229)])),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TableCalendar<Event>(
                    rowHeight: 70,
                    daysOfWeekHeight: 20,

                    simpleSwipeConfig: SimpleSwipeConfig(
                      verticalThreshold: 0.2,
                      swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
                    ),
                    calendarBuilders: CalendarBuilders(
                        // todayBuilder: (context, date, _){
                        //   return Padding(
                        //     padding: const EdgeInsets.only(bottom: 11),
                        //     child: Container(
                        //       decoration: new BoxDecoration(
                        //         color: mainColor.withOpacity(0.8),
                        //         shape: BoxShape.circle,
                        //       ),
                        //       // margin: const EdgeInsets.all(4.0),
                        //       width: 45,
                        //       height: 45,
                        //       child: Center(
                        //         child: Text(
                        //           '${date.day}',
                        //           style: TextStyle(
                        //             fontSize: 16.0,
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   );
                        // },
                        selectedBuilder: (context, date, _) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 11),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                // borderRadius: BorderRadius.circular(150)
                              ),
                              // margin: const EdgeInsets.all(4.0),
                              width: 45,
                              height: 45,
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: mainColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        markerBuilder: (context,date, event){
                          return Container(
                            margin: const EdgeInsets.only(top: 10,bottom: 0),
                            padding: const EdgeInsets.all(1),
                            height: 12,
                            child: Icon(MdiIcons.emoticonPoop,color: Colors.blueGrey.withOpacity(0.2),),
                          );
                        }
                    ),
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    formatAnimationCurve: Curves.elasticInOut,
                    formatAnimationDuration: Duration(milliseconds: 500),
                    calendarFormat: _calendarFormat,
                    rangeSelectionMode: _rangeSelectionMode,
                    eventLoader: _getEventsForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    onHeaderTapped: (_){
                      print(_);
                    },
                    locale: 'vi',
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: GoogleFonts.montserrat(
                        color: Colors.white,
                      ),
                    weekdayStyle: GoogleFonts.montserrat(
                        color: Colors.white54,
                    )
                  ),
                    headerVisible: false,
                    // headerStyle: HeaderStyle(
                    //   leftChevronIcon: Icon(Icons.arrow_back_ios, size: 15, color: Colors.black),
                    //   rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 15, color: Colors.black),
                    //   titleTextStyle: GoogleFonts.montserrat(
                    //       color: Colors.yellow,
                    //       fontSize: 16),
                    //   titleCentered: true,
                    //   formatButtonDecoration: BoxDecoration(
                    //     color: Colors.white60,
                    //     borderRadius: BorderRadius.circular(20),
                    //   ),
                    //   formatButtonVisible: false,
                    //   formatButtonTextStyle: GoogleFonts.montserrat(
                    //       color: Colors.black,
                    //       fontSize: 13,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    calendarStyle: CalendarStyle(
                       // selectedTextStyle: TextStyle(
                       //   backgroundColor: Colors.white,
                       //   color: mainColor
                       // ),
                        todayTextStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16),
                        weekendTextStyle: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16),
                        outsideTextStyle: TextStyle(color: Colors.white),
                        withinRangeTextStyle: TextStyle(color: Colors.grey),
                        defaultTextStyle: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 16),
                        canMarkersOverflow: true,
                        outsideDaysVisible: false,
                        holidayTextStyle: TextStyle(
                            color: Colors.yellow
                        )
                    ),
                    onDaySelected: _onDaySelected,
                    onRangeSelected: _onRangeSelected,
                    onFormatChanged: (format) {

                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                      });
                    },
                  ),
                  Divider(color: Colors.white,),
                  Padding(
                    padding: const EdgeInsets.only(left: 12,top: 12,bottom: 16),
                    child: Text('Lịch sử chấm công của bạn', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          controller: _controller,
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 65,width: double.infinity,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blueGrey.withOpacity(0.8)),

                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      width:13,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
                                        color: Colors.red
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 8,top: 12,bottom: 5),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Unusual time',style:TextStyle(color: Colors.white30),),
                                          const SizedBox(height: 5,),
                                          Text('${value[index]}',style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )

                              // ListTile(
                              //   onTap: () => print('${value[index]}'),
                              //   title: Text('Unusual time',style:TextStyle(color: Colors.white54),),
                              //   subtitle: Text('Unusual time',style:TextStyle(color: Colors.white54),),
                              // ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildAppBar(){
    return Container(
      height: 83,
      width: double.infinity,
      decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [subColor,Color.fromARGB(255, 150, 185, 229)])),
      padding: const EdgeInsets.fromLTRB(5, 35, 12,0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: ()=> Navigator.pop(context),
            child: Container(
              width: 40,
              height: 50,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                "${DateFormat.yMMMM('vi').format(_focusedDay).toTitleCase()}",
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,),
                maxLines: 1,overflow: TextOverflow.fade,
              ),
            ),
          ),
          Container(
            width: 40,
            height: 50,
            child: Icon(
              Icons.event,
              size: 25,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
