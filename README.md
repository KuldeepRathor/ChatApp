Flutter Chat Application
This Flutter application allows users to engage in real-time text and image-based conversations with other users. It utilizes Firebase Firestore for real-time data synchronization and Firebase Storage for storing images.

Features
Real-time text messaging
Image messaging
Online/offline status indicator
User authentication
Chat room creation
Screenshots


Getting Started
To run this application on your local machine, follow these steps:

Clone this repository:

bash
Copy code

Navigate to the project directory:

bash
Copy code
cd flutter-chat-app
Install dependencies:

bash
Copy code
flutter pub get
Configure Firebase:

Create a new Firebase project in the Firebase Console.
Enable Firestore and Firebase Storage for your project.
Add your Flutter app to the Firebase project and follow the setup instructions to download the google-services.json file.
Place the google-services.json file in the android/app directory of your Flutter project.
Update the android/build.gradle file to include the Google services plugin.
Run the application:

bash
Copy code
flutter run
Dependencies
firebase_core
cloud_firestore
firebase_auth
firebase_storage
image_picker
uuid
Contributing
Contributions are welcome! If you encounter any bugs or have suggestions for improvement, please open an issue or submit a pull request.

License
This project is licensed under the MIT License.
