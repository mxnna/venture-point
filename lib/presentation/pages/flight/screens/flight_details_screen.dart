import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../models/search_state.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'seat_selection_screen.dart';

class FlightDetailsScreen extends StatelessWidget {
  final FlightModel flight;
  final SearchState search;

  const FlightDetailsScreen({
    super.key,
    required this.flight,
    required this.search,
  });

  @override
  Widget build(BuildContext context) {
    final total = flight.price * search.totalPassengers;
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          NavyHeader(
            title: 'Flight details',
            onBack: () => Navigator.pop(context),
            trailing: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border,
                color: Colors.white54,
                size: 16,
              ),
            ),
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
                  // Airline row
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.beige,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        AirlineBadge(flight.airlineCode, size: 36),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                flight.airline,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                '${flight.flightNumber} · ${flight.aircraftType}',
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
                            flight.stops == 0
                                ? 'Direct'
                                : '${flight.stops} stop',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: flight.stops == 0
                                  ? AppColors.green
                                  : AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Route row
                  Row(
                    children: [
                      _apColumn(
                        search.from.code,
                        search.from.city,
                        flight.departTime,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              flight.duration,
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.greenBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Non-stop',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _apColumn(
                        search.to.code,
                        search.to.city,
                        flight.arrivalTime,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Info grid
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
                        value: DateFormat(
                          'EEE d MMM',
                        ).format(search.departDate),
                        icon: Icons.calendar_today_outlined,
                      ),
                      InfoBox(
                        label: 'Class',
                        value: search.cabinClass,
                        icon: Icons.airline_seat_recline_extra,
                      ),
                      InfoBox(
                        label: 'Passengers',
                        value: '${search.totalPassengers} total',
                        icon: Icons.people_outline,
                      ),
                      InfoBox(
                        label: 'Baggage',
                        value: flight.baggageIncluded
                            ? '23kg incl.'
                            : 'Not incl.',
                        icon: Icons.luggage_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Amenities
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
                  // Price bar
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
                              '\$${flight.price.toInt()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.navy,
                              ),
                            ),
                            Text(
                              'per person · total \$${total.toInt()}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SeatSelectionScreen(
                                flight: flight,
                                search: search,
                              ),
                            ),
                          ),
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
                          child: const Text(
                            'Choose seat →',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
