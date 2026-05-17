import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../services/hotel_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'hotel_detail_screen.dart';
//import 'package:venturepoint/core/theme/app_colors.dart';

class HotelListScreen extends StatefulWidget {
  static const routeName = '/hotels';
  const HotelSearchPage({super.key});
  @override
  State<HotelListScreen> createState() => _HotelListScreenState();
}

class _HotelListScreenState extends State<HotelListScreen> {
  final HotelService _hotelService = HotelService();
  String _selectedTag = 'all';
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _tags = [
    {'label': 'All', 'value': 'all'},
    {'label': '5-star', 'value': '5star'},
    {'label': 'Resort', 'value': 'resort'},
    {'label': 'Boutique', 'value': 'boutique'},
    {'label': 'Family', 'value': 'family'},
    {'label': 'Budget', 'value': 'budget'},
  ];

  List<Hotel> _applyFilters(List<Hotel> hotels) {
    return hotels.where((h) {
      final matchTag = _selectedTag == 'all' || h.category == _selectedTag;
      final matchSearch =
          _searchQuery.isEmpty ||
          h.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchTag && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 36),
                  const Text(
                    'Hotels',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A3D5C),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchQuery = '';
                          _searchController.clear();
                        }
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: _isSearching
                            ? const Color(0xFF0A3D5C)
                            : const Color(0xFF0A3D5C),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isSearching ? Icons.close : Icons.search,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isSearching ? 52 : 0,
              child: _isSearching
                  ? Padding(
                      padding: const EdgeInsetsGeometry.fromLTRB(14, 8, 14, 0),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0DDD8),
                            width: 0.5,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          style: const TextStyle(fontSize: 14),
                          decoration: const InputDecoration(
                            hintText: 'Search hotels or areas...',
                            hintStyle: TextStyle(
                              color: Color(0xFFBBBBBB),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFF0A3D5C),
                              size: 18,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onChanged: (val) =>
                              setState(() => _searchQuery = val),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),

            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(14, 14, 14, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  const Text(
                    'Find your perfect stay...',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A3D5C),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: _tags.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (context, i) {
                  final tag = _tags[i];
                  final isOn = _selectedTag == tag['value'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTag = tag['value']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isOn
                            ? const Color(0xFF0A3D5C)
                            : const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isOn
                              ? const Color(0xFF0A3D5C)
                              : const Color(0xFFB8E4EE),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        tag['label']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isOn ? Colors.white : const Color(0xFF1A6B8A),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Hotel>>(
                stream: _hotelService.getHotels(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0A3D5C),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error:${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  final allHotels = snapshot.data ?? [];
                  final filtered = _applyFilters(allHotels);

                  if (filtered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 40,
                            color: Color(0xFFCCCCCC),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'No results for "$_searchQuery"'
                                : 'No hotels in this category',
                            style: const TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                        child: Text(
                          '${filtered.length} hotels found',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFBBBBBB),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, i) =>
                              _HotelCard(hotel: filtered[i]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
    // throw UnimplementedError();
  }
}

class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  const _HotelCard({required this.hotel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HotelDetailScreen(hotel: hotel)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAE8E2), width: 0.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 220,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                  ),
                  items: hotel.images.map((img) {
                    return Stack(
                      children: [
                        Image.asset(
                          img,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 220,
                            color: const Color(0xFF1A6B8A),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              hotel.badge,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              size: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotel.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hotel.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${hotel.pricePerNight.toInt()}/night',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      HotelDetailScreen(hotel: hotel),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A3D5C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Select',
                                  style: TextStyle(
                                    fontSize: 16,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


  
