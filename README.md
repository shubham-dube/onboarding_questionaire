# Hotspot Host Onboarding Questionnaire

A Flutter application for onboarding hotspot hosts through an interactive questionnaire flow with experience selection and multimedia responses.

## 📱 Features Implemented

### 1. Experience Type Selection Screen
- ✅ Fetches experiences from the provided API endpoint
- ✅ Multi-selection support with visual feedback
- ✅ Grayscale effect on unselected experience cards
- ✅ Image backgrounds using `image_url` from API
- ✅ Multi-line text field with 250 character limit
- ✅ Clean, responsive UI with proper spacing
- ✅ State management for selected experiences and user text
- ✅ Navigation to question screen with data persistence

### 2. Onboarding Question Screen
- ✅ Multi-line text field with 600 character limit
- ✅ Audio recording with waveform visualization
- ✅ Video recording support with camera and video preview
- ✅ Dynamic UI layout based on recording state
- ✅ Cancel recording functionality
- ✅ Delete recorded audio/video capability
- ✅ Conditional button visibility (audio/video buttons hide after recording)

### 3. Custom App Bar
- ✅ Animated curved zigzag progress indicator
- ✅ Snake animation effect showing progress flow
- ✅ Back and close navigation buttons

## 🌟 Brownie Points Implemented

### UI/UX Excellence
- ✅ **Pixel-Perfect Design**: Implemented comprehensive theme system matching Figma specifications
    - Custom color palette (`AppColors`) extracted from design file
    - Consistent spacing system (`AppSpacing`) for responsive layouts
    - Typography system (`AppTextStyles`) with proper font weights and sizes
- ✅ **Responsive Design**: Handles viewport changes
    - Scroll views to prevent content overflow
    - Flexible layouts adapting to different screen sizes

### State Management
- ✅ **BLoC Implementation**: Complete state management (all navigations, data persistance, video and audio record stc.)
    - `OnboaringBloc`
    - `OnboardingState`
    - `OnboardingEvent`
- ✅ **Dio Integration**: HTTP client for API calls
    - Structured service layer (`DioClient`)
    - Error handling and loading states
    - Clean response parsing with models

### Animations
- ✅ **Experience Card Animation**: When Selected, cards animate to first position
    - Visual feedback during selection/deselection
- ✅ **Progress Bar Animation**: Smooth snake-like progress animation
    - Glowing effect at the leading edge
- ✅ **Button Width Animation**: Next button expands when recording buttons disappear
    - Smooth transition using `AnimatedContainer`
    - Maintains visual hierarchy

### Audio/Video Features
- ✅ **Audio Recording**: Full recording flow with waveform
    - Real-time waveform visualization during recording
    - Recording timer display
    - Cancel and delete functionality
- ⚠️ **Audio Playback**: Basic playback implemented with minor issues
    - Audio plays but with slight delay
    - Playback controls have responsiveness issues
    - *Note: This is a known limitation and could be improved with additional time*
- ✅ **Video Recording**: Complete video capture implementation
    - Camera preview with front/back switching
    - Recording indicator and timer
    - Video thumbnail and play button visibility after recording

## 🎨 Additional Features & Enhancements

### Architecture & Code Quality
- 📁 **Clean Architecture**: Well-structured project organization
  ```
  lib/
  ├── core/
  │   ├── theme/          # Theme system (colors, spacing, text styles)
  │   └── network/        # Dio Client
  │   └── widgets/        # Global Widgets
  ├── features/
  │   └── onboarding/
  │       ├── domain/                   # Contains Data LAYER (Repos and Data)
  │       │   ├── models/               # All models
  │       │   ├── repositories/         # All Repos in this feature
  │       │   └── services/             # Services like (Audio, Video Recording and Playback Services)
  │       ├── presentation/
  │       │   ├── screens/              # All Screen Entry points
  │       │   ├── widgets/              # Custom Reusable features widgets
  │       │   └── bloc/                 # BLoC States, Events etc for state management
  └── main.dart
  ```
- 🔧 **Reusable Components**: Custom widgets for cards, buttons, and input fields

### User Experience
- 🎯 **Loading States**: loading circular during API calls
- ⚠️ **Error Handling**: User-friendly error messages
- 🎨 **Glassmorphism Effects**: Modern UI with backdrop blur effects

### Performance Optimizations
- 🚀 **Efficient Image Loading**: Cached network images
- 🎬 **Optimized Animations**: 60fps performance with proper dispose calls
- 💾 **Memory Management**: Proper controller disposal and lifecycle handling

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **State Management**: BLoC
- **HTTP Client**: Dio
- **Audio Recording**: `record` package with `audio_waveforms` and `just_audio`
- **Video Recording**: `camera` package
- **Image Processing**: `cached_network_image`
- **UI Components**: Custom Material Design widgets

### Permissions

Ensure the following permissions are added to your platform-specific files:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video recording</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for audio recording</string>
```

## 📝 API Integration

The app integrates with the following endpoint:

**Get Experiences**
- URL: `https://staging.chamberofsecrets.8club.co/v1/experiences?active=true`
- Method: GET
- Response: List of experience objects with id, name, description, and image URLs

## 🐛 Known Issues

1. **Audio Playback Delay**: There is a slight delay when starting audio playback, and playback controls may not respond immediately. This is due to platform-specific audio handling and could be improved with additional buffer management.

## 👨‍💻 Development Notes

- The app follows Material Design 3 guidelines
- All colors, spacing, and typography are extracted from the Figma design
- Responsive design tested on multiple screen sizes
- Code is structured for easy maintenance and scalability

## 📄 License

This project is part of the Flutter Internship Assignment for 8club.