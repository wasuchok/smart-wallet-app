import 'package:action_slider/action_slider.dart';
import 'package:exprense_app/transaction_slip_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'constants/app_colors.dart';
import 'utils/currency_input_formatter.dart';
import 'widgets/section_title.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  bool _isExpense = true;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _selectedCategory;

  final List<Map<String, dynamic>> _expenseCategories = [
    {
      'icon': FontAwesomeIcons.bowlFood,
      'label': 'อาหาร',
      'color': Colors.orange,
    },
    {'icon': FontAwesomeIcons.bus, 'label': 'เดินทาง', 'color': Colors.blue},
    {
      'icon': FontAwesomeIcons.bagShopping,
      'label': 'ช้อปปิ้ง',
      'color': Colors.purple,
    },
    {'icon': FontAwesomeIcons.film, 'label': 'บันเทิง', 'color': Colors.red},
    {'icon': FontAwesomeIcons.house, 'label': 'ที่พัก', 'color': Colors.brown},
    {'icon': FontAwesomeIcons.bolt, 'label': 'น้ำ/ไฟ', 'color': Colors.yellow},
    {
      'icon': FontAwesomeIcons.heartPulse,
      'label': 'สุขภาพ',
      'color': Colors.green,
    },
    {'icon': FontAwesomeIcons.ellipsis, 'label': 'อื่นๆ', 'color': Colors.grey},
  ];

  final List<Map<String, dynamic>> _incomeCategories = [
    {
      'icon': FontAwesomeIcons.moneyBillWave,
      'label': 'เงินเดือน',
      'color': Colors.green,
    },
    {
      'icon': FontAwesomeIcons.handHoldingDollar,
      'label': 'โบนัส',
      'color': Colors.blue,
    },
    {
      'icon': FontAwesomeIcons.chartLine,
      'label': 'ลงทุน',
      'color': Colors.purple,
    },
    {'icon': FontAwesomeIcons.ellipsis, 'label': 'อื่นๆ', 'color': Colors.grey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isExpense ? Colors.red : AppColors.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          _isExpense ? 'รายจ่าย' : 'รายรับ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isExpense = !_isExpense;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isExpense ? 'เปลี่ยนเป็นรายรับ' : 'เปลี่ยนเป็นรายจ่าย',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Amount Section
          SizedBox(
            height: 120,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'จำนวนเงิน',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '฿',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    IntrinsicWidth(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [CurrencyInputFormatter()],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(color: Colors.white30),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Details Section (White Sheet)
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SectionTitle(title: 'วันที่', fontSize: 16),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        locale: const Locale('th', 'TH'),
                      );
                      if (picked != null && picked != _selectedDate) {
                        setState(() {
                          _selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _isExpense
                            ? Colors.red.withValues(alpha: 0.1)
                            : AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _isExpense ? Colors.red : AppColors.primary,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.calendar,
                            color: _isExpense ? Colors.red : AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            DateFormat(
                              'd MMM yyyy',
                              'th',
                            ).format(_selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: _isExpense
                                  ? Colors.red
                                  : AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'หมวดหมู่', fontSize: 16),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _isExpense
                        ? _expenseCategories.length
                        : _incomeCategories.length,
                    itemBuilder: (context, index) {
                      final category = _isExpense
                          ? _expenseCategories[index]
                          : _incomeCategories[index];
                      final isSelected = _selectedCategory == category['label'];
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedCategory = category['label'];
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (_isExpense
                                          ? Colors.red.withValues(alpha: 0.1)
                                          : AppColors.primary.withValues(
                                              alpha: 0.1,
                                            ))
                                    : (isDark
                                          ? Colors.grey.shade800
                                          : Colors.grey.shade50),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? (_isExpense
                                            ? Colors.red
                                            : AppColors.primary)
                                      : (isDark
                                            ? Colors.grey.shade700
                                            : Colors.grey.shade200),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                category['icon'] as IconData,
                                color: isSelected
                                    ? (_isExpense
                                          ? Colors.red
                                          : AppColors.primary)
                                    : (isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade400),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['label'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color
                                    : Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle(title: 'บันทึกช่วยจำ', fontSize: 16),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ระบุรายละเอียดเพิ่มเติม (ถ้ามี)',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ActionSlider.standard(
                    sliderBehavior: SliderBehavior.stretch,
                    width: double.infinity,
                    backgroundColor: _isExpense
                        ? Colors.red
                        : AppColors.primary,
                    toggleColor: Colors.white,
                    icon: Icon(
                      Icons.chevron_right,
                      color: _isExpense ? Colors.red : AppColors.primary,
                    ),
                    successIcon: const Icon(Icons.check, color: Colors.white),
                    child: const Text(
                      'เลื่อนเพื่อบันทึก',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    action: (controller) async {
                      controller.loading();
                      await Future.delayed(const Duration(seconds: 1));
                      controller.success();
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionSlipScreen(
                            isExpense: _isExpense,
                            amount:
                                double.tryParse(
                                  _amountController.text.replaceAll(',', ''),
                                ) ??
                                0.0,
                            date: _selectedDate,
                            category: _selectedCategory ?? 'อื่นๆ',
                            note: _noteController.text,
                          ),
                        ),
                      );
                      controller.reset();
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
