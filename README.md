# Smart India Hackathon 2025 - GoLocal App

**"Discover India's Hidden Heartbeat"** - A comprehensive Flutter application for exploring authentic local artisans, traditional food, cultural folklore, and heritage sites across India.

## 🌟 About GoLocal

GoLocal is a mobile platform that connects users with the authentic cultural heritage of India. Our app helps travelers and locals discover genuine artisans, traditional food establishments, and cultural stories, fostering meaningful connections with local communities and supporting traditional craftsmanship.

## ✨ Core Features Implemented

### 🏠 **Home Experience**
- **Multi-Tab Interface**: Seamless navigation between Feed, Search, and Map views
- **Content Discovery**: Browse curated artisans, local food shops, and folklore stories
- **Hero Section**: Engaging visual introduction with dynamic content
- **Category-based Browsing**: Organized content by type (Artisans, Food, Folklore)
- **Kala Mitra Integration**: Connect with local artisan networks

### 🔍 **Advanced Search & Discovery**
- **Real-time Search**: Instant search across all content types
- **Smart Filtering**: Filter by category, location, and preferences  
- **Search Suggestions**: Quick-tap suggestions for popular queries
- **Empty State Animations**: Beautiful pottery craftsmanship Lottie animation
- **Cross-content Search**: Search artisans, food items, and folklore simultaneously

### 🗺️ **Interactive Maps**
- **Google Maps Integration**: Full-featured map experience with custom markers
- **Location-based Content**: 22 authentic Pondicherry-focused places
- **Place Type Filtering**: Filter by Artisans (violet), Tourist Spots (green), Local Shops (yellow)
- **Pin Interactions**: Tap pins for detailed information and actions
- **Directions Integration**: Direct navigation to Google Maps for directions
- **Real-time Location**: GPS tracking with location permissions
- **Map Gestures**: Full pan, zoom, rotate, and tilt capabilities

### 👤 **User Authentication & Profiles**
- **Supabase Authentication**: Secure email-based registration and login
- **Email Verification**: Mandatory email confirmation flow
- **Profile Management**: Comprehensive user profile setup and editing
- **Profile Pictures**: Avatar support with image picker integration
- **User Preferences**: Location-based content personalization
- **Session Management**: Persistent login with secure token handling

### 💝 **Favorites & Bookings**
- **Save for Later**: Bookmark artisans, food places, and folklore
- **Favorites Management**: Organized favorites with sewing animation
- **Booking History**: Track interactions and reservations
- **Cross-device Sync**: Cloud-synchronized favorites via Supabase

### 🤖 **AI Chat Assistant - Naradha**
- **Cultural Guide**: AI-powered assistant for local cultural information
- **Contextual Help**: Location and content-aware responses
- **Natural Conversations**: Chat interface for questions and guidance
- **Floating Access**: Available from any screen via floating action button

### 🎨 **Animations & UX**
- **Lottie Animations**: 
  - Pottery craftsmanship (Search empty state)
  - Sewing animation (Favorites empty state)
  - Thank you animation (Post-signup)
  - Login/Signup animations
- **Smooth Transitions**: Gesture-disabled navigation preventing accidental swipes
- **Loading States**: Skeleton screens and progress indicators
- **Error Handling**: Graceful error states with retry mechanisms

## 🛠️ Technologies & Architecture

### **Frontend Framework**
- **Flutter 3.9.0**: Cross-platform mobile development
- **Dart**: Programming language with null safety
- **Material Design 3**: Modern UI components and theming

### **State Management**
- **Provider Pattern**: Reactive state management
- **Multiple Providers**:
  - `AuthProvider`: Authentication state
  - `UserProvider`: User profile data
  - `FavoritesProvider`: Saved content management
  - `AppStateProvider`: Global app state

### **Backend & Database**
- **Supabase**: Backend-as-a-Service
  - PostgreSQL database with Row Level Security (RLS)
  - Real-time subscriptions
  - Authentication & user management
  - File storage for images
- **Mock Data Integration**: Comprehensive fallback system for development

### **Maps & Location**
- **Google Maps Flutter**: Interactive map widget
- **Google Places API**: Place details and search
- **Geolocator**: GPS location services
- **Geocoding**: Address to coordinates conversion

### **UI/UX Libraries**
- **Lottie**: Vector animations (pottery, sewing, thank you)
- **Cached Network Image**: Optimized image loading and caching
- **Google Fonts**: Custom typography
- **Flutter SVG**: Vector graphics support

### **Development & Security**
- **Flutter Dotenv**: Environment variable management
- **Secure API Key Storage**: Environment-based configuration
- **Git Security**: .env files excluded from version control

### **External Integrations**
- **WhatsApp**: Direct artisan contact via URL schemes
- **Phone Dialer**: Call businesses directly
- **Google Maps App**: External navigation integration
- **Email Services**: SMTP integration for notifications

## 📱 App Architecture

### **Project Structure**
```
lib/
├── core/                 # Core utilities and configurations
│   ├── constants/        # App constants and environment config
│   ├── models/          # Data models (User, Artisan, Food, Folklore)
│   ├── providers/       # State management providers
│   ├── services/        # Business logic services
│   ├── theme/           # App theming and colors
│   └── utils/           # Utility functions
├── features/            # Feature-based modules
│   ├── auth/            # Authentication flows
│   ├── home/            # Main app experience
│   ├── profile/         # User profile management
│   ├── chat/            # AI assistant chat
│   └── artisan/         # Artisan detail views
└── shared/              # Shared components
    ├── models/          # Shared data models
    ├── services/        # Shared services (Maps, etc.)
    └── widgets/         # Reusable UI components
```

### **Data Flow**
1. **Environment Setup**: Load API keys from .env file
2. **Authentication**: Supabase auth with email verification
3. **Data Loading**: Mock data fallback for development
4. **State Management**: Provider pattern for reactive UI
5. **Location Services**: Real-time GPS with permission handling
6. **External Actions**: Deep links to WhatsApp, Phone, Maps

## 🚀 Getting Started

### **Prerequisites**
- Flutter SDK 3.9.0 or higher
- Android Studio / VS Code
- Git for version control

### **Installation**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Teja-Nalukurthi/Smart-India-Hackthon-2025.git
   cd Smart-India-Hackthon-2025
   ```

2. **Environment Setup**
   ```bash
   cp .env.example .env
   # Add your API keys to .env file
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the Application**
   ```bash
   flutter run
   ```

### **Required API Keys**
- **Supabase**: Project URL and Anon Key
- **Google Maps**: API key with Maps SDK and Places API enabled

## 🌍 Mock Data & Content

### **Pondicherry-Focused Content**
- **6 Artisans**: Pottery, Handloom, Furniture, Brass Works, Jewelry, Art
- **8 Tourist Spots**: Ashrams, Beaches, Museums, Churches, Parks
- **8 Local Food Shops**: Sweet shops, Bakeries, Spice markets, Organic stores

### **Content Categories**
- **Artisan Categories**: Pottery, Weaving, Wood Carving, Jewelry, Metal Work, Paintings
- **Food Categories**: Traditional, Sweets, Beverages, Local Specialties
- **Folklore Types**: Traditions, Legends, Stories, Festivals

## 🔐 Security Features

- **Environment Variables**: All sensitive data in .env files
- **API Key Management**: Secure storage and loading
- **Authentication Flow**: Email verification required
- **Row Level Security**: Database-level access control
- **Input Validation**: Form validation and sanitization
- **Error Handling**: Graceful error states and recovery

## 📊 Performance Optimizations

- **Image Caching**: Cached network images for faster loading
- **Lazy Loading**: Content loaded on demand
- **State Persistence**: User session and preferences maintained
- **Memory Management**: Efficient widget lifecycle handling
- **Animation Performance**: Optimized Lottie animations

## 🎯 Key User Journeys

1. **Discovery**: Welcome → Signup → Profile Setup → Browse Content
2. **Exploration**: Search → Filter → View Details → Save/Contact
3. **Navigation**: Map View → Filter Places → Get Directions
4. **Engagement**: Find Artisan → Contact via WhatsApp → Save to Favorites

## 🏗️ Technical Highlights

- **Cross-platform**: Single codebase for iOS and Android
- **Offline Capability**: Local caching and mock data fallback
- **Real-time Features**: Live location tracking and updates
- **Scalable Architecture**: Modular, feature-based organization
- **Modern UI**: Material Design 3 with custom theming
- **Accessibility**: Screen reader support and semantic labels

## 📝 Documentation

- **USER_WORKFLOW_DIAGRAM.md**: Complete user journey visualization
- **.env.example**: Environment variable template
- **Database Schema**: Comprehensive Supabase table structure

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Follow the coding standards
5. Submit a pull request

## 📄 License

This project is developed for Smart India Hackathon 2025.

## 🔗 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Supabase Documentation](https://supabase.com/docs)
- [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter)
- [Provider State Management](https://pub.dev/packages/provider)
