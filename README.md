# Caloriq

Caloriq is an intelligent, data-driven calorie and macronutrient tracking application built with Flutter, focused on clean UX, Material 3 design principles, and precise nutrition analytics.

---

## Key Highlights

- **Smart Calorie Budgeting & Dynamic TDEE**: Automated Mifflin-St Jeor BMR calculation with activity multipliers, goal-adaptive deficits (Mild, Moderate, Intense, Extreme), and health protocol safety floors.
- **Real-Time Macronutrient Breakdown**: Live tracking of Protein, Carbohydrates, and Fats with visual micro progress indicators and goal-based macro allocations.
- **Interactive Hydration Tracker**: One-tap quick water logging (+250 ml) with tactile haptic feedback and target hydration progress.
- **Daily Weigh-In & Weight Trend**: Fast daily weight logging with interactive modal sliders, BMI categorization, and target milestone metrics.
- **Today's Meals Timeline**: Comprehensive overview of daily consumption across Breakfast, Lunch, Snacks, and Dinner with instant logging shortcuts.
- **Intelligent Meal Recommendations**: Time-aware meal recommendations offering calorie and macro-balanced food suggestions.
- **Custom Curved Floating Dock Navigation**: Custom-painted cubic bezier scooped floating island navigation bar with smooth spring physics and interactive neon flare animations.
- **Dynamic Light & Dark Theme**: Mathematically tuned theme engine featuring the vector Q logo with adaptive high-contrast palettes.

---

## Architecture & Tech Stack

- **Framework**: Flutter (Dart 3.x)
- **Design System**: Plus Jakarta Sans typography, custom Bento grid cards, soft radii (28px cards, 99px pills)
- **State Management**: Provider architecture (`UserProfileProvider`, `MealLogProvider`, `ThemeProvider`, `AuthProvider`)
- **Graphics & Vectors**: Pure `CustomPainter` vector renderers for lossless Q Logo and curved scooped dock navigation
- **Data Persistence**: `shared_preferences` with automatic midnight date roll-over and JSON state serialization
- **Authentication & Backend**: Firebase Core & Firebase Auth integration

---

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.5.0)
- Android Studio / VS Code with Flutter extension
- JDK 17+ or JDK 25 with Gradle 9.1+

### Installation & Run

```bash
# 1. Clone the repository
git clone https://github.com/shaddhow/Caloriq.git

# 2. Navigate to project root
cd Caloriq

# 3. Get dependencies
flutter pub get

# 4. Run on connected device or emulator
flutter run
```

---

## Platforms Supported

- Android (API 23+)
- iOS (iOS 12+)
- Web & Windows Desktop

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.
