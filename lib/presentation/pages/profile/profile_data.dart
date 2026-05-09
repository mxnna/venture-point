class CountryInfo {
  final String code;
  final String name;
  final String continent;
  final String flag;

  const CountryInfo({
    required this.code,
    required this.name,
    required this.continent,
    required this.flag,
  });
}

class CityInfo {
  final String id;
  final String name;
  final String countryCode;
  final String countryName;
  final String flag;
  final String imageUrl;

  const CityInfo({
    required this.id,
    required this.name,
    required this.countryCode,
    required this.countryName,
    required this.flag,
    required this.imageUrl,
  });
}

const Map<String, int> continentTotals = {
  'Europe': 44,
  'Asia': 49,
  'Africa': 54,
  'North America': 23,
  'South America': 12,
  'Australia': 14,
};

const List<CountryInfo> allCountries = [
  CountryInfo(code: 'EG', name: 'Egypt', continent: 'Africa', flag: '🇪🇬'),
  CountryInfo(code: 'IT', name: 'Italy', continent: 'Europe', flag: '🇮🇹'),
  CountryInfo(code: 'JP', name: 'Japan', continent: 'Asia', flag: '🇯🇵'),
  CountryInfo(code: 'FR', name: 'France', continent: 'Europe', flag: '🇫🇷'),
  CountryInfo(code: 'AE', name: 'UAE', continent: 'Asia', flag: '🇦🇪'),
  CountryInfo(
    code: 'US',
    name: 'United States',
    continent: 'North America',
    flag: '🇺🇸',
  ),
  CountryInfo(
    code: 'GB',
    name: 'United Kingdom',
    continent: 'Europe',
    flag: '🇬🇧',
  ),
  CountryInfo(
    code: 'CA',
    name: 'Canada',
    continent: 'North America',
    flag: '🇨🇦',
  ),
  CountryInfo(
    code: 'AU',
    name: 'Australia',
    continent: 'Australia',
    flag: '🇦🇺',
  ),
  CountryInfo(
    code: 'BR',
    name: 'Brazil',
    continent: 'South America',
    flag: '🇧🇷',
  ),
  CountryInfo(
    code: 'ZA',
    name: 'South Africa',
    continent: 'Africa',
    flag: '🇿🇦',
  ),
  CountryInfo(
    code: 'MX',
    name: 'Mexico',
    continent: 'North America',
    flag: '🇲🇽',
  ),
  CountryInfo(code: 'IN', name: 'India', continent: 'Asia', flag: '🇮🇳'),
  CountryInfo(code: 'CN', name: 'China', continent: 'Asia', flag: '🇨🇳'),
  CountryInfo(code: 'DE', name: 'Germany', continent: 'Europe', flag: '🇩🇪'),
  CountryInfo(code: 'ES', name: 'Spain', continent: 'Europe', flag: '🇪🇸'),
  CountryInfo(code: 'TH', name: 'Thailand', continent: 'Asia', flag: '🇹🇭'),
  CountryInfo(
    code: 'NZ',
    name: 'New Zealand',
    continent: 'Australia',
    flag: '🇳🇿',
  ),
  CountryInfo(
    code: 'AR',
    name: 'Argentina',
    continent: 'South America',
    flag: '🇦🇷',
  ),
  CountryInfo(code: 'KE', name: 'Kenya', continent: 'Africa', flag: '🇰🇪'),
  CountryInfo(code: 'NO', name: 'Norway', continent: 'Europe', flag: '🇳🇴'),
  CountryInfo(code: 'KR', name: 'South Korea', continent: 'Asia', flag: '🇰🇷'),
  CountryInfo(
    code: 'CL',
    name: 'Chile',
    continent: 'South America',
    flag: '🇨🇱',
  ),
  CountryInfo(code: 'PT', name: 'Portugal', continent: 'Europe', flag: '🇵🇹'),
  CountryInfo(
    code: 'SA',
    name: 'Saudi Arabia',
    continent: 'Asia',
    flag: '🇸🇦',
  ),
  CountryInfo(code: 'NG', name: 'Nigeria', continent: 'Africa', flag: '🇳🇬'),
];

final Map<String, CountryInfo> countryByCode = {
  for (final country in allCountries) country.code: country,
};

final Map<String, CountryInfo> countryByName = {
  for (final country in allCountries) country.name.toLowerCase(): country,
};

const List<CityInfo> allCities = [
  CityInfo(
    id: 'paris',
    name: 'Paris',
    countryCode: 'FR',
    countryName: 'France',
    flag: '🇫🇷',
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1661919210043-fd847a58522d?q=80&w=1471&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'dubai',
    name: 'Dubai',
    countryCode: 'AE',
    countryName: 'UAE',
    flag: '🇦🇪',
    imageUrl:
        'https://images.unsplash.com/photo-1688671525781-d9447cf1abd2?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'cairo',
    name: 'Cairo',
    countryCode: 'EG',
    countryName: 'Egypt',
    flag: '🇪🇬',
    imageUrl:
        'https://images.unsplash.com/photo-1677775766807-ff09c770da6e?q=80&w=2069&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'tokyo',
    name: 'Tokyo',
    countryCode: 'JP',
    countryName: 'Japan',
    flag: '🇯🇵',
    imageUrl:
        'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?q=80&w=2072&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'new_york',
    name: 'New York',
    countryCode: 'US',
    countryName: 'United States',
    flag: '🇺🇸',
    imageUrl:
        'https://plus.unsplash.com/premium_photo-1697729767514-8094e6af5f0b?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'london',
    name: 'London',
    countryCode: 'GB',
    countryName: 'United Kingdom',
    flag: '🇬🇧',
    imageUrl:
        'https://images.unsplash.com/photo-1673719712612-8c1f78e53fec?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'sydney',
    name: 'Sydney',
    countryCode: 'AU',
    countryName: 'Australia',
    flag: '🇦🇺',
    imageUrl:
        'https://images.unsplash.com/photo-1506973035872-a4ec16b8e8d9?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'rio',
    name: 'Rio',
    countryCode: 'BR',
    countryName: 'Brazil',
    flag: '🇧🇷',
    imageUrl:
        'https://images.unsplash.com/photo-1483729558449-99ef09a8c325?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'kyoto',
    name: 'Kyoto',
    countryCode: 'JP',
    countryName: 'Japan',
    flag: '🇯🇵',
    imageUrl:
        'https://images.unsplash.com/photo-1771308355434-863f38323d6f?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
  CityInfo(
    id: 'cape_town',
    name: 'Cape Town',
    countryCode: 'ZA',
    countryName: 'South Africa',
    flag: '🇿🇦',
    imageUrl:
        'https://images.unsplash.com/photo-1595708323549-85635381d0d1?q=80&w=1633&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ),
];

final Map<String, CityInfo> cityById = {
  for (final city in allCities) city.id: city,
};

final Map<String, CityInfo> cityByName = {
  for (final city in allCities) city.name.toLowerCase(): city,
};

CountryInfo? countryInfoFromName(String name) {
  return countryByName[name.toLowerCase()];
}

CityInfo? cityInfoFromName(String name) {
  return cityByName[name.toLowerCase()];
}
