import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/flight_model.dart';
import '../models/search_state.dart';
import '../services/flight_services.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'flight_details_screen.dart';

class flight_results_screen extends StatefulWidget {
  final SearchState search;
  const flight_results_screen({super.key, required this.search});

  @override
  State<flight_results_screen> createState() => _FlightResultsScreenState();
}

class _FlightResultsScreenState extends State<flight_results_screen> {
  final _service = FlightService();
  List<FlightModel> _allFlights = [];
  List<FlightModel> _filtered = [];
  bool _loading = true;
  String _activeFilter = 'all';
  String _sortBy = 'best';

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    setState(() => _loading = true);
    final date = DateFormat('yyyy-MM-dd').format(widget.search.departDate);
    final results = await _service.searchFlights(
      fromCode: widget.search.from.code,
      toCode: widget.search.to.code,
      date: date,
      directOnly: widget.search.directOnly,
      baggageIncluded: widget.search.baggageIncluded,
      refundableOnly: widget.search.refundableOnly,
      sortBy: _sortBy,
    );
    setState(() {
      _allFlights = results;
      _applyFilter();
      _loading = false;
    });
  }

  void _applyFilter() {
    var list = List<FlightModel>.from(_allFlights);
    if (_activeFilter == 'direct')
      list = list.where((f) => f.stops == 0).toList();
    if (_activeFilter == 'stop') list = list.where((f) => f.stops > 0).toList();
    if (_activeFilter == 'bag')
      list = list.where((f) => f.baggageIncluded).toList();
    if (_activeFilter == 'ref') list = list.where((f) => f.refundable).toList();
    if (_sortBy == 'cheap') list.sort((a, b) => a.price.compareTo(b.price));
    if (_sortBy == 'fast')
      list.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
    setState(() => _filtered = list);
  }

  void _setFilter(String f) {
    setState(() => _activeFilter = f);
    _applyFilter();
  }

  void _setSort(String s) {
    setState(() => _sortBy = s);
    _applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('d MMM');
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          // ── Navy header ────────────────────────────────────────────────
          NavyHeader(
            title: 'Select flight',
            onBack: () => Navigator.pop(context),
            trailing: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.navyLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.tune, color: Colors.white54, size: 16),
            ),
            extra: [
              const SizedBox(height: 14),
              Text(
                '${widget.search.from.city} → ${widget.search.to.city}',
                style: const TextStyle(fontSize: 11, color: Colors.white54),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(
                    widget.search.from.code,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '——✈——',
                      style: TextStyle(
                        color: Colors.white.withOpacity(.3),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    widget.search.to.code,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${fmt.format(widget.search.departDate)} · ${widget.search.passengerLabel} · ${widget.search.cabinClass}',
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
          // ── White body ─────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                    child: Column(
                      children: [
                        // Filter chips
                        SizedBox(
                          height: 36,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (final f in [
                                ('all', 'All'),
                                ('direct', 'Direct'),
                                ('stop', '1 stop'),
                                ('bag', 'Baggage'),
                                ('ref', 'Refundable'),
                              ])
                                _FilterChipBtn(
                                  label: f.$2,
                                  active: _activeFilter == f.$1,
                                  onTap: () => _setFilter(f.$1),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Sort + count
                        Row(
                          children: [
                            Text(
                              '${_filtered.length} flight${_filtered.length != 1 ? 's' : ''} found',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const Spacer(),
                            for (final s in [
                              ('best', 'Best'),
                              ('cheap', 'Cheapest'),
                              ('fast', 'Fastest'),
                            ])
                              _SortBtn(
                                label: s.$2,
                                active: _sortBy == s.$1,
                                onTap: () => _setSort(s.$1),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  // Flight list
                  Expanded(
                    child: _loading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.navy,
                            ),
                          )
                        : _filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.airplanemode_off,
                                  size: 48,
                                  color: AppColors.beige3,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No flights match your filters',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadFlights,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                              itemCount: _filtered.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (_, i) => _FlightCard(
                                flight: _filtered[i],
                                isHighlighted: i == 0,
                                search: widget.search,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => FlightDetailsScreen(
                                      flight: _filtered[i],
                                      search: widget.search,
                                    ),
                                  ),
                                ),
                              ),
                            ),
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
}

// ══════════════════════════════════════════════════════════════════════════════
// Flight card
// ══════════════════════════════════════════════════════════════════════════════
class _FlightCard extends StatelessWidget {
  final FlightModel flight;
  final bool isHighlighted;
  final SearchState search;
  final VoidCallback onTap;

  const _FlightCard({
    required this.flight,
    required this.isHighlighted,
    required this.search,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isHighlighted ? AppColors.lightBlue : AppColors.beige,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isHighlighted
                ? AppColors.blue.withOpacity(.4)
                : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Top row: airline + price
            Row(
              children: [
                AirlineBadge(flight.airlineCode),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.airline,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      flight.flightNumber,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.beige3,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${flight.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                    const Text(
                      'per person',
                      style: TextStyle(fontSize: 9, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Route
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      flight.departTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      search.from.code,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        flight.duration,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.beige3,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.beige3,
                            ),
                          ),
                          const Icon(
                            Icons.flight,
                            size: 13,
                            color: AppColors.blue,
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color: AppColors.beige3,
                            ),
                          ),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.beige3,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: flight.stops == 0
                              ? AppColors.greenBg
                              : AppColors.amberBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          flight.stops == 0 ? 'Direct' : '${flight.stops} stop',
                          style: TextStyle(
                            fontSize: 8,
                            color: flight.stops == 0
                                ? AppColors.green
                                : AppColors.amber,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      flight.arrivalTime,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      search.to.code,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(height: 1, color: AppColors.beige3),
            const SizedBox(height: 8),
            // Tags + select button
            Row(
              children: [
                if (flight.baggageIncluded)
                  _tag(
                    Icons.luggage_outlined,
                    '${flight.availableSeats > 20 ? 23 : 20}kg',
                  ),
                if (flight.refundable) _tag(Icons.sync_alt, 'Flex'),
                const Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Text(
                      'Select ↗',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(IconData icon, String label) => Container(
    margin: const EdgeInsets.only(right: 5),
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: AppColors.beige3),
    ),
    child: Row(
      children: [
        Icon(icon, size: 10, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
        ),
      ],
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// Filter chip button
// ══════════════════════════════════════════════════════════════════════════════
class _FilterChipBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChipBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 7),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppColors.navy : AppColors.beige3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sort button
// ══════════════════════════════════════════════════════════════════════════════
class _SortBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _SortBtn({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(left: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.navy : AppColors.beige3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.white : AppColors.textMuted,
            fontWeight: active ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
