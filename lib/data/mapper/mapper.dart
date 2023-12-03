import '../../app/constants.dart';
import '../../app/extensions.dart';
import '../../domain/model/models.dart';
import '../response/responses.dart';

extension CustomerResponseMapper on CustomerResponse? {
  Customer toDomain() {
    return Customer(
        this?.id.orEmpty() ?? Constants.empty,
        this?.name.orEmpty() ?? Constants.empty,
        this?.numOfNotifications.orZero() ?? Constants.zero);
  }
}

extension ContactsResponseMapper on ContactsResponse? {
  Contacts toDomain() {
    return Contacts(
      this?.phone.orEmpty() ?? Constants.empty,
      this?.email.orEmpty() ?? Constants.empty,
      this?.link.orEmpty() ?? Constants.empty,
    );
  }
}

extension AuthenticationResponseMapper on AuthenticationResponse? {
  Authentication toDomain() {
    return Authentication(
      this?.customer.toDomain(),
      this?.contacts.toDomain(),
    );
  }
}

extension ForgotPasswordResponseMapper on ForgotPasswordResponse? {
  String toDomain() {
    return this?.support.orEmpty() ?? Constants.empty;
  }
}

extension ServiceResponseMapper on ServiceResponse? {
  Service toDomain() {
    return Service(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
    );
  }
}

extension BannersResponseMapper on BannersResponse? {
  BannerAd toDomain() {
    return BannerAd(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
      this?.link.orEmpty() ?? Constants.empty,
    );
  }
}

extension StoreResponseMapper on StoreResponse? {
  Stores toDomain() {
    return Stores(
      this?.id.orZero() ?? Constants.zero,
      this?.title.orEmpty() ?? Constants.empty,
      this?.image.orEmpty() ?? Constants.empty,
    );
  }
}

extension HomeResponseMapper on HomeResponse? {
  HomeObject toDomain() {
    List<Service> service = (this
                ?.data
                ?.services
                ?.map((serviceResponse) => serviceResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Service>()
        .toList();
    List<BannerAd> banners = (this
                ?.data
                ?.banners
                ?.map((bannersResponse) => bannersResponse.toDomain()) ??
            const Iterable.empty())
        .cast<BannerAd>()
        .toList();

    List<Stores> stores = (this
                ?.data
                ?.stores
                ?.map((storesResponse) => storesResponse.toDomain()) ??
            const Iterable.empty())
        .cast<Stores>()
        .toList();

    var data = HomeData(banners, service, stores);

    return HomeObject(data);
  }
}
