// To parse this JSON data, do
//
//     final placesDetail = placesDetailFromJson(jsonString);

import 'dart:convert';

PlacesDetail placesDetailFromJson(String str) =>
    PlacesDetail.fromJson(json.decode(str));

String placesDetailToJson(PlacesDetail data) => json.encode(data.toJson());

class PlacesDetail {
  final List<dynamic>? htmlAttributions;
  final Result? result;
  final String? status;

  PlacesDetail({
    this.htmlAttributions,
    this.result,
    this.status,
  });

  factory PlacesDetail.fromJson(Map<String, dynamic> json) => PlacesDetail(
        htmlAttributions: json["html_attributions"] == null
            ? []
            : List<dynamic>.from(json["html_attributions"]!.map((x) => x)),
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "html_attributions": htmlAttributions == null
            ? []
            : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "result": result?.toJson(),
        "status": status,
      };
}

class Result {
  final List<AddressComponent>? addressComponents;
  final String? adrAddress;
  final String? businessStatus;
  final CurrentOpeningHours? currentOpeningHours;
  final String? formattedAddress;
  final String? formattedPhoneNumber;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String? internationalPhoneNumber;
  final String? name;
  final OpeningHours? openingHours;
  final List<Photo>? photos;
  final String? placeId;
  final PlusCode? plusCode;
  final double? rating;
  final String? reference;
  final List<Review>? reviews;
  final List<String>? types;
  final String? url;
  final int? userRatingsTotal;
  final int? utcOffset;
  final String? vicinity;
  final String? website;
  final bool? wheelchairAccessibleEntrance;

  Result({
    this.addressComponents,
    this.adrAddress,
    this.businessStatus,
    this.currentOpeningHours,
    this.formattedAddress,
    this.formattedPhoneNumber,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.internationalPhoneNumber,
    this.name,
    this.openingHours,
    this.photos,
    this.placeId,
    this.plusCode,
    this.rating,
    this.reference,
    this.reviews,
    this.types,
    this.url,
    this.userRatingsTotal,
    this.utcOffset,
    this.vicinity,
    this.website,
    this.wheelchairAccessibleEntrance,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        addressComponents: json["address_components"] == null
            ? []
            : List<AddressComponent>.from(json["address_components"]!
                .map((x) => AddressComponent.fromJson(x))),
        adrAddress: json["adr_address"],
        businessStatus: json["business_status"],
        currentOpeningHours: json["current_opening_hours"] == null
            ? null
            : CurrentOpeningHours.fromJson(json["current_opening_hours"]),
        formattedAddress: json["formatted_address"],
        formattedPhoneNumber: json["formatted_phone_number"],
        geometry: json["geometry"] == null
            ? null
            : Geometry.fromJson(json["geometry"]),
        icon: json["icon"],
        iconBackgroundColor: json["icon_background_color"],
        iconMaskBaseUri: json["icon_mask_base_uri"],
        internationalPhoneNumber: json["international_phone_number"],
        name: json["name"],
        openingHours: json["opening_hours"] == null
            ? null
            : OpeningHours.fromJson(json["opening_hours"]),
        photos: json["photos"] == null
            ? []
            : List<Photo>.from(json["photos"]!.map((x) => Photo.fromJson(x))),
        placeId: json["place_id"],
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        rating: json["rating"]?.toDouble(),
        reference: json["reference"],
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(
                json["reviews"]!.map((x) => Review.fromJson(x))),
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
        url: json["url"],
        userRatingsTotal: json["user_ratings_total"],
        utcOffset: json["utc_offset"],
        vicinity: json["vicinity"],
        website: json["website"],
        wheelchairAccessibleEntrance: json["wheelchair_accessible_entrance"],
      );

  Map<String, dynamic> toJson() => {
        "address_components": addressComponents == null
            ? []
            : List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "adr_address": adrAddress,
        "business_status": businessStatus,
        "current_opening_hours": currentOpeningHours?.toJson(),
        "formatted_address": formattedAddress,
        "formatted_phone_number": formattedPhoneNumber,
        "geometry": geometry?.toJson(),
        "icon": icon,
        "icon_background_color": iconBackgroundColor,
        "icon_mask_base_uri": iconMaskBaseUri,
        "international_phone_number": internationalPhoneNumber,
        "name": name,
        "opening_hours": openingHours?.toJson(),
        "photos": photos == null
            ? []
            : List<dynamic>.from(photos!.map((x) => x.toJson())),
        "place_id": placeId,
        "plus_code": plusCode?.toJson(),
        "rating": rating,
        "reference": reference,
        "reviews": reviews == null
            ? []
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
        "url": url,
        "user_ratings_total": userRatingsTotal,
        "utc_offset": utcOffset,
        "vicinity": vicinity,
        "website": website,
        "wheelchair_accessible_entrance": wheelchairAccessibleEntrance,
      };
}

class AddressComponent {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent({
    this.longName,
    this.shortName,
    this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class CurrentOpeningHours {
  final bool? openNow;
  final List<CurrentOpeningHoursPeriod>? periods;
  final List<String>? weekdayText;

  CurrentOpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });

  factory CurrentOpeningHours.fromJson(Map<String, dynamic> json) =>
      CurrentOpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null
            ? []
            : List<CurrentOpeningHoursPeriod>.from(json["periods"]!
                .map((x) => CurrentOpeningHoursPeriod.fromJson(x))),
        weekdayText: json["weekday_text"] == null
            ? []
            : List<String>.from(json["weekday_text"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "open_now": openNow,
        "periods": periods == null
            ? []
            : List<dynamic>.from(periods!.map((x) => x.toJson())),
        "weekday_text": weekdayText == null
            ? []
            : List<dynamic>.from(weekdayText!.map((x) => x)),
      };
}

class CurrentOpeningHoursPeriod {
  final PurpleClose? close;
  final PurpleClose? open;

  CurrentOpeningHoursPeriod({
    this.close,
    this.open,
  });

  factory CurrentOpeningHoursPeriod.fromJson(Map<String, dynamic> json) =>
      CurrentOpeningHoursPeriod(
        close:
            json["close"] == null ? null : PurpleClose.fromJson(json["close"]),
        open: json["open"] == null ? null : PurpleClose.fromJson(json["open"]),
      );

  Map<String, dynamic> toJson() => {
        "close": close?.toJson(),
        "open": open?.toJson(),
      };
}

class PurpleClose {
  final DateTime? date;
  final int? day;
  final String? time;

  PurpleClose({
    this.date,
    this.day,
    this.time,
  });

  factory PurpleClose.fromJson(Map<String, dynamic> json) => PurpleClose(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "day": day,
        "time": time,
      };
}

class Geometry {
  final Location? location;
  final Viewport? viewport;

  Geometry({
    this.location,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        viewport: json["viewport"] == null
            ? null
            : Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "viewport": viewport?.toJson(),
      };
}

class Location {
  final double? lat;
  final double? lng;

  Location({
    this.lat,
    this.lng,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  final Location? northeast;
  final Location? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: json["northeast"] == null
            ? null
            : Location.fromJson(json["northeast"]),
        southwest: json["southwest"] == null
            ? null
            : Location.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}

class OpeningHours {
  final bool? openNow;
  final List<OpeningHoursPeriod>? periods;
  final List<String>? weekdayText;

  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayText,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
        openNow: json["open_now"],
        periods: json["periods"] == null
            ? []
            : List<OpeningHoursPeriod>.from(
                json["periods"]!.map((x) => OpeningHoursPeriod.fromJson(x))),
        weekdayText: json["weekday_text"] == null
            ? []
            : List<String>.from(json["weekday_text"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "open_now": openNow,
        "periods": periods == null
            ? []
            : List<dynamic>.from(periods!.map((x) => x.toJson())),
        "weekday_text": weekdayText == null
            ? []
            : List<dynamic>.from(weekdayText!.map((x) => x)),
      };
}

class OpeningHoursPeriod {
  final FluffyClose? close;
  final FluffyClose? open;

  OpeningHoursPeriod({
    this.close,
    this.open,
  });

  factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) =>
      OpeningHoursPeriod(
        close:
            json["close"] == null ? null : FluffyClose.fromJson(json["close"]),
        open: json["open"] == null ? null : FluffyClose.fromJson(json["open"]),
      );

  Map<String, dynamic> toJson() => {
        "close": close?.toJson(),
        "open": open?.toJson(),
      };
}

class FluffyClose {
  final int? day;
  final String? time;

  FluffyClose({
    this.day,
    this.time,
  });

  factory FluffyClose.fromJson(Map<String, dynamic> json) => FluffyClose(
        day: json["day"],
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "time": time,
      };
}

class Photo {
  final int? height;
  final List<String>? htmlAttributions;
  final String? photoReference;
  final int? width;

  Photo({
    this.height,
    this.htmlAttributions,
    this.photoReference,
    this.width,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        height: json["height"],
        htmlAttributions: json["html_attributions"] == null
            ? []
            : List<String>.from(json["html_attributions"]!.map((x) => x)),
        photoReference: json["photo_reference"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "height": height,
        "html_attributions": htmlAttributions == null
            ? []
            : List<dynamic>.from(htmlAttributions!.map((x) => x)),
        "photo_reference": photoReference,
        "width": width,
      };
}

class PlusCode {
  final String? compoundCode;
  final String? globalCode;

  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class Review {
  final String? authorName;
  final String? authorUrl;
  final String? language;
  final String? originalLanguage;
  final String? profilePhotoUrl;
  final int? rating;
  final String? relativeTimeDescription;
  final String? text;
  final int? time;
  final bool? translated;

  Review({
    this.authorName,
    this.authorUrl,
    this.language,
    this.originalLanguage,
    this.profilePhotoUrl,
    this.rating,
    this.relativeTimeDescription,
    this.text,
    this.time,
    this.translated,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        authorName: json["author_name"],
        authorUrl: json["author_url"],
        language: json["language"],
        originalLanguage: json["original_language"],
        profilePhotoUrl: json["profile_photo_url"],
        rating: json["rating"],
        relativeTimeDescription: json["relative_time_description"],
        text: json["text"],
        time: json["time"],
        translated: json["translated"],
      );

  Map<String, dynamic> toJson() => {
        "author_name": authorName,
        "author_url": authorUrl,
        "language": language,
        "original_language": originalLanguage,
        "profile_photo_url": profilePhotoUrl,
        "rating": rating,
        "relative_time_description": relativeTimeDescription,
        "text": text,
        "time": time,
        "translated": translated,
      };
}
