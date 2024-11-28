// Conditional imports based on the platform
export 'download_utils_mobile.dart' 
    if (dart.library.html) 'download_utils_web.dart';
