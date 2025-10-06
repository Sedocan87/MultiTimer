# MultiTimer

Project Brief: "Parallel Timers" - The Multi-Timer & Workflow App
1. Project Overview & Vision
The Problem: Standard phone timers are inadequate for any complex, multi-step process. Cooking a large meal, conducting a lab experiment, or managing a darkroom photography session requires juggling multiple concurrent and sequential timings. Existing solutions are often clunky, unreliable, or have a poor user experience.

The Solution: "Parallel Timers" is a beautifully designed, highly intuitive, and reliable multi-timer application built for mobile-first. It allows users to run multiple named, color-coded timers simultaneously. Its core strength lies in its "at-a-glance" dashboard and its ability to save routines as templates, transforming it from a simple utility into an essential workflow tool.

Target Audience:

Primary: Home cooks and bakers who manage multiple dishes at once.

Secondary: Lab technicians, scientists, photographers (darkroom), fitness enthusiasts (HIIT workouts), BBQ/smoker hobbyists, and students (Pomodoro technique).

2. Core User Stories & Features
A user should be able to...

Create & Manage Multiple Timers:

As a user, I want to start a new timer with just a couple of taps.

As a user, I want to give each timer a unique name (e.g., "Pasta," "Roast Chicken") so I know what it's for.

As a user, I want to assign a color to each timer for quick visual identification.

As a user, I want to see all my active timers on a single screen (the "Dashboard").

As a user, I want to easily pause, resume, add/subtract time, and cancel individual timers.

Get Clear Notifications:

As a user, when a timer finishes, I want to receive a clear notification even if the app is in the background or my phone is locked.

As a user, I want the notification to tell me which timer finished (e.g., "Your 'Pasta' timer is done!").

As a user, I want to feel a distinct vibration pattern for each timer so I can differentiate them without looking at my screen.

Utilize Templates for Efficiency:

As a user, I want to save a group of timers as a "Template" (e.g., "Sunday Roast" template with timers for potatoes, meat, and vegetables).

As a user, I want to launch an entire group of timers from a template with a single tap.

Upgrade for "Pro" Features:

As a pro user, I want to run an unlimited number of timers simultaneously.

As a pro user, I want to create "Timer Sequences," where one timer finishing automatically starts the next one (e.g., "Darkroom: Developer" -> "Darkroom: Stop Bath").

As a pro user, I want to assign custom notification sounds to different timers.

3. UI/UX Design Principles
The app's success hinges on a flawless user experience.

Clarity Over Clutter: The main dashboard is paramount. It should display all active timers in a clean grid or list. Each timer "widget" must clearly show its name, remaining time, and a visual progress indicator (like a depleting ring or bar).

At-a-Glance Readability: Use large fonts and high-contrast colors. A user should be able to see the status of all timers from a distance while their hands are busy.

Minimal Taps: Creating, starting, and managing timers should be incredibly fast and intuitive. A large "+" button should be ever-present to add a new timer.

Haptic & Audio Feedback: Interaction should be confirmed with subtle vibrations and sounds. Timer completion alerts should be impossible to miss.

4. Technical Requirements
Platform: React Native or Flutter. This allows for a single codebase for both iOS and Android, which is ideal for this project.

Recommendation: Flutter might have a slight edge here due to its strong handling of custom UI and animations, which will be key to making the dashboard feel fluid and responsive. However, a skilled React Native developer can achieve the same result.

State Management: A robust state management solution is critical for tracking the state of multiple timers simultaneously.

Flutter: Bloc or Riverpod.

React Native: Redux Toolkit or MobX.

Background Execution & Notifications (CRITICAL):

The Challenge: The timers must keep running accurately and fire notifications even if the app is terminated by the OS. This is the most critical technical hurdle.

The Solution: The app must implement native background services.

On Android, use WorkManager and a Foreground Service to ensure the timer process is not killed.

On iOS, use the BackgroundTasks framework to request processing time and rely on UserNotifications with time-interval triggers. Thorough testing is required to ensure reliability across different iOS versions.

Notifications: Use a local push notification library (e.g., flutter_local_notifications for Flutter) to schedule and display alerts. The library must support custom sounds and haptic feedback (vibration patterns).

Local Storage: All user data (saved templates, timer history, settings) must be stored locally on the device.

Recommendation: Use a lightweight, embedded database like SQLite (sqflite package in Flutter) for storing templates and sequences. For simple key-value settings, SharedPreferences / AsyncStorage is sufficient.

In-App Purchases (IAP):

Recommendation: Use a cross-platform IAP abstraction layer like RevenueCat. It dramatically simplifies the management of subscriptions and one-time purchases across the App Store and Google Play, handling receipt validation and state management.

Implementation: The app will need to implement a "paywall" screen and logic to check for a user's premium status to unlock pro features.

5. Development Plan (Phased Rollout)
This project should be built in phases to ensure quality and allow for user feedback.

Phase 1: Minimum Viable Product (MVP) - (Est. 3-4 Weeks)
Goal: Build the core, reliable functionality.

UI Scaffolding: Develop the main dashboard screen and the "add/edit timer" screen.

Core Timer Logic: Implement the logic to run multiple, named, and color-coded timers concurrently.

Basic Notifications: Implement reliable background execution and notifications that fire when timers complete. The app must be trustworthy above all else.

Timer Controls: Implement pause, play, reset, and delete functionality for each timer.

Monetization Stub: Add a simple ad banner (e.g., AdMob) and limit the number of simultaneous timers to 3.

Phase 2: Core Enhancements & Monetization - (Est. 2-3 Weeks)
Goal: Make the app powerful and ready for purchase.

Template System: Implement the logic to save and load groups of timers as templates.

Advanced Notifications: Add options for custom vibration patterns and a selection of unique built-in alert sounds.

In-App Purchase Implementation: Integrate RevenueCat (or similar) to handle a single one-time purchase to unlock the "Pro" version.

Pro Feature Unlock: Remove the timer limit and ads for pro users.

UI Polish: Add animations and refine the user experience based on initial testing.

Phase 3: "Pro" Features & Market Polish - (Est. 2 Weeks)
Goal: Add the killer features that will set the app apart.

Timer Sequences: Develop the logic for one timer to automatically trigger the next. This requires a more complex UI for setting up the sequence.

Custom Sounds: Allow users to use their own device sounds for notifications (Pro feature).

Lock Screen Integration: Implement iOS Live Activities / Dynamic Island and Android persistent media-style notifications to show timer progress without unlocking the phone.

Onboarding: Create a simple, first-time user onboarding flow to explain the key features.

Phase 4: Post-Launch & Maintenance (Ongoing)

Monitor crash reports and user feedback.

Release updates to support new OS versions (e.g., iOS 19, Android 16).

Consider future features based on user requests (e.g., data export, sharing templates with a link, Apple Watch/Wear OS companion app).
