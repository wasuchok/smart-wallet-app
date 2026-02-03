import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'constants/app_colors.dart';

class TransactionSlipScreen extends StatelessWidget {
  final bool isExpense;
  final double amount;
  final DateTime date;
  final String category;
  final String? note;

  const TransactionSlipScreen({
    super.key,
    required this.isExpense,
    required this.amount,
    required this.date,
    required this.category,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  Text(
                    'E-Slip',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.share,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success Icon
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.check,
                            color: AppColors.primary,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ทำรายการสำเร็จ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('d MMMM yyyy • HH:mm', 'th').format(date),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        const SizedBox(height: 32),

                        Text(
                          '${isExpense ? '-' : '+'}${NumberFormat('#,##0.00').format(amount)}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: isExpense ? Colors.red : AppColors.primary,
                          ),
                        ),
                        const Text(
                          'บาท',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),

                        const SizedBox(height: 32),
                        const Divider(),
                        const SizedBox(height: 24),

                        // Details
                        _buildDetailRow(
                          context,
                          'ประเภทรายการ',
                          isExpense ? 'รายจ่าย' : 'รายรับ',
                          icon: isExpense
                              ? FontAwesomeIcons.arrowTrendDown
                              : FontAwesomeIcons.arrowTrendUp,
                          iconColor: isExpense ? Colors.red : AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          'หมวดหมู่',
                          category,
                          icon: FontAwesomeIcons.tag,
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                          context,
                          'กระเป๋าเงิน',
                          'My Wallet',
                          icon: FontAwesomeIcons.wallet,
                        ),
                        if (note != null && note!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            context,
                            'บันทึก',
                            note!,
                            icon: FontAwesomeIcons.noteSticky,
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Ref ID Footer
                        Text(
                          'Ref: ${DateFormat('yyyyMMddHHmmss').format(date)}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade400,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Space filler
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    IconData? icon,
    Color? iconColor,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 14,
              color:
                  iconColor ??
                  Theme.of(context).iconTheme.color?.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }
}
