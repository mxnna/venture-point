import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/booking_model.dart';
import '../models/flight_model.dart';
import '../utils/app_theme.dart';

class BoardingPassScreen extends StatelessWidget {
  final BookingModel booking;
  final FlightModel flight;

  const BoardingPassScreen({super.key, required this.booking, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(children: [
        // Header
        Container(
          color: AppColors.navy,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16, right: 16, bottom: 16,
          ),
          child: Row(children: [
            GestureDetector(
              onTap: () {
                // Pop back to home
                Navigator.of(context).popUntil((r) => r.isFirst);
              },
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.navyLight, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 14),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Boarding pass',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white))),
            GestureDetector(
              onTap: () => _share(context),
              child: Container(
                width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.navyLight, shape: BoxShape.circle),
                child: const Icon(Icons.ios_share, color: Colors.white54, size: 16),
              ),
            ),
          ]),
        ),
        // Body
        Expanded(
          child: Container(
            color: AppColors.beige,
            child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), children: [
              // Boarding pass card
              _buildBoardingCard(),
              const SizedBox(height: 16),
              // Actions
              Row(children: [
                Expanded(child: _actionBtn(
                  icon: Icons.download_outlined,
                  label: 'Download',
                  filled: true,
                  onTap: () => _showSnack(context, 'Boarding pass saved to downloads'),
                )),
                const SizedBox(width: 10),
                Expanded(child: _actionBtn(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  filled: false,
                  onTap: () => _share(context),
                )),
              ]),
              const SizedBox(height: 12),
              _actionBtn(
                icon: Icons.home_outlined,
                label: 'Back to home',
                filled: false,
                onTap: () => Navigator.of(context).popUntil((r) => r.isFirst),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildBoardingCard() {
    return Column(children: [
      // Top navy section
      Container(
        decoration: const BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          // Airline row
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(booking.airline,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              Text('${booking.flightNumber} · ${booking.cabinClass}',
                  style: const TextStyle(fontSize: 10, color: Colors.white54)),
            ]),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.navyLight, borderRadius: BorderRadius.circular(9)),
              alignment: Alignment.center,
              child: Text(flight.airlineCode,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white54)),
            ),
          ]),
          const SizedBox(height: 18),
          // Route
          Row(children: [
            _apCol(booking.fromCode, booking.fromCity),
            Expanded(child: Column(children: [
              Text(booking.departDate,
                  style: const TextStyle(fontSize: 9, color: Colors.white38)),
              const SizedBox(height: 6),
              Row(children: [
                Container(width: 5, height: 5, decoration: const BoxDecoration(
                    color: Color(0xFF3A5A8A), shape: BoxShape.circle)),
                Expanded(child: Container(height: 1, color: const Color(0xFF3A5A8A))),
                const Icon(Icons.flight, size: 14, color: Colors.white54),
                Expanded(child: Container(height: 1, color: const Color(0xFF3A5A8A))),
                Container(width: 5, height: 5, decoration: const BoxDecoration(
                    color: Color(0xFF3A5A8A), shape: BoxShape.circle)),
              ]),
              const SizedBox(height: 6),
              Text(flight.duration, style: const TextStyle(fontSize: 9, color: Colors.white38)),
            ])),
            _apCol(booking.toCode, booking.toCity),
          ]),
        ]),
      ),
      // Notch divider
      Container(
        height: 18,
        color: AppColors.navyMid,
        child: Row(children: [
          Container(width: 18, height: 18,
              decoration: const BoxDecoration(color: AppColors.beige,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(12)))),
          Expanded(child: DashedLine()),
          Container(width: 18, height: 18,
              decoration: const BoxDecoration(color: AppColors.beige,
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(12)))),
        ]),
      ),
      // Details section
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8F5EE),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              _detailField('Passenger', booking.passengerName),
              _detailField('Date', booking.departDate),
              _detailField('Departs', booking.departTime),
              _detailField('Arrives', booking.arrivalTime),
              _detailField('Gate', booking.gate),
              _detailField('Seat', booking.seatNumber),
              _detailField('Boarding', booking.boardingTime),
              _detailField('Terminal', booking.terminal),
            ],
          ),
          const SizedBox(height: 16),
          // Barcode
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.beige3),
            ),
            child: Column(children: [
              // Barcode bars
              SizedBox(
                height: 48,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _generateBars(),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${booking.flightNumber.replaceAll('-', '').replaceAll(' ', '')} · ${booking.departDate} · ${booking.seatNumber}',
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted, letterSpacing: 2),
              ),
            ]),
          ),
        ]),
      ),
    ]);
  }

  List<Widget> _generateBars() {
    final widths = [2,1,3,1,2,1,3,2,1,2,3,1,2,1,3,2,1,2,3,1,2,1,3,1,2];
    final heights = [32,38,28,36,42,26,38,32,36,24,40,34,28,38,32,36,40,26,36,40,32,44,28,36,40];
    return List.generate(widths.length, (i) => Container(
      width: widths[i].toDouble(),
      height: heights[i].toDouble(),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.circular(1),
      ),
    ));
  }

  Widget _apCol(String code, String city) => Column(children: [
    Text(code, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700,
        color: Colors.white, letterSpacing: 2)),
    Text(city, style: const TextStyle(fontSize: 9, color: Colors.white54)),
  ]);

  Widget _detailField(String label, String value) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.textDark)),
    ],
  );

  Widget _actionBtn({required IconData icon, required String label,
    required bool filled, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: filled ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: filled ? AppColors.navy : AppColors.beige3),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 16, color: filled ? Colors.white : AppColors.navy),
          const SizedBox(width: 7),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
              color: filled ? Colors.white : AppColors.navy)),
        ]),
      ),
    );
  }

  void _share(BuildContext context) {
    Clipboard.setData(ClipboardData(
        text: '✈ ${booking.flightNumber} | ${booking.fromCode} → ${booking.toCode} | ${booking.departDate} | Seat ${booking.seatNumber}'));
    _showSnack(context, 'Flight info copied to clipboard!');
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.navy,
          behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Dashed line widget
// ══════════════════════════════════════════════════════════════════════════════
class DashedLine extends StatelessWidget {
  const DashedLine({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(),
      child: const SizedBox(height: 18),
    );
  }
}

class _DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2A4A78)
      ..strokeWidth = 1;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height / 2), Offset(x + 6, size.height / 2), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
