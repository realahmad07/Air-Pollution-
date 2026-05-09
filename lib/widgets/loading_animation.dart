import 'package:flutter/material.dart';
import '../utils/theme.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({
    Key? key,
    this.message,
  }) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                    strokeWidth: 3,
                  ),
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.cardBg,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          '🌍',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (message != null)
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      );
}

class PollutionIndicator extends StatelessWidget {
  const PollutionIndicator({
    Key? key,
    required this.aqiValue,
    this.size = 100,
  }) : super(key: key);
  final double aqiValue;
  final double size;

  Color _getColorForAQI(double aqi) {
    if (aqi <= 50) return AppTheme.goodAqi;
    if (aqi <= 100) return AppTheme.moderateAqi;
    if (aqi <= 150) return const Color(0xFFFFA500);
    if (aqi <= 200) return AppTheme.unhealthyAqi;
    return AppTheme.hazardousAqi;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForAQI(aqiValue);
    final percentage = (aqiValue / 500).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _IndicatorPainter(
              color: color,
              percentage: percentage,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                aqiValue.toStringAsFixed(0),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                'AQI',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.color,
    required this.percentage,
  });
  final Color color;
  final double percentage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = AppTheme.cardBg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Progress arc
    final sweepAngle = percentage * 360 * 3.14159 / 180;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_IndicatorPainter oldDelegate) =>
      oldDelegate.percentage != percentage || oldDelegate.color != color;
}
