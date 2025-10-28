// The different states your app's access can be in
enum AccessState {
  loading,        // Still checking
  offline,        // No internet connection
  accessGranted,  // Online and has access
  accessDenied    // Online but no access (paywall)
}
