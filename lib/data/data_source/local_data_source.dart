import '../network/error_handler.dart';
import '../response/responses.dart';

const cacheHomeKey = 'cacheHomeKey';
const cacheHomeKeyExpir = 60 * 1000;

abstract class LocalDataSource {
  Future<HomeResponse> getHomeData();

  Future<void> saveHomeToCache(HomeResponse homeResponse);

  void clearCache();
  void removeFromCache(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  // run time cache

  // Map<Key,Value>
  Map<String, CachedItem> cacheMap = Map();
  @override
  Future<HomeResponse> getHomeData() async {
    // get key
    CachedItem? cachedItem = cacheMap[cacheHomeKey];

    if (cachedItem != null && cachedItem.isCachedValid(cacheHomeKeyExpir)) {
      // return the response from cache
      return cachedItem.data;
    } else {
      // return an error
      throw ErrorHandler.handle(DataSource.CACHE_ERROR);
    }
  }

  @override
  Future<void> saveHomeToCache(HomeResponse homeResponse) async {
    //set key and value
    // key(cacheHomeKey)   =     value(homeDataResponse)
    cacheMap[cacheHomeKey] = CachedItem(homeResponse);
  }

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void removeFromCache(String key) {
    cacheMap.remove(key);
  }
}

class CachedItem {
  dynamic data;
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}

extension CachedItemExtension on CachedItem {
  bool isCachedValid(int expirationTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;

    bool isVaild = currentTime - cacheTime <= expirationTime;

    return isVaild;
  }
}
