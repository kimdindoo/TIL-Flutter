import 'package:calender_scheduler/component/calendar.dart';
import 'package:calender_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calender_scheduler/component/schedule_card.dart';
import 'package:calender_scheduler/component/today_banner.dart';
import 'package:calender_scheduler/const/colors.dart';
import 'package:calender_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: renderFloatingActionButton(),
      body: SafeArea(
        child: Column(
          children: [
            Calender(
              selectedDay: selectedDay,
              focusedDay: focusedDay,
              onDaySelected: onDaySelected,
            ),
            SizedBox(
              height: 8.0,
            ),
            TodayBanner(
              selectedDay: selectedDay,
              scheduleCount: 3,
            ),
            SizedBox(height: 8.0),
            _ScheduleList(
              selectedDate: selectedDay,
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton renderFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true, // 모달 전체창으로 변환
          builder: (_) {
            return ScheduleBottomSheet(
              selectedDate: selectedDay,
            );
          },
        );
      },
      backgroundColor: PRIMARY_COLOR,
      child: Icon(
        Icons.add,
      ),
    );
  }

  onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    print(selectedDay);
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }
}

class _ScheduleList extends StatelessWidget {
  final DateTime selectedDate;

  const _ScheduleList({
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: StreamBuilder<List<Schedule>>(
          stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
          builder: (context, snapshot) {
            print(snapshot.data);
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            if(snapshot.hasData && snapshot.data!.isEmpty){
              return Center(
                child: Text('스케줄이 없습니다.'),
              );
            }

            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 8.0);
              },
              itemBuilder: (context, index) {
                final schedule = snapshot.data![index];

                return ScheduleCard(
                  startTime: schedule.startTime,
                  endTime: schedule.endTime,
                  content: schedule.content,
                  color: Colors.red,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
