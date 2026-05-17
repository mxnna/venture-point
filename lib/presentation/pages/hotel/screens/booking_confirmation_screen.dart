import 'package:flutter/material.dart';
import '../models/hotel.dart';
import 'dart:math';

// ── Colors (نفس الـ BookingDetailsScreen) ────────────────────
const Color kNavy900 = Color(0xFF042C53);
const Color kNavy800 = Color(0xFF0C447C);
const Color kNavy600 = Color(0xFF185fa5);
const Color kNavy400 = Color(0xFF378ADD);
const Color kNavy100 = Color(0xFFB5D4F4);
const Color kNavy50 = Color(0xFFE6F1FB);
const Color kBeige50 = Color(0xFFF1EFE8);
const Color kBeige100 = Color(0xFFD3D1C7);
const Color kBeige200 = Color(0xFFB4B2A9);
const Color kBeige400 = Color(0xFF888780);
const Color kBeige600 = Color(0xFF5F5E5A);
const Color kBg = Color(0xFFF0EBE0);

class BookingConfirmationScreen extends StatelessWidget {
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int children;
  final int rooms;
  final int nights;
  final String roomName;
  final int pricePerNight;

  const BookingConfirmationScreen({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.children,
    required this.rooms,
    required this.nights,
    required this.roomName,
    required this.pricePerNight,
  });

  // ── Price calculations ──────────────────────────────────────
  int get basePrice => pricePerNight * nights * rooms;
  int get guestFee =>
      (adults + children) > 2 ? ((adults + children) - 2) * 50 * nights : 0;
  int get taxes => ((basePrice + guestFee) * 0.1).round();
  int get totalPrice => basePrice + guestFee + taxes;

  String _fmtDate(DateTime d) {
    const months = [
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String get _bookingId =>
      'A${DateTime.now().millisecondsSinceEpoch % 900000000 + 100000000}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kNavy50,
              shape: BoxShape.circle,
              border: Border.all(color: kBeige100, width: 1),
            ),
            child: const Icon(Icons.arrow_back, color: kNavy600, size: 18),
          ),
        ),
        title: const Text(
          'Booking',
          style: TextStyle(
            color: kNavy900,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Container(height: 0.5, color: kBeige100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 20, 14, 24),
        child: Column(
          children: [
            // ── Success badge ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: kNavy50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kNavy100, width: 0.5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: kNavy900,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Booking confirmed successfully!',
                    style: TextStyle(
                      fontSize: 16,
                      color: kNavy900,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Ticket card ──
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kBeige100, width: 0.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  // Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: kNavy900,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'YOUR STAY',
                          style: TextStyle(
                            fontSize: 16,
                            color: kNavy100,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Atlantis The Palm',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Dubai, UAE · 5-star',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0x99FFFFFF),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '🛏  $roomName',
                            style: const TextStyle(
                              fontSize: 16,
                              color: kNavy100,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Body
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Info grid
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCell(
                                label: 'Check-in',
                                value: _fmtDate(checkIn),
                              ),
                            ),
                            Expanded(
                              child: _InfoCell(
                                label: 'Check-out',
                                value: _fmtDate(checkOut),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCell(
                                label: 'Guests',
                                value:
                                    '$adults Adult${adults > 1 ? 's' : ''}'
                                    '${children > 0 ? ', $children Child${children > 1 ? 'ren' : ''}' : ''}',
                              ),
                            ),
                            Expanded(
                              child: _InfoCell(
                                label: 'Rooms',
                                value:
                                    '$rooms room${rooms > 1 ? 's' : ''} · $nights night${nights > 1 ? 's' : ''}',
                              ),
                            ),
                          ],
                        ),

                        // Dashed notch divider
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _notchCircle(),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (_, c) => CustomPaint(
                                  size: Size(c.maxWidth, 1),
                                  painter: _DashedPainter(),
                                ),
                              ),
                            ),
                            _notchCircle(),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Price breakdown
                        _PriceRow(
                          label:
                              '\$$pricePerNight × $nights night${nights > 1 ? 's' : ''} × $rooms room${rooms > 1 ? 's' : ''}',
                          value: '\$$basePrice',
                        ),
                        const SizedBox(height: 5),
                        _PriceRow(
                          label: 'Extra guests fee',
                          value: '\$$guestFee',
                        ),
                        const SizedBox(height: 5),
                        _PriceRow(
                          label: 'Taxes & fees (10%)',
                          value: '\$$taxes',
                        ),
                        const SizedBox(height: 10),
                        Container(height: 0.5, color: kBeige100),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total paid',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kNavy900,
                              ),
                            ),
                            Text(
                              '\$$totalPrice',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: kNavy900,
                              ),
                            ),
                          ],
                        ),

                        // Barcode
                        const SizedBox(height: 16),
                        _buildBarcode(),
                        const SizedBox(height: 6),
                        Text(
                          _bookingId,
                          style: const TextStyle(
                            fontSize: 16,
                            color: kBeige200,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Buttons ──
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kNavy900,
                      side: const BorderSide(color: kBeige100),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kNavy900,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Download Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // ── Step bar ──
      bottomNavigationBar: Container(
        color: kBg,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: kNavy600,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notchCircle() => Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: kBg,
      shape: BoxShape.circle,
      border: Border.all(color: kBeige100, width: 0.5),
    ),
  );

  Widget _buildBarcode() {
    const widths = [
      2,
      1,
      3,
      1,
      2,
      3,
      1,
      2,
      1,
      3,
      2,
      1,
      2,
      3,
      1,
      2,
      1,
      3,
      2,
      1,
      3,
      2,
      1,
      2,
      3,
      1,
      2,
      1,
      2,
      3,
    ];
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widths
            .asMap()
            .entries
            .map(
              (e) => Container(
                width: e.value.toDouble(),
                height: 18.0 + (e.key % 3) * 6,
                margin: const EdgeInsets.symmetric(horizontal: 0.5),
                color: kNavy900,
              ),
            )
            .toList(),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────
class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: const TextStyle(fontSize: 9, color: kBeige400)),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kNavy900,
        ),
      ),
    ],
  );
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: kBeige600),
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 16,
          color: kBeige600,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = kBeige100
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + 6, 0), paint);
      x += 10;
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
