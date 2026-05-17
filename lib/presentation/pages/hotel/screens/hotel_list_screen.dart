import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../services/hotel_services.dart';
import 'hotel_detail_screen.dart';
//import 'package:venturepoint/core/theme/app_colors.dart';

class HotelListScreen extends StatefulWidget {
  static const routeName = '/hotels';
  const HotelListScreen({super.key});

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

class _HotelCard extends StatefulWidget {
  final Hotel hotel;
  const _HotelCard({required this.hotel});

  @override
  State<_HotelCard> createState() => _HotelCardState();
}

class _HotelCardState extends State<_HotelCard> {
  late final PageController _pageController;
  int _currentVirtualPage = 1;
  Timer? _autoScrollTimer;

  bool get _hasLoopingImages => widget.hotel.images.length > 1;
  int get _virtualPageCount => _hasLoopingImages ? widget.hotel.images.length + 2 : 1;
  int get _initialVirtualPage => _hasLoopingImages ? 1 : 0;

  int _mapVirtualIndex(int index) {
    if (!_hasLoopingImages) return 0;
    if (index == 0) {
      return widget.hotel.images.length - 1;
    }
    if (index == widget.hotel.images.length + 1) {
      return 0;
    }
    return index - 1;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialVirtualPage);
    _currentVirtualPage = _initialVirtualPage;
    _startAutoScroll();
  }

  @override
  void didUpdateWidget(covariant _HotelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hotel.images.length != widget.hotel.images.length) {
      _autoScrollTimer?.cancel();
      _pageController.jumpToPage(_initialVirtualPage);
      _currentVirtualPage = _initialVirtualPage;
      _startAutoScroll();
    }
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    if (!_hasLoopingImages) return;
    setState(() {
      _currentVirtualPage = page;
    });

    if (page == 0) {
      Future.microtask(() {
        if (!_pageController.hasClients) return;
        _pageController.jumpToPage(widget.hotel.images.length);
      });
      return;
    }

    if (page == widget.hotel.images.length + 1) {
      Future.microtask(() {
        if (!_pageController.hasClients) return;
        _pageController.jumpToPage(1);
      });
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (!_hasLoopingImages) return;
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!_pageController.hasClients) return;
      final nextPage = _currentVirtualPage + 1;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  String _resolveHotelImagePath(String img) {
    var trimmed = img.trim().replaceAll('\\', '/');
    trimmed = trimmed.replaceAll(RegExp(r'^/+'), '');
    if (trimmed.isEmpty) return '';
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('assets/')) {
      if (trimmed.startsWith('assets/images/') && RegExp(r'hotel\d+_\d+\.(jpe?g|png)$', caseSensitive: false).hasMatch(trimmed)) {
        return 'lib/presentation/pages/hotel/assets/${trimmed.substring('assets/'.length)}';
      }
      return trimmed;
    }
    if (trimmed.startsWith('lib/')) {
      return trimmed;
    }
    if (trimmed.startsWith('images/')) {
      return 'lib/presentation/pages/hotel/assets/$trimmed';
    }
    return 'lib/presentation/pages/hotel/assets/images/$trimmed';
  }

  Widget _buildHotelImage(String img, {double? height}) {
    final resolvedImage = _resolveHotelImagePath(img);
    if (resolvedImage.isEmpty) {
      return Container(
        height: height ?? 220,
        width: double.infinity,
        color: const Color(0xFF1A6B8A),
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.white70, size: 32),
        ),
      );
    }

    final isNetwork = resolvedImage.startsWith('http://') || resolvedImage.startsWith('https://');
    if (isNetwork) {
      return CachedNetworkImage(
        imageUrl: resolvedImage,
        height: height ?? 220,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          height: height ?? 220,
          width: double.infinity,
          color: const Color(0xFFEEEDED),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFF0A3D5C)),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          height: height ?? 220,
          width: double.infinity,
          color: const Color(0xFF1A6B8A),
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white70, size: 32),
          ),
        ),
      );
    }
    return Image.asset(
      resolvedImage,
      height: height ?? 220,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: height ?? 220,
        width: double.infinity,
        color: const Color(0xFF1A6B8A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotel = widget.hotel;
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
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _virtualPageCount,
                    itemBuilder: (context, index) {
                      final img = hotel.images.isNotEmpty ? hotel.images[_mapVirtualIndex(index)] : '';
                      return _buildHotelImage(img, height: 220);
                    },
                  ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        hotel.badge,
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
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
                      child: const Icon(Icons.favorite_border, size: 14, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.75), Colors.transparent],
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  hotel.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  hotel.location,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '\$${hotel.pricePerNight.toInt()}/night',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A3D5C),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Text(
                              'Select',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
