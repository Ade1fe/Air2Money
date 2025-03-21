# Air2Money

Air2Money is a Flutter mobile application that allows users to convert their airtime to cash and access other financial services. The platform provides a convenient way to monetize unused airtime and perform various transactions.

## Features

- **Airtime to Cash Conversion**: Convert excess airtime to real money
- **Multiple Network Support**: Compatible with major telecom networks
- **Secure Transactions**: End-to-end encryption for all transactions
- **User-Friendly Interface**: Intuitive design for seamless experience
- **Transaction History**: Keep track of all your conversions and transactions
- **Quick Withdrawals**: Fast transfer to bank accounts and mobile wallets
- **Competitive Rates**: Get the best rates for your airtime conversions

## Screenshots

![Home Screen](/placeholder.svg?height=400&width=200)
![Conversion Screen](/placeholder.svg?height=400&width=200)
![Transaction History](/placeholder.svg?height=400&width=200)

## Technologies Used

- Flutter & Dart
- Firebase (Authentication, Firestore, Cloud Functions)
- RESTful APIs for payment processing
- Secure encryption for data protection

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart (version 2.17.0 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS development)

### Installation

1. Clone the repository:
2. Navigate to the project directory:
3. Install dependencies:
4. Set up Firebase:
- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Enable Authentication, Firestore, and Cloud Functions
- Download the `google-services.json` file and place it in the `android/app` directory
- Download the `GoogleService-Info.plist` file and place it in the `ios/Runner` directory
5. Configure environment variables:
- Create a `.env` file in the root directory
- Add the following variables:
6. Configure platform-specific settings:

For Android:
- Update the `android/app/build.gradle` file with your application ID
- Ensure minimum SDK version is set to 21 or higher

For iOS:
- Update the Bundle Identifier in Xcode
- Set minimum iOS version to 11.0 or higher
- Add required permissions in Info.plist
7. Run the app:
8. Build for production:

For Android:
flutter build apk --release

For iOS:
flutter build ios --release


### Troubleshooting

- **Firebase Configuration Issues**:
- Ensure the package name in `google-services.json` matches your application ID
- Verify SHA-1 fingerprint is correctly added to Firebase project

- **Dependency Conflicts**:
- Run `flutter clean` and then `flutter pub get`
- Check for conflicting plugin versions in `pubspec.yaml`

- **Build Failures**:
- Update Flutter SDK: `flutter upgrade`
- Update CocoaPods (for iOS): `pod repo update`

## Configuration

1. Create a Firebase project and add your `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) to the respective directories.

2. Update the API keys in the `.env` file (create one if it doesn't exist):
API_BASE_URL=your_api_base_url
PAYMENT_GATEWAY_KEY=your_payment_gateway_key


## Usage

1. Register or log in to your account
2. Select the "Convert Airtime" option
3. Choose your network provider
4. Enter the amount of airtime you want to convert
5. Select your preferred payment method for receiving cash
6. Confirm the transaction and receive your money


### Project Structure
lib/
├── main.dart
├── config/
│   ├── app_config.dart
│   ├── routes.dart
│   └── theme.dart
├── models/
│   ├── user.dart
│   ├── transaction.dart
│   └── network_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── forgot_password_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── profile_screen.dart
│   ├── transactions/
│   │   ├── new_transaction_screen.dart
│   │   ├── transaction_history_screen.dart
│   │   └── transaction_details_screen.dart
│   └── settings/
│       ├── settings_screen.dart
│       ├── account_settings_screen.dart
│       └── notification_settings_screen.dart
├── services/
│   ├── auth_service.dart
│   ├── transaction_service.dart
│   ├── network_service.dart
│   └── payment_service.dart
├── utils/
│   ├── validators.dart
│   ├── formatters.dart
│   └── constants.dart
└── widgets/
├── common/
│   ├── custom_button.dart
│   ├── custom_text_field.dart
│   └── loading_indicator.dart
├── transaction/
│   ├── transaction_card.dart
│   └── network_selector.dart
└── auth/
├── auth_form.dart
└── social_login_buttons.dart


### State Management

The app uses Provider for state management. Key providers include:
- `AuthProvider`: Manages user authentication state
- `TransactionProvider`: Handles transaction data and operations
- `NetworkProvider`: Manages available network providers and rates

### API Integration

The app integrates with several APIs:
- Payment gateway API for processing transactions
- Network providers API for fetching current rates
- SMS verification API for OTP verification

### Running Tests

To run specific test files:
flutter test test/services/auth_service_test.dart

## Security

- All API requests are made over HTTPS
- User data is encrypted using AES-256 encryption
- Biometric authentication is available for secure login
- Session tokens expire after 30 minutes of inactivity

## Roadmap

- [ ] Add support for additional network providers
- [ ] Implement referral system
- [ ] Add in-app notifications
- [ ] Support for multiple currencies
- [ ] Integrate with more payment gateways

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style

This project follows the official Dart style guide. Run the following to ensure your code is properly formatted:

flutter format .
And to analyze the code:
flutter analyze


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contact

Project Link: [https://github.com/yourusername/air2money](https://github.com/yourusername/air2money)

Support Email: support@air2money.com

## Acknowledgements

- [Flutter](https://flutter.dev)
- [Firebase](https://firebase.google.com)
- [Provider](https://pub.dev/packages/provider) for state management
- [Dio](https://pub.dev/packages/dio) for HTTP requests
- [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage) for secure data storage
- [Local Auth](https://pub.dev/packages/local_auth) for biometric authentication
