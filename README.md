🚀 Mini TaskHub
Flutter + Supabase Task Manager


Mini TaskHub is a Flutter task management application that uses Supabase for authentication and database storage.
It allows users to sign up, log in, create tasks, manage tasks, and store data securely in Supabase.

The project demonstrates Flutter architecture, Supabase integration, state management, theming, and responsive UI design.

📱 Features
🔐 Authentication

Email / Password authentication using Supabase Auth

Google authentication support

Persistent user session

Profile management stored in Supabase

✅ Task Management

Users can:

Create tasks

Delete tasks

Mark tasks as completed

Edit tasks

Store tasks in Supabase PostgreSQL database

🎨 UI & UX

Responsive layout

Material 3 design

Light & Dark theme support

Smooth UI interactions

Custom reusable widgets

👤 Profile

View profile information

Edit profile details

Logout functionality

Theme toggle (Dark / Light)

🖼 Screenshots

Add screenshots of your app here.

Example structure:

assets/screenshots/
Splash Screen	Login Screen	Dashboard
(Add image)	(Add image)	(Add image)
🏗 App Architecture

The app follows a Service + Provider architecture.

UI Layer
│
├── AuthScreen
├── DashboardScreen
├── ProfileScreens
│
Service Layer
│
├── AuthService
├── TaskService
├── ProfileService
│
API Layer
│
└── SupabaseService
│
Storage Layer
│
└── AuthGlobal (SharedPreferences)

This separation ensures:

Maintainable code

Clean state management

Clear responsibility separation

📂 Project Structure
lib/
│
├── main.dart
│
├── pages/
│   ├── auth/
│   │   ├── auth_screen.dart
│   │   ├── auth_service.dart
│   │   └── auth_ui_def.dart
│   │
│   ├── dashboard/
│   │   ├── dashboard_screen.dart
│   │   ├── task_service.dart
│   │   └── task_ui_def.dart
│   │
│   ├── profile/
│   │   ├── profile_view_screen.dart
│   │   └── profile_edit_screen.dart
│   │
│   └── services/
│       └── supabase_service.dart
│
├── utils/
│   ├── auth_global.dart
│   ├── response_handler.dart
│   ├── widget_factory.dart
│   ├── flexible_sized_button.dart
│   ├── themes.dart
│   └── app_color_scheme.dart
⚙️ Supabase Setup
1️⃣ Create Supabase Project

Go to

https://supabase.com

Create a new project.

2️⃣ Enable Authentication

Dashboard → Authentication → Providers

Enable:

Email / Password

(Optional) Disable email confirmation during development.

3️⃣ Create Database Tables
profiles table
create table profiles (
  id uuid primary key references auth.users(id),
  email text,
  name text,
  created_at timestamptz default now()
);
tasks table
create table tasks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  title text,
  completed boolean default false,
  created_at timestamptz default now()
);
🔐 Row Level Security (RLS)

Enable RLS on both tables.

Profiles Policy
auth.uid() = id
Tasks Policy
create policy "Users manage their tasks"
on tasks
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
⚡ Automatic Profile Creation

Create a trigger so every new user automatically gets a profile.

Run this in Supabase SQL Editor:

create function public.handle_new_user()
returns trigger
language plpgsql
security definer
as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute procedure public.handle_new_user();
🛠 Setup Instructions
1️⃣ Clone the repository
git clone https://github.com/yourusername/mini-taskhub.git
2️⃣ Install dependencies
flutter pub get
3️⃣ Configure Supabase

Update the following values in main.dart.

await Supabase.initialize(
  url: YOUR_SUPABASE_URL,
  anonKey: YOUR_SUPABASE_ANON_KEY,
);

Find these values in:

Supabase Dashboard → Project Settings → API
4️⃣ Run the app
flutter run
🔁 Hot Reload vs Hot Restart
🔄 Hot Reload

Hot reload updates the UI without restarting the application.

Used for:

UI changes

Layout adjustments

Styling updates

Command:

r

Advantages:

Fast

Keeps application state

🔁 Hot Restart

Hot restart rebuilds the entire application.

Used for:

State management changes

Dependency changes

Initialization logic

Command:

R
🎥 Demo Video

Add your demo video here.

Example:

https://drive.google.com/your-demo-link
🔮 Future Improvements

Possible future enhancements:

Real-time task updates

Task categories

Push notifications

Offline mode

Task reminders

👨‍💻 Author

Vishnu V
Flutter Developer
