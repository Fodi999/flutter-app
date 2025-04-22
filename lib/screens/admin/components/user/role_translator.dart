String translateRoleToEN(String role) {
  switch (role) {
    case 'повар':
      return 'Chef';
    case 'курьер':
      return 'Courier';
    case 'официант':
      return 'Waiter';
    case 'admin':
      return 'Admin';
    case 'user':
    default:
      return 'User';
  }
}
