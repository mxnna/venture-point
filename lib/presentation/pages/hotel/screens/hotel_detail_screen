import 'package:flutter/material.dart';
import '../models/hotel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'booking_detail_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HotelDetailScreen extends StatefulWidget {
  final Hotel hotel;
  const HotelDetailScreen({super.key, required this.hotel});

  @override
  State<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends State<HotelDetailScreen> {
  int _adults = 2;
  int _children = 0;
  int _rooms = 1;
  int _nights = 1;
  DateTime _checkIn = DateTime(2025, 6, 10);

  final List<int> _nightOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  DateTime get _checkOut => _checkIn.add(Duration(days: _nights));
  int get _totalPrice => widget.hotel.pricePerNight * _nights * _rooms;

  Future<void> _openMap() async {
    final query = Uri.encodeComponent('${widget.hotel.name}, ${widget.hotel.location}',);
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _dayName(DateTime date) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return days[date.weekday % 7];
  }

  Future<void> _pickDate(bool isCheckIn) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkIn : _checkOut,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12, 31),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0A3D5C),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkIn = picked;
        }
      });
    }
  }

  static const List<Color> _imgColors = [
    Color(0xFF1A6B8A),
    Color(0xFFC4A882),
    Color(0xFF2E9BB5),
    Color(0xFFC49E82),
    Color(0xFFA882C4),
    Color(0xFF82A8C4),
  ];

  @override
  Widget build(BuildContext context) {
    final colorIndex = widget.hotel.id.hashCode.abs() % _imgColors.length;
    final bgColor = _imgColors[colorIndex];
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6F2),
      body: Column(
        children: [
          Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 280,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                ),
                items: widget.hotel.images.map((img) {
                  return Image.asset(
                    img,
                    height: 280,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(height: 280, color: bgColor),
                  );
                }).toList(),
              ),

              // :Container(height: 280, color: bgcolor),
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xBB000000)],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.88),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 16,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),

                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.88),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: Color(0xFFE74C3C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4BC9E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '⭐ ${widget.hotel.stars}-star · ${widget.hotel.badge}',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A3D5C),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.hotel.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'serif',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A3D5C),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                widget.hotel.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Excellent',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0A3D5C),
                                  ),
                                ),
                                Text(
                                  '${widget.hotel.reviews} reviews',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFFC4A882),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: List.generate(
                            widget.hotel.stars,
                            (_) => const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  //location
                  _Section(
                    title: '📍 Location',
                    child: GestureDetector(
                      onTap: _openMap,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F4F8),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFB8E4EE),
                            width: 0.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 54,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E9BB5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.map_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.hotel.location,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0A3D5C),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  const Text(
                                    'Tap to open in Google Maps',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF1A6B8A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF2E9B5),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _Section(
                    title: '🏖️ Top amenities',
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 3.5,
                      children: const [
                        _AmenityChip(icon: '🏊', label: 'Outdoor pool'),
                        _AmenityChip(icon: '🍽️', label: '9 restaurants'),
                        _AmenityChip(icon: '💆', label: 'Spa & wellness'),
                        _AmenityChip(icon: '📶', label: 'Free WiFi'),
                        _AmenityChip(icon: '🅿️', label: 'Private parking'),
                        _AmenityChip(icon: '🌊', label: 'Private beach'),
                      ],
                    ),
                  ),

                  _Section(
                    title: 'About the hotel',
                    child: Text(
                      'Iconic resort featuring world-class amenities, stunning views, and award-winning restaurants. Perfect for families and couples seeking luxury.',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF888888),
                        height: 1.7,
                      ),
                    ),
                  ),

                  _Section(
                    title: '✨ Property highlights',
                    child: Column(
                      children: const [
                        _HighlightItem(
                          icon: '📍',
                          title: 'Top location',
                          sub: 'Rated 9.2 by recent guests',
                        ),
                        SizedBox(height: 6),
                        _HighlightItem(
                          icon: '🍳',
                          title: 'Breakfast included',
                          sub: 'Continental, Halal, Vegan options',
                        ),
                        SizedBox(height: 6),
                        _HighlightItem(
                          icon: '🔁',
                          title: 'Loyal customers',
                          sub: 'More repeat guests than most properties',
                        ),
                      ],
                    ),
                  ),

                  //bookbar
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
                    color: const Color(0xFFF7F6F2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Starting from',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFC4A882),
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '\$${widget.hotel.pricePerNight.toInt()}',
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0A3D5C),
                                ),
                              ),
                              const TextSpan(
                                text: ' /night',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFC4A882),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookingDetailsScreen(
                                
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A3D5C),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Center(
                              child: Text(
                                'Book now',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0A3D5C),
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String icon;
  final String label;
  const _AmenityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F6F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8D8C4), width: 0.5),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 13)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF444444),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightItem extends StatelessWidget {
  final String icon;
  final String title;
  final String sub;
  const _HighlightItem({
    required this.icon,
    required this.title,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0A3D5C),
                ),
              ),
              Text(
                sub,
                style: const TextStyle(fontSize: 12, color: Color(0xFF1A6B8A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
