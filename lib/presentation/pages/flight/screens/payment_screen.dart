import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../models/search_state.dart';
import '../models/booking_model.dart';
import '../services/flight_services.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'boarding_pass_screen.dart';
 
class PaymentScreen extends StatefulWidget {
  final FlightModel flight;
  final SearchState search;
  final String seat;
 
  const PaymentScreen({super.key,
    required this.flight, required this.search, required this.seat});
 
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}
 
class _PaymentScreenState extends State<PaymentScreen> {
  int _payMethod = 0;
  bool _paying = false;
  final _service = FlightService();
 
  double get _base => widget.flight.price * widget.search.totalPassengers;
  double get _seatFee => 15;
  double get _tax => (_base * 0.1).roundToDouble() + 5;
  double get _total => _base + _seatFee + _tax;
 
  final _methods = [
    {'icon': Icons.credit_card, 'name': 'Credit / Debit card', 'sub': '**** **** **** 4521'},
    {'icon': Icons.phone_iphone, 'name': 'Apple Pay', 'sub': 'Touch ID enabled'},
    {'icon': Icons.g_mobiledata, 'name': 'Google Pay', 'sub': 'Linked account'},
  ];
 
  Future<void> _pay() async {
    setState(() => _paying = true);
    // Create booking in Firestore
    final booking = BookingModel(
      id: '',
      flightId: widget.flight.id,
      userId: 'user_demo', // replace with Firebase Auth uid
      passengerName: 'Mohamed Orabi',
      fromCode: widget.search.from.code,
      fromCity: widget.search.from.city,
      toCode: widget.search.to.code,
      toCity: widget.search.to.city,
      departDate: DateFormat('d MMM yyyy').format(widget.search.departDate),
      departTime: widget.flight.departTime,
      arrivalTime: widget.flight.arrivalTime,
      flightNumber: widget.flight.flightNumber,
      airline: widget.flight.airline,
      seatNumber: widget.seat,
      cabinClass: widget.search.cabinClass,
      adults: widget.search.adults,
      children: widget.search.children,
      infants: widget.search.infants,
      totalPrice: _total,
      gate: 'B14',
      terminal: '2',
      boardingTime: _subtractMinutes(widget.flight.departTime, 30),
      status: 'confirmed',
      createdAt: DateTime.now(),
    );
 
    final bookingId = await _service.createBooking(booking);
    setState(() => _paying = false);
 
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => BoardingPassScreen(
        booking: booking.copyWith(id: bookingId ?? ''),
        flight: widget.flight,
      ),
    ));
  }
 
  String _subtractMinutes(String time, int minutes) {
    final parts = time.split(':');
    final dt = DateTime(2000, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
    final result = dt.subtract(Duration(minutes: minutes));
    return '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')}';
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(children: [
        NavyHeader(title: 'Payment', onBack: () => Navigator.pop(context)),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 24), children: [
              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(14)),
                child: Column(children: [
                  const Row(children: [
                    Text('Order summary',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
                  ]),
                  const SizedBox(height: 10),
                  _summaryRow('${widget.search.totalPassengers}× ${widget.search.cabinClass} (${widget.flight.flightNumber})',
                      '\$${_base.toInt()}'),
                  const SizedBox(height: 4),
                  _summaryRow('Seat ${widget.seat}', '\$${_seatFee.toInt()}'),
                  const SizedBox(height: 4),
                  _summaryRow('Taxes & fees', '\$${_tax.toInt()}'),
                  const SizedBox(height: 10),
                  const Divider(color: Color(0xFFB5D0F0), height: 1),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Total',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
                    Text('\$${_total.toInt()}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.navy)),
                  ]),
                ]),
              ),
              const SizedBox(height: 20),
              const Text('Payment method',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark)),
              const SizedBox(height: 10),
              // Payment methods
              ...List.generate(_methods.length, (i) {
                final m = _methods[i];
                final on = _payMethod == i;
                return GestureDetector(
                  onTap: () => setState(() => _payMethod = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: on ? AppColors.blue.withOpacity(.5) : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(children: [
                      Icon(m['icon'] as IconData, size: 22, color: AppColors.blue),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(m['name'] as String,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark)),
                        Text(m['sub'] as String,
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ])),
                      if (on)
                        Container(
                          width: 20, height: 20,
                          decoration: const BoxDecoration(color: AppColors.navy, shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 12),
                        ),
                    ]),
                  ),
                );
              }),
              const SizedBox(height: 8),
              // Pay button
              _paying
                  ? const Center(child: CircularProgressIndicator(color: AppColors.navy))
                  : NavyButton(
                      label: 'Pay \$${_total.toInt()}',
                      onTap: _pay,
                      icon: const Icon(Icons.lock_outline, color: Colors.white, size: 16),
                    ),
            ]),
          ),
        ),
      ]),
    );
  }
 
  Widget _summaryRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      Text(value, style: const TextStyle(fontSize: 11, color: AppColors.textDark)),
    ],
  );
}
 
// Extension to copy with id
extension BookingCopyWith on BookingModel {
  BookingModel copyWith({String? id}) => BookingModel(
    id: id ?? this.id,
    flightId: flightId, userId: userId, passengerName: passengerName,
    fromCode: fromCode, fromCity: fromCity, toCode: toCode, toCity: toCity,
    departDate: departDate, departTime: departTime, arrivalTime: arrivalTime,
    flightNumber: flightNumber, airline: airline, seatNumber: seatNumber,
    cabinClass: cabinClass, adults: adults, children: children, infants: infants,
    totalPrice: totalPrice, gate: gate, terminal: terminal, boardingTime: boardingTime,
    status: status, createdAt: createdAt,
  );
}
