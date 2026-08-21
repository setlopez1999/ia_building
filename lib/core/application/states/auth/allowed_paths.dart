enum AllowedPaths {
  initial(
    redirectPath: '/login',
    allowedPaths: [
      '/login',
      '/register',
      '/register-confirmation',
      '/change-password',
      '/terms',
      '/policies',
      '/'
    ],
  ),
  success(
    redirectPath: '/home',
    allowedPaths: [
      '/home',
      '/notifications',
      '/notifications-detail',
      '/player',
      '/channels',
      '/profile',
      '/plan',
      '/change-password',
      '/family-filter',
      '/search',
      '/tv-guide',
    ],
  );

  const AllowedPaths({
    required this.redirectPath,
    required this.allowedPaths,
  });

  final String redirectPath;
  final List<String> allowedPaths;
}