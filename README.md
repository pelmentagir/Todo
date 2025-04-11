# ToDo App

A modern iOS task management application built with Swift, featuring a sophisticated theme management system and clean architecture.

## Features

### Core Architecture & Technologies

- **MVVM Architecture**: Clean separation of concerns with ViewModels handling business logic and Views focusing on UI presentation
- **Core Data**: Robust data persistence layer for task management
- **Scene-Based Architecture**: Modern iOS app structure utilizing `UIWindowScene` for better window management
- **Theme Management System**: Advanced theme switching capabilities with system-wide application

### Theme Management System

The app features a sophisticated theme management system implemented through `ThemeManager`:

- **Singleton Pattern**: Global access to theme settings through `ThemeManager.shared`
- **Scene-Based Theme Application**: Utilizes `UIApplication.shared.connectedScenes` to apply themes across all windows
- **Persistent Theme Storage**: Theme preferences are stored in `UserDefaults` for persistence
- **Dynamic Theme Switching**: Real-time theme updates across all app windows
- **System Integration**: Seamless integration with iOS system appearance settings

### Screen-Specific Features

#### Main Screen
- Dynamic task list with Core Data integration
- Smooth animations and transitions
- Custom UI components for enhanced user experience

#### Settings Screen
- Theme customization options
- System-wide theme persistence
- Real-time theme preview

#### Archive Screen
- Historical task management
- Efficient data retrieval and display
- Custom sorting and filtering options

### Technical Highlights

- **Scene-Based Window Management**: Advanced understanding of iOS window and scene hierarchy
- **Custom View Components**: Reusable UI elements for consistent design
- **Protocol-Oriented Programming**: Clean interfaces for component communication
- **Extension-Based Utilities**: Swift extensions for enhanced functionality
- **Observer Pattern**: Efficient state management and UI updates

## Architecture

The app follows a well-structured architecture:

```
ToDo/
├── MainScreen/         # Main task management interface
├── SettingsScreen/     # App configuration and theme settings
├── ArchiveScreen/      # Archived tasks management
├── CustomView/         # Reusable UI components
├── Extension/          # Swift extensions
├── Observers/          # State observation patterns
├── Model/              # Data models and business logic
├── Helper/             # Utility functions
├── Protocol/           # Protocol definitions
├── CoreData/           # Core Data stack and operations
└── ThemeManager.swift  # Theme management system
```

This implementation showcases:
- Understanding of iOS scene-based architecture
- Efficient window management across multiple scenes
- Persistent theme storage
- Clean singleton pattern implementation

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.0+

## Installation

1. Clone the repository
2. Open `ToDo.xcodeproj` in Xcode
3. Build and run the project

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details 
