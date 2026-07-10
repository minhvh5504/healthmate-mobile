import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthmate_mobile/features/health/presentation/providers/health_history/health_history_provider.dart';

class HealthHistoryChart extends StatelessWidget {
  final HealthHistoryMetric metric;
  final HealthHistoryRange range;
  final DateTime cursorDate;
  final List<HealthHistoryEntry> entries;
  final double? currentValue;
  final String unit;

  const HealthHistoryChart({
    super.key,
    required this.metric,
    required this.range,
    required this.cursorDate,
    required this.entries,
    required this.currentValue,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final periodEntries = _entriesInPeriod();
    final realSpots = periodEntries.map(_spotForEntry).toList();
    final yBounds = _yBounds(periodEntries);
    final lineSpots = _buildLineSpots(realSpots);
    final hasLine = lineSpots.isNotEmpty;

    return SizedBox(
      height: 330.h,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8.w, 0, 18.w, 0),
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: _maxX(),
            minY: yBounds.$1,
            maxY: yBounds.$2,
            clipData: const FlClipData.none(),
            lineTouchData: LineTouchData(
              enabled: false,
              getTouchedSpotIndicator: (_, indicators) => indicators
                  .map(
                    (_) => const TouchedSpotIndicatorData(
                      FlLine(color: Colors.transparent),
                      FlDotData(show: false),
                    ),
                  )
                  .toList(),
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(6.r),
                tooltipPadding: EdgeInsets.symmetric(
                  horizontal: 6.w,
                  vertical: 3.h,
                ),
                tooltipMargin: 8.h,
                getTooltipColor: (_) => Colors.transparent,
                getTooltipItems: (spots) => spots.map((spot) {
                  return LineTooltipItem(
                    '${_formatMetricValue(spot.y)}$unit',
                    TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF222222),
                    ),
                  );
                }).toList(),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(
              show: true,
              drawHorizontalLine: true,
              drawVerticalLine: false,
              horizontalInterval: _horizontalInterval(yBounds),
              checkToShowHorizontalLine: (value) =>
                  _shouldShowHorizontalLine(value, yBounds),
              getDrawingHorizontalLine: (_) => const FlLine(
                color: Color(0xFFE8F1EE),
                strokeWidth: 1,
                dashArray: [4, 4],
              ),
            ),
            extraLinesData: ExtraLinesData(
              extraLinesOnTop: false,
              horizontalLines: [
                _horizontalBoundLine(yBounds.$1),
                _horizontalBoundLine(yBounds.$2),
              ],
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 34.w,
                  interval: _horizontalInterval(yBounds),
                  minIncluded: true,
                  maxIncluded: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      _formatAxisValue(value),
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30.h,
                  interval: _verticalInterval(),
                  getTitlesWidget: (value, meta) {
                    final label = _bottomLabel(value);
                    if (label == null) return const SizedBox.shrink();
                    return Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF667085),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            lineBarsData: [
              if (hasLine)
                LineChartBarData(
                  spots: lineSpots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  preventCurveOverShooting: true,
                  color: const Color(0xFF48B386),
                  barWidth: 3.w,
                  dotData: FlDotData(
                    show: true,
                    checkToShowDot: (spot, _) =>
                        realSpots.any((s) => _sameSpot(s, spot)),
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 4.6.r,
                        color: const Color(0xFF48B386),
                        strokeWidth: 2.4.w,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF48B386).withValues(alpha: 0.24),
                        const Color(0xFF48B386).withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                ),
            ],
            showingTooltipIndicators: realSpots.isNotEmpty
                ? realSpots
                      .map(
                        (spot) => ShowingTooltipIndicators([
                          LineBarSpot(
                            LineChartBarData(spots: lineSpots),
                            0,
                            spot,
                          ),
                        ]),
                      )
                      .toList()
                : const [],
          ),
        ),
      ),
    );
  }

  // Get all entries in the current period
  List<HealthHistoryEntry> _entriesInPeriod() {
    final start = _periodStart();
    final end = _periodEnd();
    return entries
        .where(
          (entry) =>
              !entry.recordedAt.isBefore(start) &&
              entry.recordedAt.isBefore(end),
        )
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
  }

  // Get the start date of the current period
  DateTime _periodStart() {
    switch (range) {
      case HealthHistoryRange.day:
        return DateTime(cursorDate.year, cursorDate.month, cursorDate.day);
      case HealthHistoryRange.week:
        final base = DateTime(
          cursorDate.year,
          cursorDate.month,
          cursorDate.day,
        );
        return base.subtract(Duration(days: base.weekday - 1));
      case HealthHistoryRange.month:
        return DateTime(cursorDate.year, cursorDate.month);
    }
  }

  // Get the end date of the current period
  DateTime _periodEnd() {
    switch (range) {
      case HealthHistoryRange.day:
        return _periodStart().add(const Duration(days: 1));
      case HealthHistoryRange.week:
        return _periodStart().add(const Duration(days: 7));
      case HealthHistoryRange.month:
        return DateTime(cursorDate.year, cursorDate.month + 1);
    }
  }

  // Get the number of days in the current month
  int _daysInSelectedMonth() {
    return DateTime(cursorDate.year, cursorDate.month + 1, 0).day;
  }

  // Convert an entry to a spot
  FlSpot _spotForEntry(HealthHistoryEntry entry) {
    switch (range) {
      case HealthHistoryRange.day:
        return FlSpot(
          entry.recordedAt.hour + entry.recordedAt.minute / 60,
          entry.value,
        );
      case HealthHistoryRange.week:
        final start = _periodStart();
        return FlSpot(
          entry.recordedAt.difference(start).inDays.toDouble(),
          entry.value,
        );
      case HealthHistoryRange.month:
        return FlSpot((entry.recordedAt.day - 1).toDouble(), entry.value);
    }
  }

  // Build the line spots
  List<FlSpot> _buildLineSpots(List<FlSpot> spots) {
    final maxX = _maxX();
    final now = DateTime.now();
    final isPastPeriod = _periodEnd().isBefore(now);

    if (spots.isEmpty) {
      // Current/future periods show a flat line at currentValue.
      if (!isPastPeriod && currentValue != null) {
        return [FlSpot(0, currentValue!), FlSpot(maxX, currentValue!)];
      }
      return [];
    }

    final result = <FlSpot>[];

    // Extend flat from chart start to first data point.
    if (spots.first.x > 0.01) {
      result.add(FlSpot(0, spots.first.y));
    }

    result.addAll(spots);

    // Extend flat from last data point to chart end.
    if ((maxX - spots.last.x) > 0.01) {
      result.add(FlSpot(maxX, spots.last.y));
    }

    return result;
  }

  // Get the max x value
  double _maxX() {
    switch (range) {
      case HealthHistoryRange.day:
        return 24;
      case HealthHistoryRange.week:
        return 6;
      case HealthHistoryRange.month:
        return (_daysInSelectedMonth() - 1).toDouble();
    }
  }

  // Get the y bounds
  (double, double) _yBounds(List<HealthHistoryEntry> periodEntries) {
    if (periodEntries.isEmpty) {
      final cv = currentValue ?? 0;
      var minY = (cv / 10).floor() * 10.0;
      var maxY = (cv / 10).ceil() * 10.0;
      if (minY == maxY) {
        minY = math.max(0.0, minY - 10);
        maxY += 10;
      }
      return (math.max(0.0, minY), maxY);
    }
    final values = periodEntries.map((entry) => entry.value).toList();
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    var minY = (minValue / 10).floor() * 10.0;
    var maxY = (maxValue / 10).ceil() * 10.0;

    if (minY == maxY) {
      minY = math.max(0.0, minY - 10);
      maxY += 10;
    }

    return (math.max(0.0, minY), maxY);
  }

  // Get the horizontal interval
  double _horizontalInterval((double, double) bounds) {
    final span = bounds.$2 - bounds.$1;
    if (span <= 10) return 2;
    if (span <= 30) return 5;
    if (span <= 80) return 20;
    return 25;
  }

  // Check if the horizontal line should be shown
  bool _shouldShowHorizontalLine(double value, (double, double) bounds) {
    final interval = _horizontalInterval(bounds);
    final isMin = (value - bounds.$1).abs() < 0.01;
    final isMax = (value - bounds.$2).abs() < 0.01;
    final ratio = (value - bounds.$1) / interval;
    final alignsWithInterval = (ratio - ratio.roundToDouble()).abs() < 0.01;

    return isMin || isMax || alignsWithInterval;
  }

  // Build the horizontal bound line
  HorizontalLine _horizontalBoundLine(double y) {
    return HorizontalLine(
      y: y,
      color: const Color(0xFFE8F1EE),
      strokeWidth: 1,
      dashArray: [4, 4],
    );
  }

  // Get the vertical interval
  double _verticalInterval() {
    switch (range) {
      case HealthHistoryRange.day:
        return 2;
      case HealthHistoryRange.week:
      case HealthHistoryRange.month:
        return 1;
    }
  }

  // Get the bottom label
  String? _bottomLabel(double value) {
    if (value % 1 != 0) return null;
    final index = value.toInt();
    switch (range) {
      case HealthHistoryRange.day:
        if (index < 0 || index > 24 || index % 4 != 0) return null;
        return '${index.toString().padLeft(2, '0')}:00';
      case HealthHistoryRange.week:
        const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
        return index >= 0 && index < labels.length ? labels[index] : null;
      case HealthHistoryRange.month:
        final day = index + 1;
        final lastDay = _daysInSelectedMonth();
        if (day < 1 || day > lastDay) return null;
        if (day == 1 || day == lastDay || day % 7 == 0) {
          return day.toString();
        }
        return null;
    }
  }

  // Format axis value
  String _formatAxisValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  // Format metric value
  String _formatMetricValue(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  // Check if two spots are the same
  bool _sameSpot(FlSpot a, FlSpot b) {
    return (a.x - b.x).abs() < 0.01 && (a.y - b.y).abs() < 0.01;
  }
}
