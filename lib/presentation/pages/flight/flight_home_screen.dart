import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/search_state.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'flight_results_screen.dart';

class flight_home_screen extends StatefulWidget {
  const flight_home_screen({super.key});

  @override
  State<flight_home_screen> createState() => _FlightHomeScreenState();
}

class _FlightHomeScreenState extends State<flight_home_screen> {
  SearchState? _search;
  List<CityModel> _cities = [];
  bool _loadingCities = true;
  bool _leg2 = false;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  // ─── Load cities from Firestore ──────────────────────────────────────────
  Future<void> _loadCities() async {
    final cities = await CitiesService.getCities();
    if (!mounted) return;
    setState(() {
      _cities = cities;
      _loadingCities = false;
      // Default: first two cities
      if (cities.length >= 2) {
        _search = SearchState(
          from: cities.firstWhere((c) => c.code == 'CAI', orElse: () => cities[0]),
          to:   cities.firstWhere((c) => c.code == 'JED', orElse: () => cities[1]),
          departDate: DateTime.now().add(const Duration(days: 1)),
          returnDate: DateTime.now().add(const Duration(days: 8)),
        );
      } else if (cities.length == 1) {
        _search = SearchState(
          from: cities[0], to: cities[0],
          departDate: DateTime.now().add(const Duration(days: 1)),
        );
      }
    });
  }

  // ─── City picker ─────────────────────────────────────────────────────────
  void _openCityPicker(bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CityPickerSheet(
        title: isFrom ? 'Select departure city' : 'Select destination',
        cities: _cities,
        onPick: (city) => setState(() {
          _search = isFrom
              ? _search!.copyWith(from: city)
              : _search!.copyWith(to: city);
        }),
      ),
    );
  }

  // ─── Date picker ─────────────────────────────────────────────────────────
  void _openDatePicker(bool isDepart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DatePickerSheet(
        title: isDepart ? 'Select departure date' : 'Select return date',
        initialDate: isDepart
            ? _search!.departDate
            : (_search!.returnDate ?? DateTime.now().add(const Duration(days: 7))),
        onConfirm: (date) => setState(() {
          _search = isDepart
              ? _search!.copyWith(departDate: date)
              : _search!.copyWith(returnDate: date);
        }),
      ),
    );
  }

  // ─── Passenger picker ────────────────────────────────────────────────────
  void _openPaxPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PaxPickerSheet(
        adults: _search!.adults,
        children: _search!.children,
        infants: _search!.infants,
        cabinClass: _search!.cabinClass,
        onConfirm: (a, ch, i, cls) => setState(() {
          _search = _search!.copyWith(
              adults: a, children: ch, infants: i, cabinClass: cls);
        }),
      ),
    );
  }

  void _doSearch() {
    if (_search == null) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => flight_results_screen(search: _search!),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Column(children: [
        SizedBox(height: top + 4),
        // ── Hero header ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Good morning ✦',
                  style: TextStyle(fontSize: 11, color: AppColors.blue.withOpacity(.7))),
              const SizedBox(height: 2),
              const Text('Book your\nnext flight',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500,
                      color: Colors.white, height: 1.2)),
              const SizedBox(height: 2),
              Text('Best deals, instantly',
                  style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(.5))),
            ]),
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: AppColors.navyLight, shape: BoxShape.circle),
              child: const Icon(Icons.notifications_none, color: Colors.white54, size: 18),
            ),
          ]),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 8, top: 6),
            child: Icon(Icons.flight, size: 72, color: AppColors.navyLight),
          ),
        ),
        // ── White card ────────────────────────────────────────────────
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: _loadingCities
                ? const Center(child: CircularProgressIndicator(color: AppColors.navy))
                : _search == null
                    ? const Center(child: Text('No cities found in Firestore',
                        style: TextStyle(color: AppColors.textMuted)))
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          // Trip type tabs
                          _TripTypeTabs(
                            selected: _search!.tripType,
                            onChanged: (t) => setState(
                                () => _search = _search!.copyWith(tripType: t)),
                          ),
                          const SizedBox(height: 12),
                          // Form
                          _search!.tripType != 'multi'
                              ? _buildNormalForm()
                              : _buildMultiForm(),
                          const SizedBox(height: 10),
                          // Passengers & class
                          FieldBox(
                            onTap: _openPaxPicker,
                            child: Row(children: [
                              Icon(Icons.people_outline, size: 16, color: AppColors.blue),
                              const SizedBox(width: 8),
                              Expanded(child: Text(_search!.passengerLabel,
                                  style: const TextStyle(fontSize: 13,
                                      fontWeight: FontWeight.w500, color: AppColors.textDark))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: AppColors.lightBlue, borderRadius: BorderRadius.circular(6)),
                                child: Text(_search!.cabinClass,
                                    style: const TextStyle(fontSize: 10,
                                        fontWeight: FontWeight.w500, color: AppColors.navy)),
                              ),
                            ]),
                          ),
                          const SizedBox(height: 10),
                          // Filter chips
                          Wrap(spacing: 7, runSpacing: 7, children: [
                            FilterChip2(label: 'Direct only', active: _search!.directOnly,
                                onTap: () => setState(() => _search =
                                    _search!.copyWith(directOnly: !_search!.directOnly))),
                            FilterChip2(label: 'Baggage incl.', active: _search!.baggageIncluded,
                                onTap: () => setState(() => _search =
                                    _search!.copyWith(baggageIncluded: !_search!.baggageIncluded))),
                            FilterChip2(label: 'Flexible dates', active: _search!.flexibleDates,
                                onTap: () => setState(() => _search =
                                    _search!.copyWith(flexibleDates: !_search!.flexibleDates))),
                            FilterChip2(label: 'Refundable', active: _search!.refundableOnly,
                                onTap: () => setState(() => _search =
                                    _search!.copyWith(refundableOnly: !_search!.refundableOnly))),
                          ]),
                          const SizedBox(height: 14),
                          NavyButton(
                            label: 'Search flights',
                            onTap: _doSearch,
                            icon: const Icon(Icons.search, color: Colors.white, size: 18),
                          ),
                          const SizedBox(height: 18),
                          const SectionHeader(title: 'Recent searches', action: 'See all'),
                          const SizedBox(height: 10),
                          _RecentCard(
                              from: 'CAI', to: 'DXB',
                              meta: 'Feb 16 · 1 seat', price: 'from \$210',
                              onTap: _doSearch),
                          const SizedBox(height: 8),
                          _RecentCard(
                              from: 'CAI', to: 'LHR',
                              meta: 'Mar 5 · 2 seats', price: 'from \$580',
                              onTap: _doSearch),
                        ],
                      ),
          ),
        ),
      ]),
    );
  }

  // ─── Normal form ─────────────────────────────────────────────────────────
  Widget _buildNormalForm() {
    final fmt = DateFormat('d MMM yyyy');
    return Column(children: [
      const Align(alignment: Alignment.centerLeft,
          child: Text('From', style: TextStyle(fontSize: 10,
              color: AppColors.textMuted, fontWeight: FontWeight.w500))),
      const SizedBox(height: 4),
      FieldBox(
        onTap: () => _openCityPicker(true),
        child: Row(children: [
          Icon(Icons.flight_takeoff, size: 16, color: AppColors.blue),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_search!.from.airport,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: AppColors.textDark)),
            Text(_search!.from.country,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ])),
          CodeBadge(_search!.from.code),
        ]),
      ),
      // Swap button
      Center(
        child: GestureDetector(
          onTap: () => setState(() =>
              _search = _search!.copyWith(from: _search!.to, to: _search!.from)),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            width: 32, height: 32,
            decoration: BoxDecoration(color: AppColors.navy, shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3)),
            child: const Icon(Icons.swap_vert, color: Colors.white, size: 16),
          ),
        ),
      ),
      const Align(alignment: Alignment.centerLeft,
          child: Text('To', style: TextStyle(fontSize: 10,
              color: AppColors.textMuted, fontWeight: FontWeight.w500))),
      const SizedBox(height: 4),
      FieldBox(
        onTap: () => _openCityPicker(false),
        child: Row(children: [
          Icon(Icons.flight_land, size: 16, color: AppColors.blue),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(_search!.to.airport,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: AppColors.textDark)),
            Text(_search!.to.country,
                style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ])),
          CodeBadge(_search!.to.code),
        ]),
      ),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: FieldBox(
          onTap: () => _openDatePicker(true),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Depart', style: TextStyle(fontSize: 10,
                color: AppColors.textMuted, fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Row(children: [
              Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.blue),
              const SizedBox(width: 5),
              Text(fmt.format(_search!.departDate),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                      color: AppColors.textDark)),
            ]),
          ]),
        )),
        if (_search!.tripType == 'round') ...[
          const SizedBox(width: 8),
          Expanded(child: FieldBox(
            onTap: () => _openDatePicker(false),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Return', style: TextStyle(fontSize: 10,
                  color: AppColors.textMuted, fontWeight: FontWeight.w500)),
              const SizedBox(height: 3),
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.blue),
                const SizedBox(width: 5),
                Text(_search!.returnDate != null
                    ? fmt.format(_search!.returnDate!) : 'Select',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,
                        color: AppColors.textDark)),
              ]),
            ]),
          )),
        ],
      ]),
    ]);
  }

  // ─── Multi-city form ──────────────────────────────────────────────────────
  Widget _buildMultiForm() {
    return Column(children: [
      _MultiLeg(index: 1, from: _search!.from, to: _search!.to,
          date: _search!.departDate, canRemove: false,
          onFrom: () => _openCityPicker(true),
          onTo: () => _openCityPicker(false),
          onDate: () => _openDatePicker(true),
          onRemove: null),
      if (_leg2) ...[
        const SizedBox(height: 8),
        _MultiLeg(
            index: 2,
            from: _search!.to,
            to: _cities.isNotEmpty
                ? _cities.firstWhere((c) => c.code != _search!.to.code,
                    orElse: () => _search!.to)
                : _search!.to,
            date: _search!.returnDate ?? DateTime.now().add(const Duration(days: 7)),
            canRemove: true,
            onFrom: null,
            onTo: () => _openCityPicker(false),
            onDate: () => _openDatePicker(false),
            onRemove: () => setState(() => _leg2 = false)),
      ],
      const SizedBox(height: 8),
      if (!_leg2)
        GestureDetector(
          onTap: () => setState(() => _leg2 = true),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.beige3, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('+ Add another flight', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.blue)),
          ),
        ),
    ]);
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Trip type tabs
// ══════════════════════════════════════════════════════════════════════════════
class _TripTypeTabs extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _TripTypeTabs({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final tabs = [('round', 'Round trip'), ('one', 'One way'), ('multi', 'Multi-city')];
    return Row(children: tabs.map((t) {
      final on = selected == t.$1;
      return Expanded(child: GestureDetector(
        onTap: () => onChanged(t.$1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: on ? AppColors.navy : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: on ? AppColors.navy : AppColors.beige3),
          ),
          child: Text(t.$2, textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10,
                  color: on ? Colors.white : AppColors.textMuted,
                  fontWeight: on ? FontWeight.w500 : FontWeight.w400)),
        ),
      ));
    }).toList());
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Multi leg row
// ══════════════════════════════════════════════════════════════════════════════
class _MultiLeg extends StatelessWidget {
  final int index;
  final CityModel from, to;
  final DateTime date;
  final bool canRemove;
  final VoidCallback? onFrom, onTo, onDate, onRemove;

  const _MultiLeg({required this.index, required this.from, required this.to,
    required this.date, required this.canRemove,
    this.onFrom, this.onTo, this.onDate, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(12)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Flight $index',
              style: const TextStyle(fontSize: 10, color: AppColors.textMuted,
                  fontWeight: FontWeight.w500)),
          if (canRemove)
            GestureDetector(onTap: onRemove,
                child: const Icon(Icons.close, size: 16, color: AppColors.textMuted)),
        ]),
        const SizedBox(height: 7),
        GestureDetector(onTap: onFrom, child: _legRow(Icons.flight_takeoff, '${from.city} (${from.code})')),
        const SizedBox(height: 6),
        GestureDetector(onTap: onTo, child: _legRow(Icons.flight_land, '${to.city} (${to.code})')),
        const SizedBox(height: 6),
        GestureDetector(onTap: onDate,
            child: _legRow(Icons.calendar_today_outlined, DateFormat('d MMM yyyy').format(date))),
      ]),
    );
  }

  Widget _legRow(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)),
    child: Row(children: [
      Icon(icon, size: 14, color: AppColors.blue),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 12,
          fontWeight: FontWeight.w500, color: AppColors.textDark)),
    ]),
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// Recent search card
// ══════════════════════════════════════════════════════════════════════════════
class _RecentCard extends StatelessWidget {
  final String from, to, meta, price;
  final VoidCallback onTap;
  const _RecentCard({required this.from, required this.to,
    required this.meta, required this.price, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: AppColors.beige, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          Text(from, style: const TextStyle(fontSize: 16,
              fontWeight: FontWeight.w600, color: AppColors.textDark)),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(children: [
              Container(width: 5, height: 5,
                  decoration: const BoxDecoration(color: AppColors.beige3, shape: BoxShape.circle)),
              Expanded(child: Container(height: 1, color: AppColors.beige3)),
              const Icon(Icons.flight, size: 12, color: AppColors.blue),
              Expanded(child: Container(height: 1, color: AppColors.beige3)),
              Container(width: 5, height: 5,
                  decoration: const BoxDecoration(color: AppColors.beige3, shape: BoxShape.circle)),
            ]),
          )),
          Text(to, style: const TextStyle(fontSize: 16,
              fontWeight: FontWeight.w600, color: AppColors.textDark)),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(meta, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            Text(price, style: const TextStyle(fontSize: 11, color: AppColors.blue)),
          ]),
        ]),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// City picker sheet — يجيب المدن من Firestore
// ══════════════════════════════════════════════════════════════════════════════
class _CityPickerSheet extends StatefulWidget {
  final String title;
  final List<CityModel> cities;
  final ValueChanged<CityModel> onPick;
  const _CityPickerSheet({required this.title, required this.cities, required this.onPick});

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  String _q = '';

  List<CityModel> get _filtered => widget.cities.where((c) =>
      c.city.toLowerCase().contains(_q.toLowerCase()) ||
      c.code.toLowerCase().contains(_q.toLowerCase()) ||
      c.airport.toLowerCase().contains(_q.toLowerCase())).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Container(width: 40, height: 3,
            decoration: BoxDecoration(color: AppColors.beige3, borderRadius: BorderRadius.circular(2))),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Column(children: [
            Text(widget.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.textDark)),
            const SizedBox(height: 12),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'Search cities...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                filled: true, fillColor: AppColors.beige,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ]),
        ),
        // Cities list
        SizedBox(
          height: 320,
          child: widget.cities.isEmpty
              ? const Center(child: CircularProgressIndicator(color: AppColors.navy))
              : _filtered.isEmpty
                  ? const Center(child: Text('No cities found',
                      style: TextStyle(color: AppColors.textMuted)))
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (_, i) {
                        final city = _filtered[i];
                        return ListTile(
                          leading: Container(
                            width: 42, height: 42,
                            decoration: BoxDecoration(
                                color: AppColors.lightBlue,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Text(city.code,
                                style: const TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600, color: AppColors.navy)),
                          ),
                          title: Text(city.city,
                              style: const TextStyle(fontSize: 14,
                                  fontWeight: FontWeight.w500, color: AppColors.textDark)),
                          subtitle: Text('${city.airport} · ${city.country}',
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                          onTap: () {
                            widget.onPick(city);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
        ),
        const SizedBox(height: 16),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Date picker sheet
// ══════════════════════════════════════════════════════════════════════════════
class _DatePickerSheet extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final ValueChanged<DateTime> onConfirm;
  const _DatePickerSheet({required this.title, required this.initialDate, required this.onConfirm});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _selected;
  String _timeSlot = 'Morning';

  @override
  void initState() { super.initState(); _selected = widget.initialDate; }

  @override
  Widget build(BuildContext context) {
    final slots = ['Early morning\n00:00–06:00', 'Morning\n06:00–12:00',
      'Afternoon\n12:00–18:00', 'Evening\n18:00–24:00'];
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 3,
            decoration: BoxDecoration(color: AppColors.beige3, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 14),
        Text(widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const SizedBox(height: 12),
        CalendarDatePicker(
          initialDate: _selected,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
          onDateChanged: (d) => setState(() => _selected = d),
        ),
        const Align(alignment: Alignment.centerLeft,
          child: Text('Preferred departure time',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark))),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3.2, mainAxisSpacing: 8, crossAxisSpacing: 8,
          children: slots.map((slot) {
            final label = slot.split('\n')[0];
            final sub   = slot.split('\n')[1];
            final on    = _timeSlot == label;
            return GestureDetector(
              onTap: () => setState(() => _timeSlot = label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: on ? AppColors.lightBlue : AppColors.beige,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: on ? AppColors.blue.withOpacity(.5) : Colors.transparent),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(label, style: TextStyle(fontSize: 11,
                      fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                      color: on ? AppColors.navy : AppColors.textDark)),
                  Text(sub, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
                ]),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),
        NavyButton(label: 'Confirm', onTap: () {
          widget.onConfirm(_selected);
          Navigator.pop(context);
        }),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Passenger picker sheet
// ══════════════════════════════════════════════════════════════════════════════
class _PaxPickerSheet extends StatefulWidget {
  final int adults, children, infants;
  final String cabinClass;
  final void Function(int, int, int, String) onConfirm;
  const _PaxPickerSheet({required this.adults, required this.children,
    required this.infants, required this.cabinClass, required this.onConfirm});

  @override
  State<_PaxPickerSheet> createState() => _PaxPickerSheetState();
}

class _PaxPickerSheetState extends State<_PaxPickerSheet> {
  late int _adults, _children, _infants;
  late String _cls;

  @override
  void initState() {
    super.initState();
    _adults = widget.adults; _children = widget.children;
    _infants = widget.infants; _cls = widget.cabinClass;
  }

  Widget _counter(String label, String sub, int val, VoidCallback dec, VoidCallback inc) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13,
              fontWeight: FontWeight.w500, color: AppColors.textDark)),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ])),
        Row(children: [
          GestureDetector(onTap: dec,
            child: Container(width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.lightBlue, shape: BoxShape.circle),
                child: const Icon(Icons.remove, size: 16, color: AppColors.navy))),
          SizedBox(width: 32, child: Text('$val', textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.navy))),
          GestureDetector(onTap: inc,
            child: Container(width: 32, height: 32,
                decoration: BoxDecoration(color: AppColors.lightBlue, shape: BoxShape.circle),
                child: const Icon(Icons.add, size: 16, color: AppColors.navy))),
        ]),
      ]),
    );

  @override
  Widget build(BuildContext context) {
    final classes = ['Economy', 'Premium Eco', 'Business', 'First Class'];
    return Container(
      decoration: const BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 40, height: 3,
            decoration: BoxDecoration(color: AppColors.beige3, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 14),
        const Text('Passengers & class',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDark)),
        const Divider(),
        _counter('Adults', 'Age 12+', _adults,
            () => setState(() => _adults = (_adults - 1).clamp(1, 9)),
            () => setState(() => _adults++)),
        const Divider(height: 1),
        _counter('Children', 'Age 2–11', _children,
            () => setState(() => _children = (_children - 1).clamp(0, 9)),
            () => setState(() => _children++)),
        const Divider(height: 1),
        _counter('Infants', 'Under 2', _infants,
            () => setState(() => _infants = (_infants - 1).clamp(0, _adults)),
            () => setState(() { if (_infants < _adults) _infants++; })),
        const Divider(),
        const Align(alignment: Alignment.centerLeft,
          child: Text('Cabin class', style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w500, color: AppColors.textDark))),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2, shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 3, mainAxisSpacing: 8, crossAxisSpacing: 8,
          children: classes.map((cls) {
            final on = _cls == cls;
            return GestureDetector(
              onTap: () => setState(() => _cls = cls),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: on ? AppColors.lightBlue : AppColors.beige,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: on ? AppColors.navy : Colors.transparent, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(cls, style: TextStyle(fontSize: 11,
                    fontWeight: on ? FontWeight.w600 : FontWeight.w400,
                    color: on ? AppColors.navy : AppColors.textDark)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        NavyButton(label: 'Confirm', onTap: () {
          widget.onConfirm(_adults, _children, _infants, _cls);
          Navigator.pop(context);
        }),
      ]),
    );
  }
}
