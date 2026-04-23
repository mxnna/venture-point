# VenturePoint - Architecture & Widgets Guide

## 📋 Project Overview

VenturePoint is an all-in-one travel app combining features from Airbnb, TripAdvisor, Booking, Skyscanner, and Been. It provides users with a comprehensive platform for discovering destinations, booking hotels and flights, tracking trips, and managing travel experiences.

## 🏗️ Architecture

VenturePoint follows **Clean Architecture** with four main layers:

```
lib/
├── core/              # Business logic, constants, theme, errors, routes
├── data/              # Data layer (APIs, repositories, models)
├── domain/            # Domain layer (entities, use cases)
└── presentation/      # Presentation layer (UI, pages, widgets, BLoC)
```

### Layer Responsibilities

#### 1. **Core Layer** (`lib/core/`)
- **Theme**: Centralized theming system
  - `app_colors.dart`: Color definitions and schemes
  - `app_text_styles.dart`: Typography standards
  - `app_theme.dart`: Complete ThemeData configuration
- **Constants**: App-wide constants and configuration
- **Errors**: Custom exception and error handling
- **Routes**: Navigation route definitions

#### 2. **Data Layer** (`lib/data/`)
- Handles data operations (API calls, local storage)
- Models and DTOs
- Repositories that implement domain contracts
- Data sources (remote, local)

#### 3. **Domain Layer** (`lib/domain/`)
- Business logic and use cases
- Entities (core business objects)
- Repository interfaces
- Independent of frameworks

#### 4. **Presentation Layer** (`lib/presentation/`)
- User interface components
- Pages (full screens)
- Widgets (reusable UI components)
- BLoC for state management

## 🎨 Reusable Widgets

### Core Widgets (`lib/presentation/widgets/`)

#### 1. **AppHeader**
Logo, app name, notification bell, and profile icons at the top of screens.

```dart
AppHeader(
  logoPath: 'assets/images/logo.png',
  appName: 'Venture Point',
  onNotificationTap: () { /* Handle notification */ },
  onProfileTap: () { /* Navigate to profile */ },
)
```

#### 2. **SearchBarWidget**
Reusable search input with filter button and customizable hint text.

```dart
SearchBarWidget(
  hintText: 'Search destinations, hotels, flights...',
  onChanged: (value) { /* Handle search */ },
  onFilterTap: () { /* Show filters */ },
)
```

#### 3. **QuickActionButtons**
Grid of circular action buttons with icons and labels.

```dart
QuickActionButtons(
  buttons: [
    QuickActionButton(
      label: 'Discover',
      icon: Icons.explore,
      onPressed: () { /* Navigate */ },
    ),
    // More buttons...
  ],
)
```

#### 4. **CategoryChip**
Filterable chip component for categories and tags.

#### 5. **Card Widgets**
- `HotelCard`: Hotel listing with image, price, rating
- `FlightCard`: Flight information with departure/arrival
- `DestinationCard`: Destination overview
- `EventCard`: Event/experience listing
- `ExperienceCard`: Activity/experience details

## 📱 Pages Structure

### Authentication Pages (`presentation/pages/auth/`)
- Login UI
- Sign Up UI
- Forgot Password UI
- Supports: Email, Google, Phone (Firebase)

### Main Pages
- **HomePage**: Dashboard with search and quick actions
- **HotelUI**: Hotel listing and search
- **FlightUI**: Flight booking interface
- **ProfileUI**: User profile and settings
- **SavedItemsUI**: Bookmarked destinations/deals
- **TripsUI**: Booked trips and itineraries
- **DestinationDetailsUI**: Country/city information
- **ExperiencesEventsUI**: Activities and events

## 🎯 Design System

### Colors
```dart
AppColors.primary           // Primary coral/salmon (#EA8A7E)
AppColors.secondary         // Background beige (#F6F5F1)
AppColors.textPrimary       // Dark brown (#2E2B28)
AppColors.textSecondary     // Light gray (#9C9996)
```

### Typography
All fonts are **bold** by default for consistency.

```dart
AppTextStyles.displayLarge    // 32px, bold
AppTextStyles.headingLarge    // 20px, bold
AppTextStyles.bodyLarge       // 16px, semibold
AppTextStyles.labelLarge      // 14px, bold with letter spacing
```

### Spacing & Sizing
- Padding: 24px (standard)
- Spacing: 12px, 16px, 24px, 32px
- Border Radius: 12px (standard), 16px (cards), 20px (large)
- Button Size: 56px height, 72px circle buttons

## 🔄 State Management

Pages use **BLoC** for state management (bloc/):
- Separates business logic from UI
- Reactive data streams
- Testable and scalable

## 🛠️ Development Guidelines

### Creating New Pages
1. Create folder under `presentation/pages/{feature_name}/`
2. Create `{feature_name}_page.dart`
3. Define route in `routes.dart`
4. Add to `main.dart` routes

### Creating New Widgets
1. Create `{widget_name}.dart` under `presentation/widgets/`
2. Use reusable components from the core widgets
3. Accept theming props for consistency
4. Document with example usage

### Styling Best Practices
- Always use `AppColors` and `AppTextStyles` from core theme
- Use `Theme.of(context)` for inherited theming
- Maintain consistent spacing and sizing
- Use Material Design 3 components

### Navigation
- Use named routes for all navigation
- Define routes in `lib/core/routes/routes.dart`
- Pass data through route arguments when needed

## 📦 Dependencies

- **flutter_bloc**: State management
- **firebase_auth**: Authentication
- **firebase_core**: Firebase setup
- **cloud_firestore**: Database
- **google_fonts**: Typography
- **sqflite_android**: Local storage
- **http** or **dio**: API calls

## 🚀 Performance Optimization

- Use `const` constructors where possible
- Implement `shouldRebuild` in BLoC providers
- Lazy load images and data
- Use responsive design for different screen sizes

## 📝 Naming Conventions

- Pages: `{feature}_page.dart` (e.g., `home_page.dart`)
- Widgets: `{widget_name}.dart` (e.g., `search_bar.dart`)
- BLoC: `{feature}_bloc.dart` (e.g., `auth_bloc.dart`)
- Models: `{entity}_model.dart`
- Routes: Use PascalCase (e.g., `HomePage.routeName`)

## 🎨 Responsive Design

All widgets are built to be responsive:
- Mobile-first approach
- Adapts to tablet/desktop screens
- Use `MediaQuery` for responsive layouts
- Test on multiple device sizes

---

For questions or updates to this guide, refer to the main README.md.
