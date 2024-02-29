# Flutter Chat Application

This Flutter application allows users to engage in real-time text and image-based conversations with other users. It utilizes Firebase Firestore for real-time data synchronization and Firebase Storage for storing images.

## Features

- Real-time text messaging
- Image messaging
- Online/offline status indicator
- User authentication
- Chat room creation

## Screenshots

[Insert screenshots here]

## Getting Started

To run this application on your local machine, follow these steps:

1. **Clone this repository:**

   ```bash
   git clone https://github.com/your-username/flutter-chat-app.git
   ```

2. **Navigate to the project directory:**

   ```bash
   cd flutter-chat-app
   ```

3. **Install dependencies:**

   ```bash
   flutter pub get
   ```

4. **Configure Firebase:**

   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Enable Firestore and Firebase Storage for your project.
   - Add your Flutter app to the Firebase project and follow the setup instructions to download the `google-services.json` file.
   - Place the `google-services.json` file in the `android/app` directory of your Flutter project.
   - Update the `android/build.gradle` file to include the Google services plugin.

5. **Run the application:**

   ```bash
   flutter run
   ```

## Dependencies

- [firebase_core](https://pub.dev/packages/firebase_core)
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [firebase_storage](https://pub.dev/packages/firebase_storage)
- [image_picker](https://pub.dev/packages/image_picker)
- [uuid](https://pub.dev/packages/uuid)

## Contributing

Contributions are welcome! If you encounter any bugs or have suggestions for improvement, please open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
