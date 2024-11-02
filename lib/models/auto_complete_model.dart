// To parse this JSON data, do
//
//     final autoCompleteModel = autoCompleteModelFromJson(jsonString);

import 'dart:convert';

AutoCompleteModel autoCompleteModelFromJson(String str) => AutoCompleteModel.fromJson(json.decode(str));

String autoCompleteModelToJson(AutoCompleteModel data) => json.encode(data.toJson());

class AutoCompleteModel {
    final List<Prediction>? predictions;
    final String? status;
  
    AutoCompleteModel({
        this.predictions,
        this.status,
    });

    factory AutoCompleteModel.fromJson(Map<String, dynamic> json) => AutoCompleteModel(
        predictions: json["predictions"] == null ? [] : List<Prediction>.from(json["predictions"]!.map((x) => Prediction.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "predictions": predictions == null ? [] : List<dynamic>.from(predictions!.map((x) => x.toJson())),
        "status": status,
    };
}

class Prediction {
    final String? description;
    final List<MatchedSubstring>? matchedSubstrings;
    final String? placeId;
    final String? reference;
    final StructuredFormatting? structuredFormatting;
    final List<Term>? terms;
    final List<String>? types;

    Prediction({
        this.description,
        this.matchedSubstrings,
        this.placeId,
        this.reference,
        this.structuredFormatting,
        this.terms,
        this.types,
    });

    factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        matchedSubstrings: json["matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
        placeId: json["place_id"],
        reference: json["reference"],
        structuredFormatting: json["structured_formatting"] == null ? null : StructuredFormatting.fromJson(json["structured_formatting"]),
        terms: json["terms"] == null ? [] : List<Term>.from(json["terms"]!.map((x) => Term.fromJson(x))),
        types: json["types"] == null ? [] : List<String>.from(json["types"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "matched_substrings": matchedSubstrings == null ? [] : List<dynamic>.from(matchedSubstrings!.map((x) => x.toJson())),
        "place_id": placeId,
        "reference": reference,
        "structured_formatting": structuredFormatting?.toJson(),
        "terms": terms == null ? [] : List<dynamic>.from(terms!.map((x) => x.toJson())),
        "types": types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
    };
}

class MatchedSubstring {
    final int? length;
    final int? offset;

    MatchedSubstring({
        this.length,
        this.offset,
    });

    factory MatchedSubstring.fromJson(Map<String, dynamic> json) => MatchedSubstring(
        length: json["length"],
        offset: json["offset"],
    );

    Map<String, dynamic> toJson() => {
        "length": length,
        "offset": offset,
    };
}

class StructuredFormatting {
    final String? mainText;
    final List<MatchedSubstring>? mainTextMatchedSubstrings;
    final String? secondaryText;

    StructuredFormatting({
        this.mainText,
        this.mainTextMatchedSubstrings,
        this.secondaryText,
    });

    factory StructuredFormatting.fromJson(Map<String, dynamic> json) => StructuredFormatting(
        mainText: json["main_text"],
        mainTextMatchedSubstrings: json["main_text_matched_substrings"] == null ? [] : List<MatchedSubstring>.from(json["main_text_matched_substrings"]!.map((x) => MatchedSubstring.fromJson(x))),
        secondaryText: json["secondary_text"],
    );

    Map<String, dynamic> toJson() => {
        "main_text": mainText,
        "main_text_matched_substrings": mainTextMatchedSubstrings == null ? [] : List<dynamic>.from(mainTextMatchedSubstrings!.map((x) => x.toJson())),
        "secondary_text": secondaryText,
    };
}

class Term {
    final int? offset;
    final String? value;

    Term({
        this.offset,
        this.value,
    });

    factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json["offset"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "offset": offset,
        "value": value,
    };
}
