# 🚀 Mini TaskHub
### Flutter + Supabase Task Manager

**Mini TaskHub** is a streamlined task management application built with **Flutter** and powered by **Supabase**. It demonstrates a robust full-stack mobile experience including secure authentication, real-time database interactions, and a responsive Material 3 UI.

---

## 📱 Features

| Category | Description |
| :--- | :--- |
| **🔐 Authentication** | Email/Password & Google Auth support, persistent sessions, and secure profile management. |
| **✅ Task Management** | Full CRUD operations (Create, Read, Update, Delete) synced with a PostgreSQL database. |
| **🎨 UI & UX** | Responsive layout, Material 3 design, Light/Dark theme support, and custom reusable widgets. |
| **👤 Profile** | View/Edit profile details, theme toggling, and secure logout functionality. |

---

## 🏗 App Architecture

The project follows a **Service + Provider** architecture to ensure a clean separation of concerns.

* **UI Layer:** Modular screens for `Auth`, `Dashboard`, and `Profile`.
* **Service Layer:** Business logic for Auth, Tasks, and Profiles.
* **API Layer:** Centralized `SupabaseService` for all backend communication.
* **Storage Layer:** `AuthGlobal` (SharedPreferences) for local session persistence.

---

## ⚙️ Backend Setup (Supabase)

### 1. Database Schema
Run the following in your **Supabase SQL Editor** to set up the necessary tables:

```sql
-- Profiles table
create table profiles (
  id uuid primary key references auth.users(id),
  email text,
  name text,
  created_at timestamptz default now()
);

-- Tasks table
create table tasks (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid references auth.users(id),
  title text,
  completed boolean default false,
  created_at timestamptz default now()
);
```

2. Row Level Security (RLS)

Enable RLS on both tables. For the tasks table, apply the following policy to ensure users only see their own data:

```
create policy "Users manage their tasks"
on tasks
for all
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
```

2. Automation Trigger

Automatically create a profile entry when a new user signs up:

```
create function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email)
  values (new.id, new.email);
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
  ```
  
🛠 Installation & Setup

1) Clone & Install

```
git clone https://github.com/yourusername/mini-taskhub.git
cd mini-taskhub
flutter pub get
```

2) Environment Config

Update main.dart with your credentials from Project Settings > API:

```
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

3) Run
```
flutter run
```
🔄 Development Tips
```
Hot Reload (r): Use for UI tweaks and styling. Maintains app state.

Hot Restart (R): Use when modifying main.dart initialization or Provider state logic.
```
👨‍💻 Author
```
Vishnu V
Flutter Developer
```

  
