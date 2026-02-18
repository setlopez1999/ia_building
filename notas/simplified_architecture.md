# Simplified Architecture for Small Projects

The **Clean Architecture** used in your current project is excellent for scaling, but for small projects (MVP, simple CRUD, prototypes), it can be **overkill**. The "boilerplate" cost (UseCases, separate Repositories, DTO vs. Entity) might slow you down.

## When to use what?

| Feature | Clean Architecture (Large) | Feature-First (Small) |
| :--- | :--- | :--- |
| **Organization** | By Layer (Domain, Infra, UI) | By Feature (Login, Profile, Home) |
| **Logic** | Separated in UseCases | Inside Riverpod Notifiers |
| **Models** | DTO -> Entity conversion | Single Model (Freezed) |
| **Speed** | Lower (Initial setup is slow) | Higher (Immediate results) |

---

## The "Feature-First" Structure

In a small project, instead of global layers, group everything related to a feature in the same folder.

```text
lib/
├── features/
│   ├── news_feed/
│   │   ├── models/        # Freezed models for this feature
│   │   ├── providers/     # Keep state logic here (Notifiers)
│   │   ├── repositories/  # Direct API calls (Dio)
│   │   └── widgets/       # Screens and components
├── shared/                # Common styles, providers, and utils
└── main.dart
```

## Mini Implementation Walkthrough

### 1. The Model (Freezed)
No need for separate Entities/DTOs. One model does it all.
```dart
@freezed
class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
  }) = _Post;
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
```

### 2. The Repository (Direct)
The Repository communicates directly with the API. No interface needed for MVPs.
```dart
class NewsRepository {
  final Dio dio = Dio();
  Future<List<Post>> getPosts() async {
    final res = await dio.get('https://api.example.com/posts');
    return (res.data as List).map((e) => Post.fromJson(e)).toList();
  }
}
```

### 3. The Provider (Simplified)
The Notifier calls the Repository **directly**, skipping the "UseCase" layer.
```dart
@riverpod
class NewsFeed extends _$NewsFeed {
  @override
  FutureOr<List<Post>> build() {
    return NewsRepository().getPosts(); // Direct call
  }
}
```

## Why this is better for small apps?
- **Fewer files**: You don't need 10 files just to show a list of items.
- **Easier focused updates**: If you change the "News" UI, everything related is in the same folder.
- **Maintainable**: Since you still use **Riverpod** and **Freezed**, you maintain type safety and reactivity without the architectural weight.
