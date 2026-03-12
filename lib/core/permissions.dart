/// Central permissions class. Add new permission checks here as features grow.
/// Usage: Permissions.of(role).canSeeAllLocations
class Permissions {
  final String role;
  const Permissions._(this.role);

  factory Permissions.of(String role) => Permissions._(role);

  // --- Location access ---
  bool get canSeeAllLocations => role == 'ADMIN';
  bool get hasAssignedLocationsOnly => role == 'CC_MANAGER' || role == 'AREA_MANAGER';

  // --- GRN ---
  bool get canCreateGRN => _any(['CC_MANAGER', 'ADMIN']);
  bool get canEditGRN => _any(['CC_MANAGER', 'ADMIN']);
  bool get canViewAllGRNs => role == 'ADMIN';

  // --- Dispatch ---
  bool get canDispatch => _any(['CC_MANAGER', 'ADMIN', 'AREA_MANAGER']);

  // --- Farmers ---
  bool get canManageFarmers => _any(['CC_MANAGER', 'ADMIN']);

  // --- Reports ---
  bool get canViewReports => _any(['ADMIN', 'AREA_MANAGER']);

  bool _any(List<String> roles) => roles.contains(role);
}
