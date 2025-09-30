# Environment Setup for GoLocal App

## Environment Variables Setup

This project uses environment variables to keep sensitive API keys and configuration secure. Follow these steps to set up your environment:

### 1. Copy Environment Template
```bash
cp .env.example .env
```

### 2. Configure Environment Variables

Edit the `.env` file with your actual values:

```env
# Supabase Configuration
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Google Maps API Key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key

# App Configuration
APP_NAME=GoLocal
APP_VERSION=1.0.0
```

### 3. Required API Keys

#### Supabase Setup
1. Go to [Supabase](https://supabase.com)
2. Create a new project
3. Go to Settings → API
4. Copy the Project URL and anon public key
5. Update your `.env` file

#### Google Maps API Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Enable the following APIs:
   - Maps SDK for Android
   - Places API
   - Geocoding API
3. Create credentials (API Key)
4. Update your `.env` file
5. For Android: Update `android/app/src/main/AndroidManifest.xml` with your API key

### 4. Android Configuration

Replace `YOUR_GOOGLE_MAPS_API_KEY` in `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="your_actual_google_maps_api_key" />
```

### 5. Security Notes

- **Never commit your `.env` file** - it's already in `.gitignore`
- Always use the `.env.example` template for sharing
- Rotate API keys regularly
- Use different keys for development and production

### 6. Running the App

After setting up environment variables:

```bash
flutter pub get
flutter run
```

The app will automatically load your environment configuration on startup.

## Troubleshooting

### Common Issues

1. **Environment variables not loading**
   - Ensure `.env` file is in the project root
   - Check that `flutter_dotenv` dependency is installed
   - Verify the `.env` file is included in `pubspec.yaml` assets

2. **Google Maps not working**
   - Verify your API key is correct
   - Check that required APIs are enabled in Google Cloud Console
   - Ensure billing is enabled for your Google Cloud project

3. **Supabase connection issues**
   - Verify your Supabase URL and anon key
   - Check that your Supabase project is running
   - Ensure RLS policies are properly configured

## Development vs Production

For production deployment, use environment-specific configuration files or your deployment platform's environment variable management system.