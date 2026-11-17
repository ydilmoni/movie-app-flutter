String formatDate(String isoDate) {
  if (isoDate.isEmpty) return '';
  return isoDate.split('-').reversed.join('.');
}