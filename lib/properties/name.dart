import 'package:flutter_contacts/vcard.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'name.freezed.dart';

part 'name.g.dart';

/// Structured name.
///
/// Name structure varies widely by country. See:
/// https://en.wikipedia.org/wiki/Personal_name#Structure
///
/// Data models such as those from Android and iOS are typically US-centric and
/// include middle name, prefix, suffix, etc. They also always include a
/// formatted displayed, which we recommend to use instead. That said, other
/// fields are included for compatibility, except for first and last names which
/// are common in most countries.
///
/// Since display name is always part of the top-level contact, it's not
/// included here.
///
/// Note that Android allows multiple names, while iOS allows only one. However
/// use cases for multiple names are debatable, especially since there is no
/// notion of "primary" name even on Android, and it is very common to see
/// multiple identical instances of the same name for the same contact. For all
/// those reasons, we only support one name per contact.
///
/// Note also that on iOS, nickname is included in the name fields (and again
/// only one is allowed), while on Android nickname is a separate data model and
/// one contact can have multiple nicknames, independent of their names. They
/// can also have distinct labels to indicate what type of nickname they are
/// (maiden name, short name, initials, default, other or any custom label). To
/// simplify, we only consider nickname as just another name field, and
/// disregard nickname labels.
///
/// | Field              | Android | iOS |
/// |--------------------|:-------:|:---:|
/// | first              | ✔       | ✔   |
/// | last               | ✔       | ✔   |
/// | middle             | ✔       | ✔   |
/// | prefix             | ✔       | ✔   |
/// | suffix             | ✔       | ✔   |
/// | nickname           | ✔       | ✔   |
/// | firstPhonetic      | ✔       | ✔   |
/// | lastPhonetic       | ✔       | ✔   |
/// | middlePhonetic     | ✔       | ✔   |
///
///

@freezed
abstract class Name with _$Name {
  const Name._();

  const factory Name({
    required String first,
    required String last,
    required String middle,
    required String prefix,
    required String suffix,
    required String nickname,
    required String firstPhonetic,
    required String lastPhonetic,
    required String middlePhonetic,
  }) = _Name;

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  List<String> toVCard() {
    // N (V3): https://tools.ietf.org/html/rfc2426#section-3.1.2
    // NICKNAME (V3): https://tools.ietf.org/html/rfc2426#section-3.1.3
    // N (V4): https://tools.ietf.org/html/rfc6350#section-6.2.2
    // NICKNAME (V4): https://tools.ietf.org/html/rfc6350#section-6.2.3
    var lines = <String>[];
    final components = [last, first, middle, prefix, suffix];
    if (components.any((x) => x.isNotEmpty)) {
      lines.add('N:' + components.map(vCardEncode).join(';'));
    }
    if (nickname.isNotEmpty) {
      lines.add('NICKNAME:' + vCardEncode(nickname));
    }
    return lines;
  }
}
