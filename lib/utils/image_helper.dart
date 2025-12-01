import '../services/api_service.dart';

class ImageHelper {
  /// Mengubah URL gambar menjadi URL yang bisa diakses langsung.
  /// Menangani link Google Drive dan menggunakan proxy server jika perlu.
  static String? getEffectiveImageUrl(String? originalUrl) {
    if (originalUrl == null || originalUrl.isEmpty) {
      return null;
    }

    String effectiveUrl = originalUrl;

    // 1. Handle Google Drive Links
    // Mengubah format "view" menjadi "direct download" agar bisa diambil gambarnya
    // Contoh: https://drive.google.com/file/d/FILE_ID/view -> https://drive.google.com/uc?export=view&id=FILE_ID
    if (effectiveUrl.contains('drive.google.com')) {
      final id = _getGoogleDriveFileId(effectiveUrl);
      if (id != null) {
        effectiveUrl = 'https://drive.google.com/uc?export=view&id=$id';
      }
    }

    // 2. Gunakan Proxy Server untuk menghindari masalah CORS (terutama di Web)
    // dan untuk memastikan gambar bisa di-load jika ada proteksi hotlinking.
    // Kita encode URL target agar aman saat dikirim sebagai query parameter.
    final encodedUrl = Uri.encodeComponent(effectiveUrl);
    return '${ApiService.baseUrl}/api/image-proxy?url=$encodedUrl';
  }

  /// Ekstrak File ID dari URL Google Drive
  static String? _getGoogleDriveFileId(String url) {
    // Pola 1: /file/d/FILE_ID/view
    final RegExp regExp1 = RegExp(r'/file/d/([a-zA-Z0-9_-]+)');
    final match1 = regExp1.firstMatch(url);
    if (match1 != null && match1.groupCount >= 1) {
      return match1.group(1);
    }

    // Pola 2: id=FILE_ID
    final RegExp regExp2 = RegExp(r'id=([a-zA-Z0-9_-]+)');
    final match2 = regExp2.firstMatch(url);
    if (match2 != null && match2.groupCount >= 1) {
      return match2.group(1);
    }

    return null;
  }
}
