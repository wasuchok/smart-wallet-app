import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gal/gal.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import 'constants/app_colors.dart';

class TransactionSlipScreen extends StatefulWidget {
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
  State<TransactionSlipScreen> createState() => _TransactionSlipScreenState();
}

class _TransactionSlipScreenState extends State<TransactionSlipScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSaving = false;

  Future<void> _saveSlip() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Check for access permission
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        await Gal.requestAccess();
      }

      // Capture the screenshot
      final Uint8List? imageBytes = await _screenshotController.capture();

      if (imageBytes != null) {
        // Save to gallery
        await Gal.putImageBytes(
          imageBytes,
          name: 'Exprense_Slip_${DateTime.now().millisecondsSinceEpoch}',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('บันทึกสลิปเรียบร้อยแล้ว'),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        throw Exception('ไม่สามารถจับภาพหน้าจอได้');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('เกิดข้อผิดพลาดในการบันทึก: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, Color(0xFF00796B)],
          ),
        ),
        child: SafeArea(
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
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Text(
                      'E-Slip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _saveSlip,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.save_alt, color: Colors.white),
                          tooltip: 'บันทึกสลิป',
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.share, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Screenshot(
                        controller: _screenshotController,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).cardColor,
                                Theme.of(context).cardColor,
                                Color.lerp(
                                  Theme.of(context).cardColor,
                                  AppColors.primary,
                                  0.05,
                                )!,
                              ],
                              stops: const [0.0, 0.8, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.15,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Tiled Watermark Pattern
                              Positioned.fill(
                                child: Opacity(
                                  opacity: 0.03,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/logo.png'),
                                        repeat: ImageRepeat.repeat,
                                        scale: 4.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Decorative Top Bar
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 8,
                                  color: AppColors.primary,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  40,
                                  24,
                                  24,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // App Logo
                                    Container(
                                      width: 140,
                                      height: 140,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/logo.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // Success Status
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'ทำรายการสำเร็จ',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat(
                                        'd MMM yyyy • HH:mm',
                                        'th',
                                      ).format(widget.date),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    const Divider(height: 1, thickness: 1),
                                    const SizedBox(height: 24),

                                    // Amount Section
                                    Text(
                                      'จำนวนเงิน',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withValues(alpha: 0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.isExpense ? '-' : '+'}${NumberFormat('#,##0.00').format(widget.amount)}',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.bold,
                                        color: widget.isExpense
                                            ? Colors.red
                                            : AppColors.primary,
                                      ),
                                    ),
                                    const Text(
                                      'บาท',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),

                                    const SizedBox(height: 24),
                                    _buildDashedLine(context),
                                    const SizedBox(height: 24),

                                    // Details
                                    _buildDetailRow(
                                      context,
                                      'ประเภทรายการ',
                                      widget.isExpense ? 'รายจ่าย' : 'รายรับ',
                                      icon: widget.isExpense
                                          ? FontAwesomeIcons.arrowTrendDown
                                          : FontAwesomeIcons.arrowTrendUp,
                                      iconColor: widget.isExpense
                                          ? Colors.red
                                          : AppColors.primary,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      'หมวดหมู่',
                                      widget.category,
                                      icon: FontAwesomeIcons.tag,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                      context,
                                      'กระเป๋าเงิน',
                                      'My Wallet',
                                      icon: FontAwesomeIcons.wallet,
                                    ),
                                    if (widget.note != null &&
                                        widget.note!.isNotEmpty) ...[
                                      const SizedBox(height: 16),
                                      _buildDetailRow(
                                        context,
                                        'บันทึก',
                                        widget.note!,
                                        icon: FontAwesomeIcons.noteSticky,
                                      ),
                                    ],

                                    const SizedBox(height: 32),

                                    // Footer Ref
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.grey.withValues(
                                            alpha: 0.2,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Ref: ${DateFormat('yyyyMMddHHmmss').format(widget.date)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade500,
                                          fontFamily: 'Monospace',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.buildingColumns,
                                          size: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'EXPENSE BANK',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade400,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashedLine(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        const dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey.shade300),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
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
