import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'constants/app_colors.dart';
import 'widgets/custom_header_background.dart';
import 'widgets/transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock Data keyed by DateTime (normalized to midnight)
  late final Map<DateTime, List<Map<String, dynamic>>> _events;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _initializeEvents();
  }

  void _initializeEvents() {
    // Helper to create date without time
    DateTime date(int year, int month, int day) => DateTime(year, month, day);

    _events = {
      date(2026, 1, 20): [
        {
          'title': 'ซื้ออาหารกลางวัน',
          'date': '2026-01-20 12:30',
          'amount': -150.00,
          'category': 'อาหาร',
          'icon': FontAwesomeIcons.bowlFood,
          'color': Colors.orange,
        },
        {
          'title': 'ค่าเดินทาง BTS',
          'date': '2026-01-20 18:00',
          'amount': -45.00,
          'category': 'เดินทาง',
          'icon': FontAwesomeIcons.trainSubway,
          'color': Colors.green,
        },
      ],
      date(2026, 1, 25): [
        {
          'title': 'เงินเดือนเข้า',
          'date': '2026-01-25 09:00',
          'amount': 25000.00,
          'category': 'รายรับ',
          'icon': FontAwesomeIcons.moneyBillWave,
          'color': Colors.blue,
        },
      ],
      date(2026, 1, 19): [
        {
          'title': 'กาแฟ',
          'date': '2026-01-19 08:00',
          'amount': -80.00,
          'category': 'เครื่องดื่ม',
          'icon': FontAwesomeIcons.mugHot,
          'color': Colors.brown,
        },
      ],
      date(2025, 12, 31): [
        {
          'title': 'ปาร์ตี้ปีใหม่',
          'date': '2025-12-31 20:00',
          'amount': -2000.00,
          'category': 'สังสรรค์',
          'icon': FontAwesomeIcons.champagneGlasses,
          'color': Colors.purple,
        },
      ],
    };
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    // Normalize day to midnight for comparison
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  Widget _buildDailySummary(List<Map<String, dynamic>> events) {
    double income = 0;
    double expense = 0;

    for (var event in events) {
      final amount = event['amount'] as double;
      if (amount > 0) {
        income += amount;
      } else {
        expense += amount.abs();
      }
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รายรับ',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '+${NumberFormat('#,##0.00').format(income)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'รายจ่าย',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '-${NumberFormat('#,##0.00').format(expense)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedEvents = _getEventsForDay(_selectedDay ?? _focusedDay);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          'ปฏิทินธุรกรรม',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Background Extension
          const CustomHeaderBackground(height: 20, borderRadius: 24),

          // Calendar Section (Shifted up to overlap header)
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                locale: 'th_TH',
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: _getEventsForDay,
                calendarStyle: CalendarStyle(
                  markersMaxCount: 1,
                  markerDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left,
                    color: AppColors.primary,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isEmpty) return null;

                    bool hasIncome = false;
                    bool hasExpense = false;

                    for (var event in events) {
                      final e = event as Map<String, dynamic>;
                      if ((e['amount'] as double) > 0) hasIncome = true;
                      if ((e['amount'] as double) < 0) hasExpense = true;
                    }

                    return Positioned(
                      bottom: 1,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasIncome)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.5,
                              ),
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          if (hasExpense)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.5,
                              ),
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Daily Summary
          _buildDailySummary(selectedEvents),

          // Transaction List for Selected Day
          Expanded(child: _buildTransactionList()),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                FontAwesomeIcons.fileInvoiceDollar,
                size: 48,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ไม่มีรายการในวันนี้',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: events.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tx = events[index];
        final isExpense = (tx['amount'] as double) < 0;
        final date = DateTime.parse(tx['date']);

        final formattedAmount =
            '${isExpense ? '' : '+'}${NumberFormat('#,##0.00').format(tx['amount'])}';

        return TransactionTile(
          title: tx['title'],
          subtitle: DateFormat('HH:mm').format(date),
          amount: formattedAmount,
          amountColor: isExpense ? Colors.red : AppColors.primary,
          trailingSubtitle: tx['category'],
          icon: tx['icon'] as IconData,
          iconColor: tx['color'] as Color,
        );
      },
    );
  }
}
