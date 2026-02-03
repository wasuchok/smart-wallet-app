import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'constants/app_colors.dart';
import 'widgets/count_up_text.dart';
import 'widgets/custom_header_background.dart';
import 'widgets/section_title.dart';
import 'widgets/transaction_tile.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String _chartFilter = 'สัปดาห์นี้';

  final Map<String, dynamic> _data = {
    'วันนี้': {
      'balance': 1500.00,
      'income': 2000.00,
      'expense': 500.00,
      'chartData': [10.0, 15.0, 5.0, 20.0, 10.0, 30.0, 10.0],
      'transactions': [
        {
          'title': 'อาหารเช้า',
          'date': 'วันนี้, 08:30',
          'amount': '- ฿ 60.00',
          'icon': FontAwesomeIcons.bowlFood,
          'color': Colors.orange,
          'isExpense': true,
        },
        {
          'title': 'กาแฟ',
          'date': 'วันนี้, 10:15',
          'amount': '- ฿ 80.00',
          'icon': FontAwesomeIcons.mugHot,
          'color': Colors.brown,
          'isExpense': true,
        },
      ],
    },
    'สัปดาห์นี้': {
      'balance': 12345.00,
      'income': 25000.00,
      'expense': 12655.00,
      'chartData': [45.0, 80.0, 30.0, 65.0, 50.0, 90.0, 40.0],
      'transactions': [
        {
          'title': 'ซื้ออาหารกลางวัน',
          'date': 'วันนี้, 12:30',
          'amount': '- ฿ 150.00',
          'icon': FontAwesomeIcons.bowlFood,
          'color': Colors.orange,
          'isExpense': true,
        },
        {
          'title': 'เงินเดือนเข้า',
          'date': 'เมื่อวาน, 09:00',
          'amount': '+ ฿ 12,000.00',
          'icon': FontAwesomeIcons.moneyBillWave,
          'color': Colors.blue,
          'isExpense': false,
        },
        {
          'title': 'ค่าเดินทาง BTS',
          'date': 'เมื่อวาน, 18:00',
          'amount': '- ฿ 45.00',
          'icon': FontAwesomeIcons.trainSubway,
          'color': Colors.green,
          'isExpense': true,
        },
      ],
    },
    'เดือนนี้': {
      'balance': 45000.00,
      'income': 80000.00,
      'expense': 35000.00,
      'chartData': [60.0, 40.0, 70.0, 50.0, 80.0, 60.0, 90.0],
      'transactions': [
        {
          'title': 'ค่าเช่าห้อง',
          'date': '1 ม.ค., 12:00',
          'amount': '- ฿ 8,000.00',
          'icon': FontAwesomeIcons.house,
          'color': Colors.purple,
          'isExpense': true,
        },
        {
          'title': 'โบนัสปีใหม่',
          'date': '2 ม.ค., 09:00',
          'amount': '+ ฿ 50,000.00',
          'icon': FontAwesomeIcons.moneyBillWave,
          'color': Colors.blue,
          'isExpense': false,
        },
      ],
    },
    'ปีนี้': {
      'balance': 150000.00,
      'income': 500000.00,
      'expense': 350000.00,
      'chartData': [80.0, 70.0, 90.0, 60.0, 85.0, 75.0, 95.0],
      'transactions': [
        {
          'title': 'ซื้อคอมพิวเตอร์',
          'date': '15 ม.ค., 14:00',
          'amount': '- ฿ 45,000.00',
          'icon': FontAwesomeIcons.computer,
          'color': Colors.blueGrey,
          'isExpense': true,
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'สวัสดี, Andrew',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  'บันทึกรายรับ-รายจ่าย',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(FontAwesomeIcons.bell, size: 20),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header Background with Card
          SliverToBoxAdapter(
            child: Stack(
              children: [
                const CustomHeaderBackground(height: 80, borderRadius: 24),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: _buildBalanceSummaryCard(),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const SectionTitle(title: 'ภาพรวมสัปดาห์นี้'),
                  const SizedBox(height: 8),
                  _buildExpenseChart(),
                  const SizedBox(height: 16),
                  const SectionTitle(title: 'รายการล่าสุด'),
                  const SizedBox(height: 8),
                  _buildRecentTransactions(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummaryCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ยอดเงินคงเหลือ',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          CountUpText(
            endValue: 12345.00,
            prefix: '฿ ',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  icon: FontAwesomeIcons.arrowDown,
                  label: 'รายรับ',
                  amount: 12000,
                  color: Colors.green,
                  bgColor: Colors.green.shade50,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: _buildSummaryItem(
                  icon: FontAwesomeIcons.arrowUp,
                  label: 'รายจ่าย',
                  amount: 12655,
                  color: Colors.red,
                  bgColor: Colors.red.shade50,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required double amount,
    required Color color,
    required Color bgColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? color.withValues(alpha: 0.1) : bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            CountUpText(
              endValue: amount,
              prefix: '฿ ',
              precision: 0,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpenseChart() {
    final chartData = _data[_chartFilter]['chartData'] as List;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'รายจ่ายรายวัน',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _chartFilter,
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(FontAwesomeIcons.chevronDown, size: 12),
                    ),
                    isDense: true,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Sarabun',
                    ),
                    dropdownColor: Theme.of(context).cardColor,
                    items: ['วันนี้', 'สัปดาห์นี้', 'เดือนนี้', 'ปีนี้'].map((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _chartFilter = newValue;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        rod.toY.round().toString(),
                        const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final style = TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'จ';
                            break;
                          case 1:
                            text = 'อ';
                            break;
                          case 2:
                            text = 'พ';
                            break;
                          case 3:
                            text = 'พฤ';
                            break;
                          case 4:
                            text = 'ศ';
                            break;
                          case 5:
                            text = 'ส';
                            break;
                          case 6:
                            text = 'อา';
                            break;
                          default:
                            text = '';
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(text, style: style),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  chartData.length,
                  (index) => _makeGroupData(index, chartData[index] as double),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: x == 5
              ? AppColors.primary
              : (isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          width: 12,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    final transactions =
        _data['สัปดาห์นี้']['transactions'] as List<Map<String, dynamic>>;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isExpense = tx['isExpense'] as bool;
        return TransactionTile(
          title: tx['title'] as String,
          subtitle: tx['date'] as String,
          amount: tx['amount'] as String,
          amountColor: isExpense ? Colors.red : Colors.green,
          icon: tx['icon'] as IconData,
          iconColor: tx['color'] as Color,
        );
      },
    );
  }
}
