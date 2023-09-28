class WhatsPathLink {
  static bool isAssetPath(String path) {
    // Comprueba si el path comienza con "assets/"
    return path.startsWith('assets/');
  }

  static bool isInternetLink(String path) {
    // Comprueba si el path comienza con "http://" o "https://"
    return path.startsWith('http://') || path.startsWith('https://');
  }
}
