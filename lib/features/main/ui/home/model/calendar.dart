import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 13.0),
      child: Card(
        elevation: 8,
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildCustomCalendar(),
              const SizedBox(height: 10),
              const Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              _buildEventList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomCalendar() {
    return Column(
      children: [
        // Calendar header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, 1);
                  });
                },
              ),
              Text(
                DateFormat('MMMM').format(_focusedDay),
                style: GoogleFonts.openSans(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
                  });
                },
              ),
            ],
          ),
        ),

        // Header row with column labels
        Row(
          children: [
            // Week number header (empty)
            SizedBox(width: 30, height: 30),

            // Days of week headers
            ...['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map((day) {
              final isWeekend = day == 'Sa' || day == 'Su';
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.openSans(
                      fontSize: 14.0,
                      color: isWeekend ? Colors.blue : Colors.grey.shade800,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),

        // Calendar grid with week numbers
        ...List.generate(6, (weekIndex) {
          return _buildWeekRow(weekIndex);
        }),
      ],
    );
  }

  Widget _buildWeekRow(int weekIndex) {
    // Calculate first day of the displayed month
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);

    // Calculate the first day of the first week
    final firstDayOfCalendar = firstDayOfMonth.subtract(
        Duration(days: firstDayOfMonth.weekday - 1)
    );

    // Calculate the first day of this week
    final firstDayOfWeek = firstDayOfCalendar.add(Duration(days: 7 * weekIndex));

    // Calculate week number
    final weekNumber = weekIndex + 1;

    return Row(
      children: [
        // Week number indicator
        Container(
          width: 30,
          height: 30,
          margin: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.transparent,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              weekNumber.toString(),
              style: GoogleFonts.openSans(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),

        // Days of the week
        ...List.generate(7, (dayIndex) {
          final date = firstDayOfWeek.add(Duration(days: dayIndex));
          final isToday = isSameDay(date, DateTime.now());
          final isSelected = _selectedDay != null && isSameDay(date, _selectedDay!);
          final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
          final isCurrentMonth = date.month == _focusedDay.month;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDay = date;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.green
                      : isToday
                      ? Colors.blue
                      : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    date.day.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 16.0,
                      color: !isCurrentMonth
                          ? Colors.grey
                          : isSelected || isToday
                          ? Colors.white
                          : isWeekend
                          ? Colors.blue
                          : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemBuilder: (context, index) {
          // Event details based on the image
          final List<Map<String, String>> events = [
            {
              'time': '21h00',
              'endTime': '22h05',
              'title': 'Asynchronous and Non-synchronous In...',
              'presenter': 'Presenter: Ngô Ngọc Sâm',
            },
            {
              'time': '21h00',
              'endTime': '22h05',
              'title': 'Figma',
              'presenter': 'Presenter: Nguyễn Bích Loan',
            },
            {
              'time': '21h00',
              'endTime': '22h05',
              'title': 'Critical Designing',
              'presenter': 'Presenter: Đỗ Mạnh Cường',
            },
          ];

          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            elevation: 0, // Remove shadow to match the design
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        events[index]['time']!,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: 1, // Width of the vertical line
                        height: 10, // Height of the vertical line
                        color: Colors.black, // Color of the vertical line
                      ),
                      const SizedBox(height: 2),
                      Text(
                        events[index]['endTime']!,
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12), // Space between time and the vertical line
                  // Vertical line
                  Container(
                    width: 1, // Width of the vertical line
                    height: 54, // Height of the vertical line
                    color: Colors.grey[300], // Color of the vertical line
                  ),
                  const SizedBox(width: 12), // Space between the vertical line and event details
                  // Event information column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          events[index]['title']!,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          events[index]['presenter']!,
                          style: GoogleFonts.openSans(
                            color: Colors.grey[600],
                            fontSize: 12.0,
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

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:table_calendar/table_calendar.dart';
//
// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({super.key});
//
//   @override
//   State<CalendarScreen> createState() => _CalendarScreenState();
// }
//
// class _CalendarScreenState extends State<CalendarScreen> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 19.0, vertical: 13.0),
//       child: Container(
//         height: 500,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey, width: 1.0),
//           borderRadius: BorderRadius.circular(16.0),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             TableCalendar(
//               startingDayOfWeek: StartingDayOfWeek.monday,
//               firstDay: DateTime.utc(2010, 1, 1),
//               lastDay: DateTime.utc(2030, 12, 31),
//               focusedDay: _focusedDay,
//               calendarFormat: _calendarFormat,
//               selectedDayPredicate: (day) {
//                 return isSameDay(_selectedDay, day);
//               },
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               onFormatChanged: (format) {
//                 setState(() {
//                   _calendarFormat = format;
//                 });
//               },
//               onPageChanged: (focusedDay) {
//                 _focusedDay = focusedDay;
//               },
//               rowHeight: 35.0,
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//                 titleTextStyle: GoogleFonts.openSans(
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.normal,
//                   color: Colors.black,
//                 ),
//                 leftChevronIcon: Icon(Icons.chevron_left, color: Colors.black),
//                 rightChevronIcon: Icon(Icons.chevron_right, color: Colors.black),
//               ),
//               daysOfWeekStyle: DaysOfWeekStyle(
//                 weekdayStyle: GoogleFonts.openSans(
//                   fontSize: 14.0,
//                   color: Colors.grey[800],
//                 ),
//                 weekendStyle: GoogleFonts.openSans(
//                   fontSize: 14.0,
//                   color: Colors.blue,
//                 ),
//               ),
//               calendarStyle: CalendarStyle(
//                 defaultTextStyle: GoogleFonts.openSans(
//                   fontSize: 16.0,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 weekendTextStyle: GoogleFonts.openSans(
//                   fontSize: 16.0,
//                   color: Colors.blue,
//                 ),
//                 selectedTextStyle: GoogleFonts.openSans(
//                   fontSize: 16.0,
//                   color: Colors.white,
//                 ),
//                 todayTextStyle: GoogleFonts.openSans(
//                   fontSize: 16.0,
//                   color: Colors.white,
//                 ),
//                 outsideTextStyle: GoogleFonts.openSans(
//                   fontSize: 16.0,
//                   color: Colors.grey,
//                 ),
//                 todayDecoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: Colors.green,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//               availableGestures: AvailableGestures.all,
//               weekNumbersVisible: true,
//             ),
//             const SizedBox(height: 10),
//             const Divider(
//               color: Colors.black,
//               thickness: 1.0,
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '21h00 - 22h05',
//                             style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
//                           ),
//                           Text(
//                             'Event Title $index',
//                             style: GoogleFonts.openSans(),
//                           ),
//                           Text(
//                             'Presenter: Someone',
//                             style: GoogleFonts.openSans(),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
