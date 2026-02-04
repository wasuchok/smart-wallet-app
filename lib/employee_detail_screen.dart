import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'constants/app_colors.dart';
import 'employee_list_screen.dart'; // To access Employee and AttendanceStatus

class EmployeeDetailScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailScreen({super.key, required this.employee});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  DateTime _selectedDate = DateTime.now();
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('th');
    _displayedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildLegend(),
            const SizedBox(height: 16),
            _buildHeatmap(),
            const SizedBox(height: 16),
            _buildActionPanel(),
            const SizedBox(height: 16),
            _buildSummaryStats(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + kToolbarHeight + 16,
        bottom: 32,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(
              FontAwesomeIcons.userLarge,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.employee.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.employee.position,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLegendItem('ทำงาน', Colors.green),
          const SizedBox(width: 16),
          _buildLegendItem('เบิกค่าแรง', Colors.orange),
          const SizedBox(width: 16),
          _buildLegendItem('วันหยุด/ขาด', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildHeatmap() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;

    // Generate dates for the displayed month
    final monthStart = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final nextMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      1,
    );
    final daysInMonth = nextMonth.difference(monthStart).inDays;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _prevMonth,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              Text(
                DateFormat('MMMM yyyy', 'th').format(_displayedMonth),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              const double spacing = 6.0;
              final int firstWeekday = monthStart.weekday; // 1..7
              final int offset = firstWeekday - 1;
              final int totalSlots = offset + daysInMonth;
              final int columns = (totalSlots / 7).ceil();

              // Reserve width for day labels (Thai abbreviations need more space)
              final double labelWidth = 48.0;
              final double availableWidth =
                  constraints.maxWidth - labelWidth - 8; // 8px gap

              final double cellSize =
                  (availableWidth - spacing * (columns - 1)) / columns;
              final double heatmapHeight = (cellSize * 7) + (spacing * 6);

              final dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: labelWidth,
                    child: Column(
                      children: List.generate(7, (i) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: i == 6 ? 0 : spacing,
                          ),
                          child: SizedBox(
                            height: cellSize,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: _buildDayLabel(dayLabels[i], cellSize),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: heatmapHeight,
                    width: availableWidth,
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: spacing,
                      runSpacing: spacing,
                      children: _buildHeatmapGridItems(
                        monthStart,
                        daysInMonth,
                        cellSize,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionPanel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final date = _selectedDate;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.calendarCheck,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                DateFormat('EEEE, d MMMM yyyy', 'th').format(date),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildActionButton(
                'ทำงาน',
                AttendanceStatus.worked,
                Colors.green,
                date,
              ),
              _buildActionButton(
                'เบิกค่าแรง',
                AttendanceStatus.advance,
                Colors.orange,
                date,
              ),
              _buildActionButton(
                'วันหยุด/ขาด',
                AttendanceStatus.absent,
                Colors.red,
                date,
              ),
              _buildActionButton(
                'ลบสถานะ',
                null,
                Colors.grey,
                date,
                isOutline: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    String? status,
    Color color,
    DateTime date, {
    bool isOutline = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentStatus = _getAttendanceStatus(date);

    // Check if the specific status is active in the current composite status
    bool isActive = false;
    if (status != null && currentStatus != null) {
      isActive = currentStatus.split(',').contains(status);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            final key = DateTime(date.year, date.month, date.day);
            if (status == null) {
              // Clear all status
              widget.employee.attendance.remove(key);
            } else {
              // Toggle logic
              List<String> statuses = currentStatus?.split(',') ?? [];

              if (statuses.contains(status)) {
                statuses.remove(status);
              } else {
                // Handle exclusivity
                if (status == AttendanceStatus.worked) {
                  statuses.remove(AttendanceStatus.absent);
                } else if (status == AttendanceStatus.absent) {
                  statuses.remove(AttendanceStatus.worked);
                }
                statuses.add(status);
              }

              if (statuses.isEmpty) {
                widget.employee.attendance.remove(key);
              } else {
                widget.employee.attendance[key] = statuses.join(',');
              }
            }
          });
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isOutline
                ? Colors.transparent
                : (isActive ? color : color.withValues(alpha: 0.1)),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isOutline
                  ? (isDark ? Colors.grey.shade600 : Colors.grey.shade400)
                  : (isActive ? color : color.withValues(alpha: 0.5)),
              width: isOutline ? 1 : 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isActive) ...[
                Icon(Icons.check, size: 16, color: Colors.white),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isOutline
                      ? (isDark ? Colors.grey.shade400 : Colors.grey.shade600)
                      : (isActive ? Colors.white : color),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayLabel(String day, double cellSize) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: cellSize,
      child: Text(
        day,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildHeatmapCell(DateTime date, double cellSize) {
    final statusStr = _getAttendanceStatus(date);
    final statuses = statusStr?.split(',') ?? [];

    Color? color;
    Gradient? gradient;

    // Default color (empty day)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    color = isDark ? Colors.grey.shade800 : Colors.grey.shade200;

    if (statuses.contains(AttendanceStatus.worked) &&
        statuses.contains(AttendanceStatus.advance)) {
      color = null;
      gradient = const LinearGradient(
        colors: [Colors.green, Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (statuses.contains(AttendanceStatus.absent) &&
        statuses.contains(AttendanceStatus.advance)) {
      color = null;
      gradient = LinearGradient(
        colors: [Colors.red.withValues(alpha: 0.8), Colors.orange],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (statuses.contains(AttendanceStatus.worked)) {
      color = Colors.green;
    } else if (statuses.contains(AttendanceStatus.advance)) {
      color = Colors.orange;
    } else if (statuses.contains(AttendanceStatus.absent)) {
      color = Colors.red.withValues(alpha: 0.4);
    }

    final isSelected =
        date.year == _selectedDate.year &&
        date.month == _selectedDate.month &&
        date.day == _selectedDate.day;

    return Tooltip(
      message:
          '${date.day}/${date.month}/${date.year}: ${statusStr ?? "ไม่มีข้อมูล"}',
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDate = date;
          });
        },
        borderRadius: BorderRadius.circular(3),
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            color: color,
            gradient: gradient,
            borderRadius: BorderRadius.circular(3),
            border: isSelected
                ? Border.all(
                    color: isDark ? Colors.white : Colors.black,
                    width: 2,
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (isDark ? Colors.white : Colors.black).withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }

  // Helper to handle the grid alignment correctly
  // We need to pad the start of the month so the 1st aligns with its weekday
  List<Widget> _buildHeatmapGridItems(
    DateTime startDate,
    int dayCount,
    double cellSize,
  ) {
    final List<Widget> items = [];

    // Calculate offset for the first week (Monday = 1)
    // We want the grid to start at Monday.
    int firstWeekday = startDate.weekday; // 1 (Mon) to 7 (Sun)

    // Add empty placeholders for days before the 1st in the first column
    for (int i = 1; i < firstWeekday; i++) {
      items.add(SizedBox(width: cellSize, height: cellSize));
    }

    // Add actual days
    for (int i = 0; i < dayCount; i++) {
      items.add(_buildHeatmapCell(startDate.add(Duration(days: i)), cellSize));
    }

    return items;
  }

  String? _getAttendanceStatus(DateTime day) {
    // Normalize date to ignore time
    final date = DateTime(day.year, day.month, day.day);

    // Check direct match
    if (widget.employee.attendance.containsKey(date)) {
      return widget.employee.attendance[date];
    }

    // For demo: if not in map, assume absent if it's a weekday in the past, otherwise null
    if (date.isBefore(DateTime.now()) && date.weekday <= 5) {
      // Just returning null for no data to avoid cluttering the calendar with assumed absences
      // or we can default to 'absent' if that's the logic.
      // For this demo, let's only show what's in the map + maybe some defaults for current month
      return null;
    }

    return null;
  }

  Widget _buildSummaryStats() {
    int worked = 0;
    int advance = 0;
    int absent = 0;

    // Calculate stats for the displayed month
    widget.employee.attendance.forEach((date, statusStr) {
      if (date.year == _displayedMonth.year &&
          date.month == _displayedMonth.month) {
        final statuses = statusStr.split(',');
        if (statuses.contains(AttendanceStatus.worked)) worked++;
        if (statuses.contains(AttendanceStatus.advance)) advance++;
        if (statuses.contains(AttendanceStatus.absent)) absent++;
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('ทำงาน', '$worked วัน', Colors.green)),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('เบิกค่าแรง', '$advance วัน', Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard('วันหยุด/ขาด', '$absent วัน', Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.surfaceDark : Colors.white;
    final titleColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(top: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: titleColor)),
        ],
      ),
    );
  }
}
