import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../habit_flow/controllers/habit_controller.dart';
import '../../home_flow/presentation/controllers/home_controller.dart';

class MonthlyReportResult {
  final String filePath;
  final String fileName;
  final DateTime month;
  final Uint8List fileBytes;

  const MonthlyReportResult({
    required this.filePath,
    required this.fileName,
    required this.month,
    required this.fileBytes,
  });
}

class _DailyProgressRow {
  final DateTime date;
  final int completed;
  final int total;

  const _DailyProgressRow({
    required this.date,
    required this.completed,
    required this.total,
  });

  double get percentage {
    if (total == 0) return 0;
    return (completed / total) * 100;
  }
}

class MonthlyReportPdfService {
  Future<MonthlyReportResult> generateMonthlyReport({
    required DateTime month,
    required HabitController habitController,
    HomeController? homeController,
  }) async {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    final dailyRows = <_DailyProgressRow>[];
    for (int day = 1; day <= monthEnd.day; day++) {
      final currentDate = DateTime(month.year, month.month, day);
      final total = habitController.getHabitsForDate(currentDate).length;
      final completed = habitController.getCompletedCountForDate(currentDate);

      dailyRows.add(
        _DailyProgressRow(
          date: currentDate,
          completed: completed,
          total: total,
        ),
      );
    }

    final totalScheduled = dailyRows.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );
    final totalCompleted = dailyRows.fold<int>(
      0,
      (sum, item) => sum + item.completed,
    );
    final completionRate = totalScheduled == 0
        ? 0.0
        : (totalCompleted / totalScheduled) * 100;

    final activeDays = dailyRows.where((item) => item.total > 0).length;
    final fullyCompletedDays = dailyRows
        .where((item) => item.total > 0 && item.completed == item.total)
        .length;

    final longestStreak = _calculateLongestStreak(dailyRows);
    final currentStreak = _calculateCurrentStreak(dailyRows);
    final bestDay = _findBestDay(dailyRows);

    final totalTasks = homeController?.tasks.length ?? 0;
    final completedTasks =
        homeController?.tasks.where((task) => task.isFullyCompleted).length ??
        0;

    final report = pw.Document();
    final reportCreatedAt = DateTime.now();

    report.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        footer: (context) => pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(color: PdfColors.grey700, fontSize: 10),
          ),
        ),
        build: (context) => [
          pw.Text(
            'Habit Tracker Monthly Report',
            style: pw.TextStyle(
              fontSize: 22,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            'Month: ${_monthTitle(normalizedMonth)}',
            style: const pw.TextStyle(fontSize: 13, color: PdfColors.grey800),
          ),
          pw.Text(
            'Generated: ${_formatDateTime(reportCreatedAt)}',
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 16),
          pw.Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _metricCard('Scheduled Habits', totalScheduled.toString()),
              _metricCard('Completed Habits', totalCompleted.toString()),
              _metricCard(
                'Completion Rate',
                '${completionRate.toStringAsFixed(1)}%',
              ),
              _metricCard('Active Days', activeDays.toString()),
              _metricCard('Perfect Days', fullyCompletedDays.toString()),
              _metricCard('Current Streak', '$currentStreak days'),
              _metricCard('Best Streak', '$longestStreak days'),
              _metricCard('Tasks Snapshot', '$completedTasks / $totalTasks'),
            ],
          ),
          pw.SizedBox(height: 14),
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue50,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.blue100),
            ),
            child: pw.Text(
              bestDay == null
                  ? 'No habit schedule found for this month.'
                  : 'Best Day: ${_formatDate(bestDay.date)} • ${bestDay.completed}/${bestDay.total} completed (${bestDay.percentage.toStringAsFixed(0)}%)',
              style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey900),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Daily Habit Breakdown',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue900,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: const ['Date', 'Completed', 'Total', 'Rate'],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 10,
              color: PdfColors.blue900,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.blue100),
            cellStyle: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey900,
            ),
            data: dailyRows.map((row) {
              return [
                _formatDate(row.date),
                row.completed.toString(),
                row.total.toString(),
                '${row.percentage.toStringAsFixed(0)}%',
              ];
            }).toList(),
          ),
        ],
      ),
    );

    final docsDirectory = await getApplicationDocumentsDirectory();
    final reportDirectory = Directory('${docsDirectory.path}/reports');
    if (!await reportDirectory.exists()) {
      await reportDirectory.create(recursive: true);
    }

    final monthString = normalizedMonth.month.toString().padLeft(2, '0');
    final fileName = 'habit_report_${normalizedMonth.year}_$monthString.pdf';
    final file = File('${reportDirectory.path}/$fileName');

    final pdfBytes = await report.save();
    await file.writeAsBytes(pdfBytes, flush: true);

    return MonthlyReportResult(
      filePath: file.path,
      fileName: fileName,
      month: normalizedMonth,
      fileBytes: pdfBytes,
    );
  }

  int _calculateCurrentStreak(List<_DailyProgressRow> rows) {
    int streak = 0;

    for (int i = rows.length - 1; i >= 0; i--) {
      final row = rows[i];
      if (row.total == 0) {
        continue;
      }

      if (row.completed == row.total) {
        streak++;
        continue;
      }

      break;
    }

    return streak;
  }

  int _calculateLongestStreak(List<_DailyProgressRow> rows) {
    int longest = 0;
    int running = 0;

    for (final row in rows) {
      if (row.total == 0) {
        continue;
      }

      if (row.completed == row.total) {
        running++;
        if (running > longest) {
          longest = running;
        }
      } else {
        running = 0;
      }
    }

    return longest;
  }

  _DailyProgressRow? _findBestDay(List<_DailyProgressRow> rows) {
    final activeRows = rows.where((row) => row.total > 0).toList();
    if (activeRows.isEmpty) {
      return null;
    }

    activeRows.sort((a, b) {
      final completionCompare = b.percentage.compareTo(a.percentage);
      if (completionCompare != 0) {
        return completionCompare;
      }

      return b.completed.compareTo(a.completed);
    });

    return activeRows.first;
  }

  pw.Widget _metricCard(String label, String value) {
    return pw.Container(
      width: 120,
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey900,
            ),
          ),
        ],
      ),
    );
  }

  String _monthTitle(DateTime month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${monthNames[month.month - 1]} ${month.year}';
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day.toString().padLeft(2, '0')} ${monthNames[date.month - 1]} ${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$date, $hour:$minute';
  }
}
