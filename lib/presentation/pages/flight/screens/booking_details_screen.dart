import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/booking_model.dart';
import '../models/flight_model.dart';
import '../models/search_state.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'boarding_pass_screen.dart';
import 'payment_screen.dart';

class BookingDetailsScreen extends StatelessWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final flight = _flightFromBooking(booking);
    final search = _searchFromBooking(booking);
    final totalPassengers = booking.adults + booking.children;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          NavyHeader(
            title: 'Flight details',
            onBack: () => Navigator.pop(context),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        AirlineBadge(flight.airlineCode, size: 40),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                booking.airline.isNotEmpty
                                    ? booking.airline
                                    : 'Airline',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking.flightNumber.isNotEmpty
                                    ? booking.flightNumber
                                    : 'Flight',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.greenBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            booking.status.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: AppColors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _apColumn(
                        booking.fromCode,
                        booking.fromCity,
                        booking.departTime,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              booking.departDate,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.beige3,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.beige3,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.flight,
                                  size: 16,
                                  color: AppColors.blue,
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1.5,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: AppColors.beige3,
                                          style: BorderStyle.solid,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.beige3,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${booking.departTime} — ${booking.arrivalTime}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _apColumn(
                        booking.toCode,
                        booking.toCity,
                        booking.arrivalTime,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 2.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      InfoBox(
                        label: 'Date',
                        value: booking.departDate,
                        icon: Icons.calendar_today_outlined,
                      ),
                      InfoBox(
                        label: 'Class',
                        value: booking.cabinClass,
                        icon: Icons.airline_seat_recline_extra,
                      ),
                      InfoBox(
                        label: 'Passengers',
                        value: '$totalPassengers total',
                        icon: Icons.people_outline,
                      ),
                      InfoBox(
                        label: 'Seat',
                        value: booking.seatNumber,
                        icon: Icons.event_seat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Amenities',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _amenityTile(Icons.tv_outlined, 'Entertainment'),
                      _amenityTile(Icons.wifi_outlined, 'Wi-Fi'),
                      _amenityTile(Icons.restaurant_outlined, 'Meal included'),
                      _amenityTile(Icons.sync_alt, 'Refundable'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${booking.totalPrice.toInt()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                            Text(
                              'total for ${booking.adults + booking.children} passenger${totalPassengers > 1 ? 's' : ''}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 170),
                          child: ElevatedButton(
                            onPressed: () {
                              if (booking.status.toLowerCase() == 'confirmed') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BoardingPassScreen(
                                      booking: booking,
                                      flight: flight,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PaymentScreen(
                                      flight: flight,
                                      search: search,
                                      seat: booking.seatNumber,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              booking.status.toLowerCase() == 'confirmed'
                                  ? 'View boarding pass'
                                  : 'Pay now',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FlightModel _flightFromBooking(BookingModel booking) {
    final rawCode = booking.airline.isNotEmpty
        ? booking.airline.substring(
            0,
            booking.airline.length >= 2 ? 2 : booking.airline.length,
          )
        : booking.flightNumber;
    final splitCode = rawCode
        .split(RegExp(r'\D+'))
        .where((s) => s.isNotEmpty)
        .toList();
    final code = splitCode.isNotEmpty ? splitCode.first.toUpperCase() : 'XX';
    final pricePerPerson = booking.adults + booking.children > 0
        ? booking.totalPrice / (booking.adults + booking.children)
        : booking.totalPrice;
    return FlightModel(
      id: booking.flightId,
      airline: booking.airline,
      airlineCode: code,
      flightNumber: booking.flightNumber,
      fromCode: booking.fromCode,
      fromCity: booking.fromCity,
      fromAirport: booking.fromCity,
      toCode: booking.toCode,
      toCity: booking.toCity,
      toAirport: booking.toCity,
      departTime: booking.departTime,
      arrivalTime: booking.arrivalTime,
      duration: '',
      durationMinutes: 0,
      stops: 0,
      price: pricePerPerson,
      baggageIncluded: true,
      refundable: true,
      amenities: ['Entertainment', 'Wi-Fi', 'Meal included', 'Refundable'],
      availableSeats: 0,
      aircraftType: 'Boeing 777',
    );
  }

  SearchState _searchFromBooking(BookingModel booking) {
    DateTime date;
    try {
      date = DateFormat('d MMM yyyy').parse(booking.departDate);
    } catch (_) {
      date = DateTime.now();
    }
    return SearchState(
      from: CityModel(
        city: booking.fromCity,
        code: booking.fromCode,
        airport: booking.fromCity,
        country: '',
      ),
      to: CityModel(
        city: booking.toCity,
        code: booking.toCode,
        airport: booking.toCity,
        country: '',
      ),
      departDate: date,
      adults: booking.adults,
      children: booking.children,
      infants: booking.infants,
      cabinClass: booking.cabinClass,
    );
  }

  Widget _apColumn(String code, String city, String time) => Column(
    children: [
      Text(
        code,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.navy,
        ),
      ),
      Text(
        city,
        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
      ),
      const SizedBox(height: 4),
      Text(
        time,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textDark,
        ),
      ),
    ],
  );

  Widget _amenityTile(IconData icon, String label) => Container(
    decoration: BoxDecoration(
      color: AppColors.beige,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        const SizedBox(width: 12),
        Icon(icon, size: 15, color: AppColors.blue),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textDark),
        ),
      ],
    ),
  );
}
