# Al Baker Air Conditioning

<div align="center">

![App Logo](assets/icons/app_icon3.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.7.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![API](https://img.shields.io/badge/API-REST-orange?style=for-the-badge)](https://albakr-ac.com/api)

</div>

## 📱 Overview

Al Baker Air Conditioning is a modern, feature-rich mobile application designed to streamline the process of purchasing, maintaining, and servicing air conditioning units. The app serves as a comprehensive platform connecting customers with Al Baker's air conditioning services, offering a seamless experience for both customers and service providers.

## ✨ Key Features

### Customer Features
- **Product Management**
  - Browse complete AC catalog with detailed specifications
  - Dynamic product search and filtering
  - Favorite items list for quick access
  - Smart product recommendations
  - Real-time stock availability

- **Shopping Experience**
  - Intuitive shopping cart management
  - Multi-item checkout process
  - Secure PyMob payment integration
  - Order history and tracking
  - Wishlist functionality

- **Service Management**
  - Schedule maintenance appointments
  - Real-time service request tracking
  - Comprehensive service history
  - Instant price quotes
  - Emergency service requests

- **User Experience**
  - Personalized user profiles
  - Push notifications for updates
  - Arabic language support
  - Dark mode support
  - Responsive design for all screen sizes

## 🎯 App Sections

1. **Home Screen (`home_screen.dart`)**
   - Featured products slider
   - Category navigation
   - Best sellers section
   - Quick search functionality
   - User greeting and profile access

2. **Products Section**
   - Grid and list view options
   - Advanced filtering and sorting
   - Detailed product information
   - Image galleries
   - Technical specifications

3. **Cart Management (`cart_screen.dart`)**
   - Real-time price updates
   - Quantity adjustment
   - Save for later option
   - Quick checkout access
   - Cart synchronization

4. **Projects Section (`projects_screen.dart`)**
   - Completed project showcase
   - Project details and photos
   - Location information
   - Technical specifications
   - Client testimonials

5. **Works Section (`works_screen.dart`)**
   - Service portfolio
   - Before/after galleries
   - Service categorization
   - Customer reviews
   - Work process details

6. **Profile Section**
   - Personal information management
   - Order history
   - Service requests
   - Saved addresses
   - Payment methods

## 🛠️ Technologies & Tools

### Core
- **Flutter** (v3.7.2)
- **Dart** (v3.7.2)
- **Android NDK** (v27.0.12077973)

### Frontend
- **Lottie** (^3.3.1) - Smooth animations and transitions
- **RFlutter Alert** (^2.0.7) - Custom alert dialogs
- **Cupertino Icons** (^1.0.8) - iOS-style icons
- **Ionicons** - Modern icon set

### Networking & Data
- **Dio** (^5.8.0+1) - HTTP client for API communication
- **Shared Preferences** (^2.0.15) - Local data storage
- **Cached Network Image** (^3.3.0) - Efficient image caching
- **URL Launcher** (^6.2.4) - External link handling

## 📐 Architecture

The application follows a service-based architecture with clear separation of concerns:

### Services Layer (`services/`)
- **Authentication Service** - User authentication and authorization
- **Cart Service** - Shopping cart operations
- **Orders Service** - Order management
- **Products Service** - Product catalog operations
- **Projects Service** - Project showcase management
- **Works Service** - Service portfolio handling
- **Home Service** - Home screen data management
- **User Service** - Profile management
- **Payment Service** - Payment processing
- **Favorite Service** - Wishlist management

### UI Layer
- **Screens** - Main interface components
- **Widgets** - Reusable UI elements
- **Utils** - Helper functions and utilities

### Data Layer
- RESTful API integration
- Local storage management
- Caching mechanisms
- State management

## 🎨 UI/UX Features

- **Branded Theme**
  - Primary color: #1D75B1
  - Custom Almarai font family
  - Consistent visual hierarchy
  - Smooth animations

- **Responsive Design**
  - Adaptive layouts
  - Dynamic sizing
  - Orientation support
  - Tablet optimization

- **User Interface**
  - Custom navigation bar
  - Animated transitions
  - Loading states
  - Error handling
  - Empty state displays

## 🔒 Security Features

- **Authentication**
  - Token-based security (JWT)
  - Secure password storage
  - OTP verification
  - Session management

- **Data Protection**
  - Encrypted storage
  - Secure API communication
  - Payment data protection
  - Privacy controls

## 🚀 Setup & Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/al_baker_air_conditioning.git
   cd al_baker_air_conditioning
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure environment:
   - Set up API endpoint in `services/`
   - Configure payment integration
   - Set up push notifications

4. Run the app:
   ```bash
   flutter run
   ```

## ⚙️ Configuration

The app connects to the Al Baker API at `https://albakr-ac.com/api`. To modify the API endpoint:

1. Update the `baseUrl` in service files under `lib/services/`
2. Rebuild the app with `flutter run`

## 👥 User Roles

- **Customer**
  - Browse and purchase products
  - Schedule services
  - Track orders
  - Manage profile

## 📱 Platform Support

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Modern browsers

## 🌐 API Integration

- REST API endpoints
- JWT authentication
- JSON data format
- Error handling
- Rate limiting

## 📞 Support & Contact

For support or inquiries:
- 📧 Email: [info@albakr-ac.com](mailto:info@albakr-ac.com)
- 🌐 Website: [https://albakr-ac.com](https://albakr-ac.com)

## 📄 License

This project is licensed under the MIT License. See the `LICENSE` file for details.