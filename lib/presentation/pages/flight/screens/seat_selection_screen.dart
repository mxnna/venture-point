import 'package:flutter/material.dart';
import '../models/flight_model.dart';
import '../models/search_state.dart';
import '../services/flight_services.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'payment_screen.dart';

class SeatSelectionScreen extends StatefulWidget {
  final FlightModel flight;
  final SearchState search;
  const SeatSelectionScreen({
    super.key,
    required this.flight,
    required this.search,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final _service = FlightService();
  Map<String, String> _seatMap = {};
  String? _selectedSeat;
  bool _loading = true;

  // Seat layout definition
  final _businessSeats = [
    ['1A', '1B', null, '1C', '1D'],
    ['2A', '2B', null, '2C', '2D'],
  ];
  final _economySeats = [
    ['10A', '10B', '10C', null, '10D', '10E', '10F'],
    ['11A', '11B', '11C', null, '11D', '11E', '11F'],
    ['12A', '12B', '12C', null, '12D', '12E', '12F'],
    ['23A', '23B', '23C', null, '23D', '23E', '23F'],
  ];

  @override
  void initState() {
    super.initState();
    _loadSeats();
  }

  Future<void> _loadSeats() async {
    final map = await _service.getSeatMap(widget.flight.id);
    setState(() {
      _seatMap = map;
      _loading = false;
    });
  }

  String get _seatType {
    if (_selectedSeat == null) return '';
    final col = _selectedSeat!.substring(_selectedSeat!.length - 1);
    if (col == 'A' || col == 'F') return 'Window';
    if (col == 'B' || col == 'E') return 'Middle';
    return 'Aisle';
  }

  String get _seatClass {
    if (_selectedSeat == null) return '';
    final row =
        int.tryParse(_selectedSeat!.replaceAll(RegExp(r'[A-F]'), '')) ?? 99;
    return row < 3 ? 'Business' : 'Economy';
  }

  void _confirm() async {
    if (_selectedSeat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a seat'),
          backgroundColor: AppColors.navy,
        ),
      );
      return;
    }
    final ok = await _service.reserveSeat(widget.flight.id, _selectedSeat!);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seat just taken, please choose another'),
          backgroundColor: Colors.redAccent,
        ),
      );
      _loadSeats();
      return;
    }
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          flight: widget.flight,
          search: widget.search,
          seat: _selectedSeat!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(
        children: [
          NavyHeader(
            title: 'Select seat',
            onBack: () => Navigator.pop(context),
            extra: [
              const SizedBox(height: 10),
              Text(
                '${widget.search.from.code} → ${widget.search.to.code}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '${widget.flight.airline} · ${widget.flight.flightNumber} · ${widget.search.cabinClass}',
                style: const TextStyle(fontSize: 10, color: Colors.white54),
              ),
            ],
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.navy),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            children: [
                              // Legend
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _legendItem(
                                    AppColors.lightBlue,
                                    AppColors.blue.withValues(alpha: .3),
                                    'Available',
                                  ),
                                  const SizedBox(width: 16),
                                  _legendItem(
                                    AppColors.beige2,
                                    Colors.transparent,
                                    'Reserved',
                                  ),
                                  const SizedBox(width: 16),
                                  _legendItem(
                                    AppColors.navy,
                                    Colors.transparent,
                                    'Selected',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Plane visualization
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.beige,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  children: [
                                    // Business section
                                    _CabinLabel(label: 'Business Class'),
                                    const SizedBox(height: 8),
                                    ..._businessSeats.asMap().entries.map(
                                      (e) => _SeatRow(
                                        row: e.key + 1,
                                        seats: e.value,
                                        seatMap: _seatMap,
                                        selected: _selectedSeat,
                                        onTap: (s) =>
                                            setState(() => _selectedSeat = s),
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Divider(
                                        color: AppColors.beige3,
                                        height: 1,
                                      ),
                                    ),
                                    // Economy section
                                    _CabinLabel(label: 'Economy Class'),
                                    const SizedBox(height: 8),
                                    ..._economySeats.asMap().entries.map((e) {
                                      final rowNums = [10, 11, 12, 23];
                                      return _SeatRow(
                                        row: rowNums[e.key],
                                        seats: e.value,
                                        seatMap: _seatMap,
                                        selected: _selectedSeat,
                                        onTap: (s) =>
                                            setState(() => _selectedSeat = s),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bottom bar
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .05),
                                blurRadius: 10,
                                offset: const Offset(0, -4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: _selectedSeat == null
                                    ? const Text(
                                        'Select a seat to continue',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Seat $_selectedSeat selected',
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                          Text(
                                            '$_seatType · $_seatClass',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                              ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 150,
                                ),
                                child: ElevatedButton(
                                  onPressed: _confirm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.navy,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    'Confirm →',
                                    style: TextStyle(
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

  Widget _legendItem(Color bg, Color border, String label) => Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border, width: .5),
        ),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
      ),
    ],
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// Cabin label
// ══════════════════════════════════════════════════════════════════════════════
class _CabinLabel extends StatelessWidget {
  final String label;
  const _CabinLabel({required this.label});

  @override
  Widget build(BuildContext context) => Text(
    label.toUpperCase(),
    style: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
      color: AppColors.textMuted,
      letterSpacing: 1,
    ),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// Seat row
// ══════════════════════════════════════════════════════════════════════════════
class _SeatRow extends StatelessWidget {
  final int row;
  final List<String?> seats;
  final Map<String, String> seatMap;
  final String? selected;
  final ValueChanged<String> onTap;

  const _SeatRow({
    required this.row,
    required this.seats,
    required this.seatMap,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$row',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(width: 4),
          ...seats.map((seatId) {
            if (seatId == null) return const SizedBox(width: 14);
            final status = seatMap[seatId] ?? 'available';
            final isTaken = status == 'taken';
            final isSel = selected == seatId;
            return GestureDetector(
              onTap: isTaken ? null : () => onTap(seatId),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isTaken
                      ? AppColors.beige2
                      : isSel
                      ? AppColors.navy
                      : AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isTaken
                        ? Colors.transparent
                        : isSel
                        ? AppColors.navy
                        : AppColors.blue.withValues(alpha: .3),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  seatId.replaceAll('$row', ''),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: isTaken
                        ? AppColors.beige3
                        : isSel
                        ? Colors.white
                        : AppColors.navy,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
