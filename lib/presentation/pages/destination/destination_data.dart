import 'package:flutter/material.dart';

class DestinationCategory {
  final String label;
  final IconData icon;
  final List<Color> iconGradientColors;
  final Color cardColor;
  final Color labelColor;

  const DestinationCategory({
    required this.label,
    required this.icon,
    required this.iconGradientColors,
    required this.cardColor,
    required this.labelColor,
  });
}

class ExperienceDestination {
  final String title;
  final String subtitle;
  final String image;
  final double rating;
  final String location;

  const ExperienceDestination({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.rating,
    this.location = '',
  });
}

class DestinationEvent {
  final String title;
  final String dateRange;
  final String location;
  final String category;
  final String image;

  const DestinationEvent({
    required this.title,
    required this.dateRange,
    required this.location,
    required this.category,
    this.image = '',
  });
}

class QuickFact {
  final String label;
  final String value;
  final IconData icon;

  const QuickFact({
    required this.label,
    required this.value,
    required this.icon,
  });
}

class TravelGuideFact {
  final String label;
  final String description;
  final IconData icon;

  const TravelGuideFact({
    required this.label,
    required this.description,
    required this.icon,
  });
}

class CityData {
  final String name;
  final String country;
  final String image;
  final double rating;
  final String description;
  final List<ExperienceDestination> experiences;
  final List<DestinationEvent> events;

  const CityData({
    required this.name,
    required this.country,
    required this.image,
    required this.rating,
    required this.description,
    required this.experiences,
    required this.events,
  });
}

class CountryData {
  final String name;
  final String flag;
  final String region;
  final double rating;
  final String description;
  final String image;
  final int cityCount;
  final List<CityData> topCities;
  final List<QuickFact> quickFacts;
  final List<TravelGuideFact> travelGuide;

  const CountryData({
    required this.name,
    required this.flag,
    required this.region,
    required this.rating,
    required this.description,
    required this.image,
    required this.cityCount,
    required this.topCities,
    required this.quickFacts,
    required this.travelGuide,
  });
}

const destinationCategories = <DestinationCategory>[
  DestinationCategory(
    label: 'Ancient',
    icon: Icons.temple_hindu,
    iconGradientColors: [Color(0xFFB8860B), Color(0xFFD2B48C)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Beaches',
    icon: Icons.beach_access,
    iconGradientColors: [Color(0xFF20B2AA), Color(0xFF5F9EA0)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Cruises',
    icon: Icons.sailing,
    iconGradientColors: [Color(0xFF4682B4), Color(0xFF5F9EA0)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Wildlife',
    icon: Icons.emoji_nature,
    iconGradientColors: [Color(0xFFCD5C5C), Color(0xFFFFA07A)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Events',
    icon: Icons.event,
    iconGradientColors: [Color(0xFF4169E1), Color(0xFF6495ED)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Deserts',
    icon: Icons.landscape,
    iconGradientColors: [Color(0xFFD2B48C), Color(0xFFDEB887)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Spiritual',
    icon: Icons.self_improvement,
    iconGradientColors: [Color(0xFF9370DB), Color(0xFFBA55D3)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Nature',
    icon: Icons.forest,
    iconGradientColors: [Color(0xFF6B8E23), Color(0xFF9ACD32)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Museums',
    icon: Icons.account_balance,
    iconGradientColors: [Color(0xFF4682B4), Color(0xFF87CEEB)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Adventure',
    icon: Icons.hiking,
    iconGradientColors: [Color(0xFFFF8C00), Color(0xFFFFB347)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Sports',
    icon: Icons.fitness_center,
    iconGradientColors: [Color(0xFF228B22), Color(0xFF32CD32)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
  DestinationCategory(
    label: 'Dining',
    icon: Icons.local_dining,
    iconGradientColors: [Color(0xFFA0522D), Color(0xFFD2691E)],
    cardColor: Color(0xFFF6F6F6),
    labelColor: Color(0xFF181818),
  ),
];

final topCities = <CityData>[
  const CityData(
    name: 'Cairo',
    country: 'Egypt',
    image:
        'https://www.aucegypt.edu/sites/default/files/styles/large_widget/public/2019-01/shutterstock_753279475-cairo_nile_skyline-2000px.jpg?itok=89O04hX5',
    rating: 4.7,
    description:
        'Cairo is a vibrant city where ancient history meets modern life. Explore the Pyramids, museums, and lively souks.',
    experiences: [
      ExperienceDestination(
        title: 'Pyramids of Giza',
        subtitle: 'Ancient wonder & guided tour',
        image:
            'https://images.unsplash.com/photo-1718403800110-bd008d361517?q=80&w=1473&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.9,
      ),
      ExperienceDestination(
        title: 'Egyptian Museum',
        subtitle: 'Pharaohs, artifacts, history',
        image:
            'https://yatrusfoundation.eu/wp-content/uploads/2025/11/1761653888-BeFunky-collage_77.webp',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Nile Dinner Cruise',
        subtitle: 'Evening on the river with views',
        image:
            'https://dnzyghjhtzcpnbqmfcrs.supabase.co/storage/v1/object/public/tours/public/1777821968913-5700d0d7-b3df-472f-a799-7d9e777bb3f3.jpg',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Ski Egypt 4x4 Snow Challenge',
        dateRange: '25 Jan 2025 · 9:00 AM',
        location: 'Snow Park',
        category: 'Sports',
        image:
            'https://d3vzzcunewy153.cloudfront.net/img/17f95c00-4ab0-492d-94a6-3a647e5ea2fe/75f6ba1effbd9f7087f0f3ab4378af58.png',
      ),
      DestinationEvent(
        title: 'Cairo International Book Fair',
        dateRange: '24 Jan – 6 Feb 2025',
        location: 'Egypt International Exhibition Center',
        category: 'Exhibition',
        image:
            'https://sih.shj.ae/storage/post/78hRIjfiGYefC5uNGsFkTxRQlR6lpjEsR6FBnb3K.jpg',
      ),
      DestinationEvent(
        title: 'ASEEL Egyptian Horse Festival',
        dateRange: '7 Nov – 11 Nov 2025',
        location: 'New Cairo Equestrian Club',
        category: 'Festival',
        image:
            'https://d3vzzcunewy153.cloudfront.net/img/17f95c00-4ab0-492d-94a6-3a647e5ea2fe/4d570526445370230a9c20fc58b3737a.jpg',
      ),
      DestinationEvent(
        title: 'Omar Khairat Live with Baheya',
        dateRange: '14 Dec 2025 · 8:00 PM',
        location: 'Cairo Opera House',
        category: 'Concert',
        image:
            'https://d3vzzcunewy153.cloudfront.net/img/17f95c00-4ab0-492d-94a6-3a647e5ea2fe/87a2aa68a822d7f62d6570f410bcddf0.png',
      ),
    ],
  ),
  const CityData(
    name: 'Kyoto',
    country: 'Japan',
    image:
        'https://images.unsplash.com/photo-1771308355434-863f38323d6f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.7,
    description:
        'Kyoto is a serene cultural city, known for temples, gardens, and traditional tea houses.',
    experiences: [
      ExperienceDestination(
        title: 'Fushimi Inari Shrine',
        subtitle: 'Iconic torii gate path',
        image:
            'https://images.unsplash.com/photo-1709822663068-d74b32e646c5?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.9,
      ),
      ExperienceDestination(
        title: 'Arashiyama Bamboo Grove',
        subtitle: 'Peaceful forest walk',
        image:
            'https://images.unsplash.com/photo-1632923754832-60642c12a7ed?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Gion Matsuri Festival',
        dateRange: '1 Jul – 31 Jul 2025',
        location: 'Gion District',
        category: 'Festival',
      ),
    ],
  ),
  const CityData(
    name: 'Luxor',
    country: 'Egypt',
    image:
        'https://plus.unsplash.com/premium_photo-1661963854938-e69a4e65c1e3?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.6,
    description:
        'Luxor offers open-air museums, temples, and a timeless glimpse into ancient Egyptian life.',
    experiences: [
      ExperienceDestination(
        title: 'Valley of the Kings',
        subtitle: 'Royal tombs & hieroglyphs',
        image:
            'https://plus.unsplash.com/premium_photo-1661963854938-e69a4e65c1e3?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Karnak Temple',
        subtitle: 'Sacred columns and carvings',
        image:
            'https://images.unsplash.com/photo-1632944398987-494eebe663be?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Ancient Egypt Arts Festival',
        dateRange: '10 Jun – 16 Jun 2025',
        location: 'Luxor Temple Grounds',
        category: 'Festival',
      ),
    ],
  ),
  const CityData(
    name: 'Alexandria',
    country: 'Egypt',
    image:
        'https://www.egypttoursplus.com/wp-content/uploads/2025/07/People-visit-Citadel-of-Qaitbay-Fort-of-Qaitbey-in-Alexandria-Egypt.webp',
    rating: 4.5,
    description:
        'Alexandria blends Mediterranean charm, coastal promenades, and historic landmarks.',
    experiences: [
      ExperienceDestination(
        title: 'Citadel of Qaitbay',
        subtitle: 'Fortress by the sea',
        image:
            'https://images.unsplash.com/photo-1610131042652-42d6f3754c51?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.6,
      ),
      ExperienceDestination(
        title: 'Bibliotheca Alexandrina',
        subtitle: 'Modern library & galleries',
        image:
            'https://unsplash.com/photos/a-large-white-building-with-a-fence-and-trees-in-front-of-it-RpyeTn5xYHc',
        rating: 4.5,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Mediterranean Food Market',
        dateRange: '12 Jul – 14 Jul 2025',
        location: 'Corniche Market',
        category: 'Workshop',
      ),
    ],
  ),
  const CityData(
    name: 'Paris',
    country: 'France',
    image:
        'https://plus.unsplash.com/premium_photo-1661919210043-fd847a58522d?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.8,
    description:
        'Paris is the city of light, art, fashion, and world-famous cuisine.',
    experiences: [
      ExperienceDestination(
        title: 'Eiffel Tower Visit',
        subtitle: 'Iconic landmark with city views',
        image:
            'https://plus.unsplash.com/premium_photo-1694475226507-568fd86cadfe?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.9,
      ),
      ExperienceDestination(
        title: 'Louvre Museum',
        subtitle: 'Masterpieces and historical art',
        image:
            'https://images.unsplash.com/photo-1743880475189-e36f80868bcc?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Paris Fashion Week',
        dateRange: '25 Sep – 3 Oct 2025',
        location: 'Various venues across Paris',
        category: 'Fashion',
      ),
    ],
  ),
  const CityData(
    name: 'Dubai',
    country: 'UAE',
    image:
        'https://images.unsplash.com/photo-1688671525781-d9447cf1abd2?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.7,
    description:
        'Dubai blends futuristic architecture with desert adventure and luxury experiences.',
    experiences: [
      ExperienceDestination(
        title: 'Burj Khalifa',
        subtitle: 'Tallest building in the world',
        image:
            'https://images.unsplash.com/photo-1583759604327-f9dcd23499d5?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.9,
      ),
      ExperienceDestination(
        title: 'Desert Safari',
        subtitle: 'Dune riding and sunset views',
        image:
            'https://images.unsplash.com/photo-1612899326681-66508905b4ce?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Dubai Shopping Festival',
        dateRange: '26 Dec 2025 – 27 Jan 2026',
        location: 'Downtown Dubai',
        category: 'Festival',
      ),
    ],
  ),
  const CityData(
    name: 'New York',
    country: 'United States',
    image:
        'https://plus.unsplash.com/premium_photo-1697729767514-8094e6af5f0b?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.8,
    description:
        'New York is a fast-paced city known for Broadway, skyline views, and cultural diversity.',
    experiences: [
      ExperienceDestination(
        title: 'Central Park Stroll',
        subtitle: 'Green escape in the city',
        image:
            'https://images.unsplash.com/photo-1631729779674-1f369e1116b4?q=80&w=1412&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Times Square',
        subtitle: 'Iconic lights and city energy',
        image:
            'https://images.unsplash.com/photo-1585238326164-612cb4248873?q=80&w=1486&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'New Year’s Eve in Times Square',
        dateRange: '31 Dec 2025',
        location: 'Times Square',
        category: 'Celebration',
      ),
    ],
  ),
  const CityData(
    name: 'London',
    country: 'United Kingdom',
    image:
        'https://images.unsplash.com/photo-1673719712612-8c1f78e53fec?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.7,
    description:
        'London offers royal landmarks, historic neighborhoods, and world-class museums.',
    experiences: [
      ExperienceDestination(
        title: 'Westminster Abbey',
        subtitle: 'Historic royal church',
        image:
            'https://images.unsplash.com/photo-1730204624150-41e6d06c54db?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Thames River Cruise',
        subtitle: 'City views from the water',
        image:
            'https://plus.unsplash.com/premium_photo-1671734045354-12292766e1b5?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'London Fashion Week',
        dateRange: '14 Feb – 18 Feb 2025',
        location: 'Various venues across London',
        category: 'Fashion',
      ),
    ],
  ),
  const CityData(
    name: 'Sydney',
    country: 'Australia',
    image:
        'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.6,
    description:
        'Sydney is celebrated for its Opera House, harbor walks, and beautiful beaches.',
    experiences: [
      ExperienceDestination(
        title: 'Opera House Tour',
        subtitle: 'Architecture and performances',
        image:
            'https://images.unsplash.com/photo-1751768542557-82d9ffd64307?q=80&w=1475&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Bondi Beach',
        subtitle: 'Surf, sand, and seaside cafes',
        image:
            'https://images.unsplash.com/photo-1555029941-a475f4e50810?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Sydney New Year’s Eve',
        dateRange: '31 Dec 2025',
        location: 'Sydney Harbour',
        category: 'Celebration',
      ),
    ],
  ),
  const CityData(
    name: 'Rio',
    country: 'Brazil',
    image:
        'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.6,
    description:
        'Rio de Janeiro is famous for its beaches, carnival culture, and Sugarloaf Mountain.',
    experiences: [
      ExperienceDestination(
        title: 'Christ the Redeemer',
        subtitle: 'Panoramic city views',
        image:
            'https://images.unsplash.com/photo-1693497159317-4c2107c5aeee?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.9,
      ),
      ExperienceDestination(
        title: 'Copacabana Beach',
        subtitle: 'Sun, sand, and lively boardwalk',
        image:
            'https://plus.unsplash.com/premium_photo-1694475416337-6e68c11d7797?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Rio Carnival',
        dateRange: '13 Feb – 18 Feb 2025',
        location: 'Sambadrome',
        category: 'Festival',
      ),
    ],
  ),
  const CityData(
    name: 'Cape Town',
    country: 'South Africa',
    image:
        'https://images.unsplash.com/photo-1595708323549-85635381d0d1?q=80&w=1633&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.6,
    description:
        'Cape Town offers dramatic coastlines, Table Mountain, and a rich cultural scene.',
    experiences: [
      ExperienceDestination(
        title: 'Table Mountain',
        subtitle: 'Cable car views over the city',
        image:
            'https://images.unsplash.com/photo-1606799955515-85468ee78c26?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.8,
      ),
      ExperienceDestination(
        title: 'Robben Island Tour',
        subtitle: 'Historic and powerful journey',
        image:
            'https://images.unsplash.com/photo-1751685271342-e60a349ab642?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        rating: 4.7,
      ),
    ],
    events: [
      DestinationEvent(
        title: 'Cape Town Jazz Festival',
        dateRange: '29 Mar – 30 Mar 2025',
        location: 'Cape Town International Convention Centre',
        category: 'Music',
      ),
    ],
  ),
];

final topCountries = <CountryData>[
  CountryData(
    name: 'Egypt',
    flag: '🇪🇬',
    region: 'Africa',
    rating: 4.6,
    description:
        'Egypt is a country that connects Northeast Africa with the Middle East. It is known for its ancient history, iconic landmarks, and rich culture.',
    image:
        'https://images.unsplash.com/photo-1574864745093-5566c5be5855?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 27,
    topCities: [topCities[0], topCities[2], topCities[3]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +2', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'Arabic', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'EGP', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Oct – Apr',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'Japan',
    flag: '🇯🇵',
    region: 'Asia',
    rating: 4.9,
    description:
        'Japan blends ancient temples, vibrant cities, and nature into a seamless travel experience.',
    image:
        'https://images.unsplash.com/photo-1717226263737-f314f752dc61?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 23,
    topCities: [topCities[1]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +9', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'Japanese', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'JPY', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Mar – May',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'Italy',
    flag: '🇮🇹',
    region: 'Europe',
    rating: 4.8,
    description:
        'Italy offers world-class art, food, coastlines, and cities filled with history and modern style.',
    image:
        'https://plus.unsplash.com/premium_photo-1675975678457-d70708bf77c8?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 20,
    topCities: [],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +1', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'Italian', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'EUR', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Apr – Jun',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'France',
    flag: '🇫🇷',
    region: 'Europe',
    rating: 4.7,
    description:
        'France is famous for its culture, cuisine, architecture, and unforgettable cities like Paris.',
    image:
        'https://images.unsplash.com/photo-1652117524850-33f12e2444b2?q=80&w=1632&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 25,
    topCities: [topCities[4]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +1', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'French', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'EUR', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'May – Sep',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'UAE',
    flag: '🇦🇪',
    region: 'Asia',
    rating: 4.7,
    description:
        'UAE is known for luxury shopping, modern skylines, and vibrant desert escapes.',
    image:
        'https://plus.unsplash.com/premium_photo-1661916762370-4768aa1fc4c4?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 7,
    topCities: [topCities[5]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +4', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'Arabic', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'AED', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Oct – Apr',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'United States',
    flag: '🇺🇸',
    region: 'North America',
    rating: 4.8,
    description:
        'The United States features iconic cities, national parks, and diverse cultural scenes.',
    image:
        'https://images.unsplash.com/photo-1615633134784-2a88832815d1?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 45,
    topCities: [topCities[6]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT -5', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'English', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'USD', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Sep – Nov',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'United Kingdom',
    flag: '🇬🇧',
    region: 'Europe',
    rating: 4.7,
    description:
        'United Kingdom mixes royal tradition, historic landmarks, and metropolitan culture.',
    image:
        'https://images.unsplash.com/photo-1532219362275-a1cbe9dc3602?q=80&w=2076&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 14,
    topCities: [topCities[7]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +0', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'English', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'GBP', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'May – Sep',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'Australia',
    flag: '🇦🇺',
    region: 'Australia',
    rating: 4.6,
    description:
        'Australia is home to coastal cities, natural wonders, and outdoor adventure.',
    image:
        'https://images.unsplash.com/photo-1689834678768-5de6a55b68b7?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 15,
    topCities: [topCities[8]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +10', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'English', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'AUD', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Sep – Nov',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'Brazil',
    flag: '🇧🇷',
    region: 'South America',
    rating: 4.6,
    description:
        'Brazil is famous for lively beaches, vibrant festivals, and tropical scenery.',
    image:
        'https://images.unsplash.com/photo-1518639192441-8fce0a366e2e?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 20,
    topCities: [topCities[9]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT -3', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'Portuguese', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'BRL', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Dec – Mar',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
  CountryData(
    name: 'South Africa',
    flag: '🇿🇦',
    region: 'Africa',
    rating: 4.6,
    description:
        'South Africa offers coastal beauty, wildlife safaris, and historic cities.',
    image:
        'https://images.unsplash.com/photo-1673889806169-a5aee733374f?q=80&w=1480&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    cityCount: 10,
    topCities: [topCities[10]],
    quickFacts: [
      QuickFact(label: 'Time zone', value: 'GMT +2', icon: Icons.schedule),
      QuickFact(label: 'Language', value: 'English', icon: Icons.language),
      QuickFact(label: 'Currency', value: 'ZAR', icon: Icons.monetization_on),
      QuickFact(
        label: 'Best time to visit',
        value: 'Nov – Mar',
        icon: Icons.calendar_today,
      ),
    ],
    travelGuide: [
      TravelGuideFact(
        label: 'Visa & entry',
        description: 'Requirements & documents',
        icon: Icons.card_travel,
      ),
      TravelGuideFact(
        label: 'Safety',
        description: 'Health, safety & emergency',
        icon: Icons.health_and_safety,
      ),
      TravelGuideFact(
        label: 'Travel tips',
        description: 'Local etiquette & useful tips',
        icon: Icons.lightbulb,
      ),
      TravelGuideFact(
        label: 'Tour guides',
        description: 'Expert guides & book tours',
        icon: Icons.tour,
      ),
    ],
  ),
];

final topExperiences = <ExperienceDestination>[
  const ExperienceDestination(
    title: 'Snorkeling',
    subtitle: 'Underwater adventure',
    image:
        'https://img.liveaboard.com/imageserver/picture_library/site/diving/egypt/liveaboard-egypt-blueplanet-xxl.jpg?tr=w-1920,h-800,f-jpeg',
    rating: 4.9,
    location: 'Sharm al-Sheikh',
  ),
  const ExperienceDestination(
    title: 'Nile Cruise',
    subtitle: 'Relaxing river journey',
    image:
        'https://dnzyghjhtzcpnbqmfcrs.supabase.co/storage/v1/object/public/tours/public/1777821968913-5700d0d7-b3df-472f-a799-7d9e777bb3f3.jpg',
    rating: 4.8,
    location: 'Cairo – Aswan',
  ),
  const ExperienceDestination(
    title: 'Desert Safari',
    subtitle: 'Sand dunes & sunset',
    image:
        'https://ftstravels.com/wp-content/uploads/2026/03/desert-safari-egypt-sharm-el-sheikh-desert-buggy-rally-31608.jpg',
    rating: 4.7,
    location: 'White Desert',
  ),
  const ExperienceDestination(
    title: 'Pyramids of Giza',
    subtitle: 'Ancient wonder',
    image:
        'https://images.unsplash.com/photo-1718403800110-bd008d361517?q=80&w=1473&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    rating: 4.9,
    location: 'Giza',
  ),
];
