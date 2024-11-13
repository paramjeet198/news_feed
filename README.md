# news_feed
News Feed App with Firebase Integration

Overview
This News Feed app fetches articles from Firebase Firestore and displays them in a clean, scrollable list. It uses Riverpod for state management, cached_network_image for image caching, and Firestore’s built-in offline support to ensure smooth performance even with limited connectivity.

Key Features
Lazy Loading: ListView.builder ensures articles are loaded only when needed, improving scrolling performance.
State Management: Riverpod manages article data efficiently, minimizing unnecessary Firebase reads and UI rebuilds.
Image Caching: cached_network_image caches images locally for faster loading and offline support.
Offline Support: Articles and images are accessible offline, with data automatically cached by Firestore.
Connectivity Check: connectivity_plus ensures the app checks for network availability and handles retries.
Performance Optimization
Firestore Caching: Articles are cached locally and sync when online.
Efficient Data Management: Riverpod handles state efficiently, reducing redundant reads and rebuilds.
Image & Data Caching: Both articles and images are cached to minimize network usage and improve app speed.

Dependencies
riverpod: ^2.0.0
cached_network_image: ^3.2.1
connectivity_plus: ^6.1.0
firebase_core: ^1.10.0
cloud_firestore: ^3.1.5

Conclusion
This app is optimized for performance with lazy loading, image caching, and offline support, ensuring a smooth user experience even with poor connectivity.
