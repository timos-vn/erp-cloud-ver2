import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
import 'package:sse/screen/dms/check_in/check_in_event.dart';
import 'package:sse/utils/const.dart';
import 'package:sse/utils/extension/upper_case_to_title.dart';
import 'package:sse/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../themes/colors.dart';
import '../../personnel/time_keeping/component/home_test.dart';
import '../../widget/pending_action.dart';
import 'check_in_bloc.dart';
import 'check_in_state.dart';


class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {

  late CheckInBloc _bloc;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final _controller = ScrollController();
  late final ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = CheckInBloc(context);
    _bloc.add(GetPrefsCheckIn());

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
        print(_selectedDay);print(_focusedDay);
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CheckInBloc,CheckInState>(
        bloc: _bloc,
        listener: (context,state){
          if(state is GetPrefsSuccess){
            _bloc.add(GetListCheckIn(dateTime: _selectedDay??_focusedDay));
          }
        },
        child: BlocBuilder<CheckInBloc,CheckInState>(
          bloc: _bloc,
          builder: (BuildContext context, CheckInState state){
            return Stack(
              children: [
                buildBody(context,state),
                Visibility(
                  visible: state is CheckInLoading,
                  child: PendingAction(),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  buildBody(BuildContext context,CheckInState state){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          buildAppBar(),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 16),
              // decoration: BoxDecoration(
              //     boxShadow: <BoxShadow>[
              //       BoxShadow(
              //           color: Colors.grey.shade200,
              //           offset: Offset(2, 4),
              //           blurRadius: 5,
              //           spreadRadius: 2)
              //     ],
              //     gradient: LinearGradient(
              //         begin: Alignment.centerLeft,
              //         end: Alignment.centerRight,
              //         colors: [subColor,Color.fromARGB(255, 150, 185, 229)])),
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
                                color: Colors.black.withOpacity(0.7),
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
                                    color: Colors.white,
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
                            child: Icon(MdiIcons.emoticonPoop,color: Colors.blueGrey.withOpacity(0.5),),
                          );
                        }
                    ),
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    // rangeStartDay: _rangeStart,
                    // rangeEndDay: _rangeEnd,
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
                          color: Colors.red,
                        ),
                        weekdayStyle: GoogleFonts.montserrat(
                          color: Colors.black,
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
                            color: Colors.black,
                            fontSize: 16),
                        weekendTextStyle: GoogleFonts.montserrat(
                            color: Colors.red,
                            fontSize: 16),
                        outsideTextStyle: TextStyle(color: Colors.blueGrey),
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
                    // onRangeSelected: _onRangeSelected,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 12,top: 16,bottom: 16),
                    child: Text('Khách hàng cần check-in trong ngày', style: TextStyle(color: subColor, fontWeight: FontWeight.bold),),
                  ),
                  Visibility(
                    visible: state is GetListSCheckInEmpty,
                    child: Expanded(
                      child: Center(
                        child: Text('Úi, Đại Vương dữ liệu trống!!!',style: TextStyle(color: Colors.blueGrey)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: state is GetListCheckInSuccess,
                    child: Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        controller: _controller,
                        itemCount: _bloc.listCheckInToDay.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: ()=>showBottomSheet(),
                            child: Container(
                                height: 120,width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),

                                child: Row(
                                  children: [
                                    Container(
                                      width:13,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12),bottomLeft: Radius.circular(12)),
                                          color: kPrimaryColor
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.only(topRight: Radius.circular(12),bottomRight: Radius.circular(12)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8,right: 12,top: 8,bottom: 12),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(child: Text('${_bloc.listCheckInToDay[index].tenKh}',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),),
                                                  const SizedBox(width: 5,),
                                                  Text('${_bloc.listCheckInToDay[index].gps != '' ? _bloc.listCheckInToDay[index].gps : 0} Km',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.red),)
                                                ],
                                              ),
                                              const SizedBox(height: 9,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(MdiIcons.mapMarkerRadiusOutline,color: subColor,size: 16,),
                                                  const SizedBox(width: 5,),
                                                  Flexible(child: Text('${_bloc.listCheckInToDay[index].diaChi}',style:TextStyle(color: Colors.blueGrey,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(MdiIcons.phoneClassic,color: subColor,size: 16,),
                                                  const SizedBox(width: 5,),
                                                  Flexible(child: Text('${_bloc.listCheckInToDay[index].dienThoai}',style:TextStyle(color: Colors.blueGrey,fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                              const SizedBox(height: 5,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(MdiIcons.calendarCheckOutline,color: subColor,size: 16,),
                                                  const SizedBox(width: 5,),
                                                  Flexible(
                                                      child: Text('${_bloc.listCheckInToDay[index].trangThai?.trim() == 'Hoàn thành'
                                                          ?
                                                      'Đã viếng thăm lúc: ${Utils.parseDateTToString(_bloc.listCheckInToDay[index].tgHoanThanh.toString(), Const.TIME)}'
                                                          :
                                                      'Chưa viếng thăm'}',
                                                       style:TextStyle(
                                                           color: _bloc.listCheckInToDay[index].trangThai?.trim() == 'Hoàn thành' ? Colors.black : Colors.red,
                                                           fontSize: 12),maxLines: 2,overflow: TextOverflow.ellipsis,)),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                              // ListTile(
                              //   onTap: () => print('${value[index]}'),
                              //   ,
                              //   subtitle: Text('Unusual time',style:TextStyle(color: Colors.white54),),
                              // ),
                            ),
                          );
                        },
                      ),
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

  void showBottomSheet(){
    showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
        ),
        backgroundColor: Colors.white,
        builder: (builder){
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.52,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)
                )
            ),
            margin: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(
              builder: (BuildContext context,StateSetter myState){
                return Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 0),
                  child: Container(
                    decoration:const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25)
                        )
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 8,right: 18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: ()=> Navigator.pop(context),
                                  child: const Icon(Icons.close,color: Colors.white,)),
                              Text('Thêm tuỳ chọn',style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w800),),
                              InkWell(
                                  onTap: ()=> Navigator.pop(context),
                                  child: const Icon(Icons.check,color: Colors.black,)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5,),
                        const Divider(color: Colors.blueGrey,),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  // color: Colors.blueGrey,
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap:()=>Navigator.pop(context,'1'),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,bottom: 10,left: 10,right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
                                                Text('Gọi cho Khách hàng',style: TextStyle(color: Colors.black),),
                                                Icon(Icons.phone_callback_outlined,color: Colors.red,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap:()=>Navigator.pop(context,'2'),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,bottom: 10,left: 10,right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const[
                                                Text('Đón khách thành công',style: TextStyle(color: Colors.black),),
                                                Icon(Icons.how_to_reg,color: Colors.orange,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: InkWell(
                                        onTap:()=>Navigator.pop(context,'3'),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,bottom: 10,left: 10,right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children:const [
                                                Text('Không đón được khách (Khách huỷ)',style: TextStyle(color: Colors.black),),
                                                Icon(MdiIcons.accountCancelOutline,color: Colors.red,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap:()=>Navigator.pop(context,'4'),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 12,bottom: 10,left: 10,right: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: const [
                                                Text('Tài xế huỷ chuyến',style: TextStyle(color: Colors.black),),
                                                Icon(MdiIcons.accountRemoveOutline,color: Colors.black,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
    ).then((value)async{

    });
  }
}
