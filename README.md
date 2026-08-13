# 🌿 Moneta Trail — Personal Finance Tracker Application

<p align="center">
  <img src="assets/images/logo.png" alt="Moneta Trail Banner" width="120" />
</p>

<p align="center">
  <b>A Production-Ready, Offline-First Personal Finance & Ledger Management Suite</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white" alt="SQLite" />
  <img src="https://img.shields.io/badge/Material_Design_3-7B1FA2?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material 3" />
  <img src="https://img.shields.io/badge/Platform-Android_%7C_iOS_%7C_Windows-brightgreen?style=for-the-badge" alt="Platform" />
</p>

---

## 📌 Application Overview

**Moneta Trail** Is A State-Of-The-Art, Offline-First Personal Financial Management Suite Built With **Flutter**, **Riverpod**, And The **Drift SQLite Engine**. It Empowers Users To Effortlessly Track Income, Expenses, And Account Transfers With Real-Time Financial Analytics, Smart Budget Warnings, Custom Categories, And Local Biometric Security.

---

## ✨ Key Feature Highlights

### 📊 Real-Time Financial Analytics & Interactive Visualizations
- **Category Breakdown Donut Chart**: Dynamic Interactive Donut Chart Illustrating Expense Distribution Across Categories.
- **Daily Trend Flow Line Chart**: Smooth Multi-Color Line Graph Tracking Inflows Versus Outflows Across Selected Months.
- **Weekly Expense Flow Bar Chart**: Visual Bar Charts Comparing Weekly Spending Peaks.
- **Cash Flow Overview Card**: Highlights Total Inflow, Outflow, Net Balance, And Savings Rates.

### 💳 Multi-Account Ledger & Balance Auto-Reversal
- **Dynamic Color-Coded Account Cards**: Support For Cash Wallets, Bank Accounts, Credit Cards, Savings, And Investments.
- **Account Transfer Flow**: Seamless Transfers Between Accounts With Automated Dual Balance Adjustments.
- **Safe Transaction Deletion**: Deleting A Transaction Record Automatically Reverts Account Balances To Preserve One Hundred Percent Accuracy.

### 🎯 Smart Budget Tracking & Spending Warnings
- **Custom Monthly Category Budgets**: Set Specific Spend Caps For Individual Categories.
- **Visual Progress Indicators**: Color-Shifting Progress Bars Transitioning From Emerald Green To Amber Warning And Crimson Red Exceeded.
- **Over-Budget Warnings**: Real-Time Alerts When Category Spending Exceeds Allocated Caps.

### 🏷️ Custom Vibrant Category Icon Selector
- **Extensive Icon Library**: Dozens Of Modern Vector Icons Paired With Vibrant Color Badges.
- **Custom Category Creation**: Add, Edit, Or Delete Categories With Instant Grid Updates.

### 🔍 Real-Time End-To-End Search & Filter Engine
- **Instant Search**: Filter Transactions Dynamically As You Type Across Category Names, Account Names, Notes, And Amounts.
- **Month & Category Quick Filters**: Switch Monthly Views Or Filter Feeds By Category Pills In A Single Tap.

### 🔒 Privacy & Biometric Lock Security
- **Local Biometric Authentication**: Protect Financial Data Using Fingerprint Or Face ID Recognition.
- **Local Security PIN**: Fallback PIN Verification System For Secure App Entry.
- **Offline Privacy**: Zero External Server Dependencies — All Financial Data Is Saved Safely On Device SQLite Database.

---

## 🏗️ System Architecture & Technology Stack

| Layer / Component | Technology Used | Description & Purpose |
| :--- | :--- | :--- |
| **Framework** | Flutter 3.x (Dart 3.x) | Cross-Platform Responsive Mobile & Desktop Engine |
| **State Management** | Riverpod 2.x | Reactive Dependency Injection & Stream Watching |
| **Local Database Engine** | Drift 2.x / SQLite | Type-Safe Local SQLite Engine With Stream Reactive Queries |
| **Navigation & Routing** | GoRouter | Declarative Deep Link Ready Page Navigation System |
| **UI Design System** | Material Design 3 | Glassmorphic Dark Aesthetics & Custom Typography |
| **Data Backup & Export** | Custom JSON Serializer | Full Database Import, Export, And Restore Suite |

---

## 📁 Repository Directory Structure

```text
Moneta-Trail/
├── android/                   # Native Android Build Manifests & Signing Configurations
├── assets/                    # Static Assets, Icons, And App Logos
│   └── images/
├── lib/
│   ├── Core/                  # Shared Design Tokens, Database Engine, Themes & Utilities
│   │   ├── Database/          # Drift SQLite Database Schemas & Generated Tables
│   │   ├── Services/          # Security, Biometrics, And Backup Services
│   │   ├── Theme/             # AppColors, AppTypography, And AppTheme
│   │   └── Utilities/         # Currency Formatter & Icon Mappers
│   ├── Features/              # Feature-First Business Modules
│   │   ├── Accounts/          # Account Management & Details Screens
│   │   ├── Analysis/          # Financial Analysis & Charts Screens
│   │   ├── Budgets/           # Budget Tracking & Management Screens
│   │   ├── Categories/        # Category Manager & Icon Selectors
│   │   ├── Profile/           # Profile, Security Settings & Biometrics
│   │   ├── Records/           # Dashboard Feed & Real-Time Search
│   │   └── Transactions/      # Add/Edit Transaction Modals & Keypad
│   └── Widgets/Shared/        # Reusable Shared UI Components & Charts
├── test/                      # Unit Tests & Widget Smoke Test Suites
└── pubspec.yaml               # Project Dependencies & Manifest
```

---

## 💾 Local SQLite Database Schema Overview

The Local Database Engine Is Powered By **Drift SQLite**, Consisting Of 5 Core Tables:

1. **`AppProfileTable`**: Stores User Profile Details, Primary Currency Code, Biometrics Preferences, And Security Passcodes.
2. **`FinancialAccountTable`**: Tracks Account Names, Account Types, Balances In Cents, And Theme Colors.
3. **`CategoryTable`**: Manages Category Names, Transaction Types, And Vector Icon Mappings.
4. **`TransactionEntryTable`**: Logs Transaction Entries With Amount In Cents, Account IDs, Category IDs, Dates, And Notes.
5. **`BudgetTable`**: Stores Monthly Category Budget Limits In Cents And Target Months.

---

## 🚀 Getting Started & Local Build Instructions

### Prerequisites
- **Flutter SDK**: `^3.27.0` (Dart `^3.6.0`)
- **Android Studio**: Android SDK 36 (Build Tools 34.0.0+)
- **Java Development Kit (JDK)**: JDK 17 Or JDK 21

### Step 1: Clone Repository
```bash
git clone https://github.com/i8o8i-Developer/Moneta-Trail-Finance-Tracker-Application.git
cd Moneta-Trail-Finance-Tracker-Application
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Run Database Code Generation (Optional)
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Step 4: Run Application Locally
```bash
flutter run
```

---

## 📦 Building Production Release Binaries

### Build Signed Release APK
```bash
flutter build apk --release
```
- **Output File Path**: `build/app/outputs/flutter-apk/app-release.apk`

### Build Signed Release App Bundle (.aab For Google Play Store)
```bash
flutter build appbundle --release
```
- **Output File Path**: `build/app/outputs/bundle/release/app-release.aab`

---

## 🔑 Production Release Signing Information

- **App Package Name**: `com.moneta.trail`
- **Keystore File**: `android/app/upload-keystore.jks`
- **Key Alias**: `upload`
- **SHA-1 Fingerprint**: `9C:21:FE:89:BC:A7:95:00:0F:B3:B0:79:FE:95:6A:D7:7F:17:1B:DB`
- **SHA-256 Fingerprint**: `28:0B:EC:04:D8:05:D4:B6:23:84:32:D1:6D:CF:FF:B8:3D:B3:61:C7:6D:35:0C:4B:2A:BF:AE:F2:C7:6B:4B:FA`

---

## 📄 License & Ownership

Designed And Developed For **Moneta Trail Finance Tracker**. Distributed Under The MIT License.

```text
Copyright (c) 2026 i8o8i-Developer. All Rights Reserved.
```