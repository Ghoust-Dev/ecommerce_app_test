# Ecommerce App

A new Flutter Ecommerce Application.

## Table of Contents

1- Installation and Setup.

2- Technical and Architectural Choices.

3- Features and Functionalities.

## Installation and Setup
### Prerequisites
- Ensure you have the following installed on your system:
    - Flutter (for Flutter projects).
    - Dart SDK (if not included with Flutter).
    - IDE or Code Editor (VS Code, Android Studio).

### Clone the Repository
- git clone https://github.com/Ghoust-Dev/ecommerce_app_test.git.
- cd ecommerce_app_test


### Install Dependencies
flutter pub get

## Technical and Architectural Choices
### Technology Stack
- Frontend: Flutter and Dart.
- State Management: GetX (for reactive state management and navigation).
- Backend: REST API from https://dummyjson.com/products.

### Architectural Decisions
1- **MVC Pattern**:
    
- Model-View-Controller architecture was chosen for clear separation of concerns.
- Reason: Simplifies codebase management and enhances scalability.

2- **State Management: GetX**:
    - Reason: Lightweight, reactive, and simplifies dependency injection and route management.

## Features and Functionalities
### Features
1- **Product Management**:
    - Browse products by category.
    - Search products by title.
    - View detailed product information, including discounts and reviews.

2- **Shopping Cart**:
    - Add products to the cart.
    - Modify product quantities with stock validation.
    - Calculate total prices with discounts applied.

3- **Checkout System**:
    - Submit cart items to a mock API.
    - Validate user input during checkout (shipping details, payment method).

4- **Search and Filter**:
    - Search categories or products with LIKE-style matching.

5- **Responsive Design**:
    - Fully functional on mobile.

6- **Bottom Navigation**:
    - Navigate to Home and Cart Screens.

7- **Network Image Caching**:
    - Images are fetched from a network and cached locally to improve performance.

### Screens Overview
1- **Home Screen**:
    - Displays product categories and featured items.

2- **Product List Screen**:
    - Lists products in the selected category.

3- **Product Detail Screen**:
    - Displays detailed product information.
    - Provides "Add to Cart" functionality.

4- **Cart Screen**:
    - Lists cart items with quantity adjustments.
    - Shows price calculations with discounts.

5- **Checkout Screen**:
    - Allows user to submit cart data to a mock API.