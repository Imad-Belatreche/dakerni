import 'package:dakerni/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DailyCalendarCard extends StatelessWidget {
  final bool isSelected;
  final DateTime dateTime;
  final int index;
  final VoidCallback onTap;
  const DailyCalendarCard({
    super.key,
    required this.isSelected,
    required this.dateTime,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? colorScheme.primary : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            children: [
              Text(
                DateFormat.E().format(dateTime).toUpperCase(),
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  letterSpacing: 1.2,
                  color: isSelected
                      ? colorScheme.secondary
                      : colorScheme.secondary.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 10),
              Text(
                DateFormat.d().format(dateTime),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: isSelected
                      ? colorScheme.secondary
                      : colorScheme.secondary.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
