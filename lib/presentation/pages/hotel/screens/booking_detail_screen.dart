import 'package:flutter/material.dart';
import 'booking_confirmation_screen.dart';

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
const Color kBg = Color(0xFFFAF8F4);

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int adults = 2;
  int children = 0;
  int rooms = 1;
  int nights = 1;

  DateTime? checkIn;
  DateTime? checkOut;

  final List<Map<String, dynamic>> roomTypes = [
    {
      'name': 'Deluxe Ocean View',
      'desc': 'King bed · Sea view · 52m²',
      'price': 750,
    },
    {'name': 'Grand Suite', 'desc': '2 beds · Terrace · 90m²', 'price': 1100},
    {
      'name': 'Royal Bridge Suite',
      'desc': 'Private pool · Butler · 210m²',
      'price': 1800,
    },
  ];
  int selectedRoom = 0;

  // ── Calculations ───────────────────────────────────────────
  int get price => roomTypes[selectedRoom]['price'] as int;
  int get basePrice => price * nights * rooms;
  int get guestFee =>
      (adults + children) > 2 ? ((adults + children) - 2) * 50 * nights : 0;
  int get taxes => ((basePrice + guestFee) * 0.1).round();
  int get totalPrice => basePrice + guestFee + taxes;

  // ── Helpers ────────────────────────────────────────────────
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

  String _fmtShort(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}';
  }

  String get nightsHint {
    if (checkIn == null) return '$nights night${nights > 1 ? 's' : ''}';
    final co = checkOut ?? checkIn!.add(Duration(days: nights));
    return '$nights night${nights > 1 ? 's' : ''} · '
        '${_fmtShort(checkIn!)} → ${_fmtShort(co)}';
  }

  // ── Date picker ────────────────────────────────────────────
  Future<void> _pickDate(bool isCheckIn) async {
    final now = DateTime.now();
    final init = isCheckIn
        ? (checkIn ?? now)
        : (checkOut ??
              (checkIn?.add(Duration(days: nights)) ??
                  now.add(const Duration(days: 1))));

    final picked = await showDatePicker(
      context: context,
      initialDate: init.isBefore(now) ? now : init,
      firstDate: now,
      lastDate: DateTime(now.year + 2, 12, 31),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kNavy900,
            onPrimary: Colors.white,
            surface: kBg,
            onSurface: kNavy900,
          ),
          dialogTheme: DialogThemeData(backgroundColor: kBg),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        checkIn = picked;
        checkOut = picked.add(Duration(days: nights));
      } else {
        if (checkIn != null && !picked.isAfter(checkIn!)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Check-out must be after check-in'),
              backgroundColor: kNavy900,
            ),
          );
          return;
        }
        checkOut = picked;
        if (checkIn != null) {
          nights = checkOut!.difference(checkIn!).inDays;
        }
      }
    });
  }

  // ── Set nights & update checkout ───────────────────────────
  void _setNights(int n) {
    setState(() {
      nights = n;
      if (checkIn != null) checkOut = checkIn!.add(Duration(days: n));
    });
  }

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
          'Booking details',
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Dates ──────────────────────────────────────────
            _sectionLabel('Select dates'),
            Row(
              children: [
                Expanded(child: _dateField('Check-in', checkIn, true)),
                const SizedBox(width: 10),
                Expanded(child: _dateField('Check-out', checkOut, false)),
              ],
            ),

            _divider(),

            // ── Nights ─────────────────────────────────────────
            _sectionLabel('Number of nights'),
            _nightsDots(),
            Text(
              nightsHint,
              style: const TextStyle(fontSize: 18, color: kBeige400),
            ),

            _divider(),

            // ── Guests ─────────────────────────────────────────
            _sectionLabel('Guests'),
            _guestsBox(),

            _divider(),

            // ── Room type ──────────────────────────────────────
            _sectionLabel('Room type'),
            ..._roomOptions(),

            _divider(),

            // ── Price summary ──────────────────────────────────
            _priceSummary(),

            const SizedBox(height: 16),

            // ── Confirm button ─────────────────────────────────
            _confirmButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: _stepBar(step: 2),
    );
  }

  // ── Date field ─────────────────────────────────────────────
  Widget _dateField(String label, DateTime? date, bool isCheckIn) {
    return GestureDetector(
      onTap: () => _pickDate(isCheckIn),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isCheckIn ? kNavy50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCheckIn ? kNavy600 : kBeige100,
            width: isCheckIn ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: kBeige400),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: kBeige400),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date != null ? _fmtDate(date) : 'Tap to select',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: date != null ? kNavy900 : kBeige200,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Nights dots ────────────────────────────────────────────
  Widget _nightsDots() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: List.generate(10, (i) {
          final n = i + 1;
          final active = n == nights;
          return GestureDetector(
            onTap: () => _setNights(n),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? kNavy900 : Colors.white,
                border: Border.all(
                  color: active ? kNavy900 : kBeige100,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$n',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : kBeige400,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Guests box ─────────────────────────────────────────────
  Widget _guestsBox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBeige100, width: 0.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Column(
        children: [
          _counterRow(
            'Adults',
            'Age 18+',
            adults,
            1,
            (v) => setState(() => adults = v),
          ),
          _counterRow(
            'Children',
            'Age 0–17',
            children,
            0,
            (v) => setState(() => children = v),
          ),
          _counterRow(
            'Rooms',
            '',
            rooms,
            1,
            (v) => setState(() => rooms = v),
            last: true,
          ),
        ],
      ),
    );
  }

  Widget _counterRow(
    String label,
    String sub,
    int value,
    int min,
    ValueChanged<int> onChanged, {
    bool last = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: kNavy900,
                      ),
                    ),
                    if (sub.isNotEmpty)
                      Text(
                        sub,
                        style: const TextStyle(fontSize: 14, color: kBeige400),
                      ),
                  ],
                ),
              ),
              Row(
                children: [
                  _circleBtn(
                    Icons.remove,
                    value > min ? () => onChanged(value - 1) : null,
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '$value',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: kNavy900,
                      ),
                    ),
                  ),
                  _circleBtn(Icons.add, () => onChanged(value + 1)),
                ],
              ),
            ],
          ),
        ),
        if (!last) Container(height: 0.5, color: kBeige100),
      ],
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: kBeige100, width: 1.5),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap == null ? kBeige200 : kNavy600,
        ),
      ),
    );
  }

  // ── Room options ───────────────────────────────────────────
  List<Widget> _roomOptions() {
    return List.generate(roomTypes.length, (i) {
      final room = roomTypes[i];
      final selected = i == selectedRoom;
      return GestureDetector(
        onTap: () => setState(() => selectedRoom = i),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? kNavy50 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? kNavy600 : kBeige100,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? kNavy600 : Colors.transparent,
                  border: Border.all(
                    color: selected ? kNavy600 : kBeige200,
                    width: 1.5,
                  ),
                ),
                child: selected
                    ? const Center(
                        child: CircleAvatar(
                          radius: 3,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room['name'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: kNavy900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      room['desc'] as String,
                      style: const TextStyle(fontSize: 15, color: kBeige400),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${room['price']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kNavy800,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ── Price summary ──────────────────────────────────────────
  Widget _priceSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBeige100, width: 0.5),
      ),
      child: Column(
        children: [
          _priceRow(
            '\$$price × $nights night${nights > 1 ? 's' : ''} × $rooms room${rooms > 1 ? 's' : ''}',
            '\$$basePrice',
          ),
          _priceRow('Extra guests fee', '\$$guestFee'),
          _priceRow('Taxes & fees (10%)', '\$$taxes'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 0.5, color: kBeige100),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kNavy900,
                ),
              ),
              Text(
                '\$$totalPrice',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kNavy900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
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
      ),
    );
  }

  // ── Confirm button ─────────────────────────────────────────
  Widget _confirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kNavy900,
          foregroundColor: kNavy50,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: () {
          if (checkIn == null || checkOut == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select check-in and check-out dates'),
                backgroundColor: kNavy900,
              ),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingConfirmationScreen(
                checkIn: checkIn!,
                checkOut: checkOut!,
                adults: adults,
                children: children,
                rooms: rooms,
                nights: nights,
                roomName: roomTypes[selectedRoom]['name'] as String,
                pricePerNight: price,
              ),
            ),
          );
        },
        child: const Text(
          'Confirm booking',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: kBeige400,
        letterSpacing: 0.9,
      ),
    ),
  );

  Widget _divider() => Container(
    margin: const EdgeInsets.symmetric(vertical: 16),
    height: 0.5,
    color: kBeige100,
  );

  Widget _stepBar({required int step}) {
    return Container(
      color: kBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: List.generate(
          3,
          (i) => Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < 2 ? 5 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: i < step ? kNavy600 : kBeige100,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
