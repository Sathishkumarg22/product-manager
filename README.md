Product Manager

A Flutter-based demo application for managing products, built with advanced UI animations, BLoC state management, and integration with the Fake Store API. The app supports user authentication, product listing, creation, updating, deletion, and searching.

Table of Contents

Features

Screenshots

Setup Instructions

Codebase Overview

Screens

API Integration

Known Issues

UI and Animations

State Management

Testing


Contributing

License

Features


User Authentication: Login and logout functionality with token-based authentication.

Product Management: Create, read, update, and delete (CRUD) products.

Search Functionality: Search products by title in the product list screen.


Advanced UI: Gradient backgrounds, blur effects, and smooth animations (FadeTransition, SlideTransition).

State Management: BLoC pattern for robust and scalable state management.

API Integration: Uses the Fake Store API for product data.

Secure Storage: Stores authentication tokens securely using a storage service.

Screenshots


Login Screen

Product List Screen

Product Details Screen

Note: Replace the screenshot paths with actual paths after adding screenshots to the screenshots/ folder.

Setup Instructions

Prerequisites


Flutter: Version 3.10.0 or higher

Dart: Version 3.0.0 or higher

IDE: Android Studio, VS Code, or any Flutter-supported IDE

Git: For cloning the repository

Steps



Clone the Repository:

git clone https://github.com/your-username/product-manager.git
cd product-manager

Install Dependencies:

flutter pub get

Generate Mocks (for Testing): Ensure build_runner and mockito are set up in pubspec.yaml, then run:

flutter pub run build_runner build

Run the App: Connect a device or emulator and run:

flutter run

Run Tests: Execute unit and widget tests with:

flutter test

Dependencies

Key dependencies used in the project:

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  dio: ^5.3.3
  equatable: ^2.0.5
  provider: ^6.0.5
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.6

Codebase Overview

The project follows a clean architecture with separation of concerns:


lib/blocs/: Contains BLoC classes for authentication (AuthBloc) and product management (ProductBloc).

lib/repositories/: Handles data operations (AuthRepository, ProductRepository).

lib/services/: Includes API (ApiService) and storage (StorageService) services.

lib/ui/: UI components, screens, and widgets.


lib/models/: Data models (e.g., User, Product).

test/: Unit and widget tests for BLoCs, repositories, and widgets.

Screens


Login Screen (LoginScreen):


Displays a gradient background with a login form.

Uses BlocListener to show error messages via ScaffoldMessenger.

Triggers LoginRequested event on form submission.

Product List Screen (ProductListScreen):


Lists products fetched from the Fake Store API.


Includes a search bar to filter products by title.

Supports navigation to product details and creation screens.

Uses BlocBuilder to handle loading, success, and error states.


Product Details Screen:


Displays product details with options to edit or delete.

Uses SlideTransition for entry animation.

Product Create/Update Screen:


Form to create or update a product.


Submits data via AddProduct or UpdateProduct events.

API Integration

The app integrates with the Fake Store API for product management:


GET /products: Fetches the list of products.


POST /products: Creates a new product.


PUT /products/:id: Updates an existing product.


DELETE /products/:id: Deletes a product.


POST /auth/login: Authenticates users and returns a token.

Implementation:


ApiService uses the dio package for HTTP requests.


Requests are intercepted to attach authentication tokens (except for login).

Responses and errors are logged for debugging.

Known Issues


GET API Issue: The Fake Store API does not persist changes made via POST or PUT requests. As a result, newly added or updated products are not reflected in subsequent GET requests. However, the app's CRUD functionality (UI, BLoC events, and repository logic) is fully implemented and works as expected within the app's scope.

Workaround: Consider using a mock server or a custom backend for persistent data storage in a production environment.

UI and Animations

The app features a modern and polished UI with advanced animations:

Gradient Backgrounds: Used in LoginScreen and other screens for visual appeal.

Blur Effect: Applied using ClipRRect with a BackdropFilter for a frosted glass effect in certain widgets.

FadeTransition: Smoothly fades in/out widgets during navigation or state changes.

SlideTransition: Animates widgets (e.g., product cards, modals) sliding into view.

Responsive Design: Ensures compatibility across different screen sizes.

State Management

The app uses the BLoC (Business Logic Component) pattern for state management:

AuthBloc:

Handles authentication events (AppStarted, LoginRequested, LogoutRequested).

Emits states (AuthInitial, AuthLoading, AuthAuthenticated, AuthUnauthenticated, AuthError).

Uses BlocListener in LoginScreen to display error messages.

ProductBloc:

Manages product-related events (LoadProducts, AddProduct, UpdateProduct, DeleteProduct, SearchProducts).

Emits states (ProductLoading, ProductLoaded, ProductError).

Used in ProductListScreen to handle product listing and search.

BlocBuilder: Rebuilds UI based on state changes (e.g., loading indicators, product lists).

BlocListener: Listens for state changes to trigger side effects (e.g., showing SnackBars).

Testing

The project includes unit and widget tests to ensure reliability:

AuthBloc Tests: Verify event-to-state transitions for authentication.

AuthRepository Tests: Test login, logout, and token retrieval.

MyApp Tests: Validate widget structure, navigation, and provider setup.

Tools: Uses flutter_test, bloc_test, and mockito for mocking dependencies.

Run tests with:

flutter test

Contributing

Contributions are welcome! To contribute:

Fork the repository.

Create a feature branch (git checkout -b feature/your-feature).

Commit changes (git commit -m "Add your feature").

Push to the branch (git push origin feature/your-feature).

Open a pull request.

Please ensure your code follows the project's style guidelines and includes tests.

License

This project is licensed under the MIT License. See the LICENSE file for details.