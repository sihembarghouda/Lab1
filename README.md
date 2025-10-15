
# Notes App 📝

A clean and simple Flutter notes application that demonstrates component-based architecture and modern Flutter development practices.

## Features ✨

- **Add Notes**: Create new notes with a simple tap
- **Edit Notes**: Modify existing notes seamlessly
- **Delete Notes**: Remove notes you no longer need
- **Clean UI**: Modern Material Design interface
- **Component Architecture**: Well-structured, reusable components
- **Cross-Platform**: Runs on Web, iOS, and Android

## Screenshots 📱

### Home Screen
- Welcome screen with navigation to notes
- Clean blue theme with modern styling

### Notes Screen
- List view of all notes
- Add button (+) in the header
- Edit and Delete actions for each note
- Empty state message when no notes exist

## Architecture 🏗️

This app follows Flutter best practices with a component-based architecture:

```
lib/
├── main.dart                   # App entry point and routing
├── components/
│   ├── note_item.dart          # Individual note display widget
│   └── note_input_dialog.dart  # Add/Edit note dialog widget
└── screens/
    ├── home_screen.dart        # Welcome/landing screen
    └── notes_screen.dart       # Main notes management screen
```

### Component Breakdown

#### `NoteItem` Widget
- **Purpose**: Displays individual notes in a card format
- **Props**: `note`, `onEdit`, `onDelete`
- **Features**: Material card design with shadow, edit/delete buttons

#### `NoteInputDialog` Widget
- **Purpose**: Handles note input for both adding and editing
- **Props**: `controller`, `isEditing`, `onSave`
- **Features**: Modal dialog with text input and save/cancel actions

#### `NotesScreen` Widget
- **Purpose**: Main screen for note management
- **Features**: State management, CRUD operations, responsive layout

## Getting Started 🚀

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>=3.9.2)
- [Dart](https://dart.dev/get-dart) (>=3.0.0)
- An IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd NotesApp/notes_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile (with device/emulator connected)
   flutter run
   ```

### Development Commands

```bash
# Run the app in debug mode
flutter run

# Run with hot reload
flutter run --hot

# Build for production (web)
flutter build web

# Build APK for Android
flutter build apk

# Analyze code for issues
flutter analyze

# Run tests
flutter test

# Format code
flutter format .
```

## Usage Guide 📖

### Adding a Note
1. Tap the "+" button in the top-right corner
2. Enter your note content in the dialog
3. Tap "Save" to add the note

### Editing a Note
1. Tap the "Edit" button on any note card
2. Modify the content in the dialog
3. Tap "Save" to update the note

### Deleting a Note
1. Tap the "Delete" button on any note card
2. The note will be immediately removed

## Technical Details 🔧

### State Management
- Uses Flutter's built-in `StatefulWidget` and `setState()`
- Local state management for notes list
- TextEditingController for form inputs

### Data Structure
Notes are stored as `Map<String, dynamic>` objects with:
- `id`: Unique identifier (timestamp-based)
- `content`: Note text content
- `createdAt`: ISO8601 creation timestamp
- `updatedAt`: ISO8601 last update timestamp (when edited)

### Styling
- **Theme**: Material Design with blue primary color
- **Typography**: Default Material typography scale
- **Layout**: Column-based responsive layout
- **Cards**: Elevated cards with subtle shadows
- **Buttons**: Material TextButton and ElevatedButton components

## Development Notes 💡

### Code Quality
- Follows Flutter/Dart conventions
- Component-based architecture for reusability
- Clear separation of concerns
- Proper disposal of controllers
- Null safety enabled

### Future Enhancements
- [ ] Data persistence (local storage)
- [ ] Search functionality
- [ ] Categories/tags for notes
- [ ] Dark theme support
- [ ] Note sharing functionality
- [ ] Rich text formatting
- [ ] Cloud synchronization

## Dependencies 📦

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

## Contributing 🤝

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

If you have any questions or need help with the app:

1. Check the [Flutter documentation](https://docs.flutter.dev/)
2. Visit [Flutter Community](https://flutter.dev/community)
3. Create an issue in this repository

---

**Built with ❤️ using Flutter**
