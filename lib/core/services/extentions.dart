import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress/video_compress.dart';

import 'app_translations/app_translations.dart';
import 'routing/navigation_service.dart';
import 'service_locator/dependency_injection.dart';

Future<File> compressImage(File file) async {
  var raw = file.readAsBytesSync();
  var decodeImage = await decodeImageFromList(raw);

  late int _neoWidth, _neoHeight;

  const _refWidth = 320;
  const _refHeight = 240;

  if (decodeImage.height > decodeImage.width) {
    _neoWidth = _refWidth;
    _neoHeight = (decodeImage.height * _refWidth / decodeImage.width).round();
  } else {
    _neoWidth = (decodeImage.width * _refHeight / decodeImage.height).round();
    _neoHeight = _refHeight;
  }

   var _result = await FlutterImageCompress.compressWithList(
      file.readAsBytesSync(),
      minHeight: _neoHeight,
      minWidth: _neoWidth,
      quality: 70,
      
    );
   File _compressedFile = File(file.path);
  await _compressedFile.writeAsBytes(_result);
  return _compressedFile;
}

Future<File> compressVideo(File file) async {
  if (!VideoCompress.isCompressing) {
    MediaInfo? mediaInfo = await VideoCompress.compressVideo(
      file.path,
      includeAudio: false,
      deleteOrigin: false,
      quality: VideoQuality.DefaultQuality,
    );
    return mediaInfo!.file!;
  } else {
    return file;
  }
}

String getToday() {
  //'T'HH:mm:ss
  DateTime currentDate = DateTime.now();
  String today = DateFormat("yyyy-MM-dd").format(currentDate);
  String date = "${today}T00:00:00";
  return date;
}

String getNowDate() {
  //'T'HH:mm:ss
  DateTime currentDate = DateTime.now();
  String today = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS").format(currentDate);
  return today;
}

enum FileTypeValue {
  image,
  video,
  other,
}

extension DurationExtension on Duration {
  String fromatTimeDuration() {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(inSeconds.remainder(60));
    return "${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

extension ImageToBase64Extension on File {
  String toBase64() {
    List<int> imageBytes = readAsBytesSync();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}

extension StringExtension on String {
  String getFileExtension() {
    final ext = path.extension(this).toLowerCase();

    return ext.replaceAll('.', '');
  }

  String getFileName() {
    final ext = path.basenameWithoutExtension(this);
    return ext;
  }

  FileTypeValue getFileType() {
    final ext = path.extension(this).toLowerCase();

    // List of known image extensions
    final imageExtensions = ['.png', '.jpg', '.jpeg', '.gif', '.bmp'];

    // List of known video extensions
    final videoExtensions = ['.mp4', '.avi', '.mov', '.wmv', '.flv', '.mkv'];

    if (imageExtensions.contains(ext)) {
      return FileTypeValue.image;
    } else if (videoExtensions.contains(ext)) {
      return FileTypeValue.video;
    } else {
      return FileTypeValue.other;
    }
  }

  String getLastThreeCharacters() {
    // Ensure the path is not null or empty and has at least 3 characters
    if (length < 3) {
      return this; // Return the original path if it is null, empty, or has less than 3 characters
    }

    // Calculate the start and end indices to get the last 3 characters
    int startIndex = length - 3;
    int endIndex = length;

    // Use the substring() method to extract the last 3 characters
    String lastThreeCharacters = substring(startIndex, endIndex);

    return lastThreeCharacters;
  }

  String getNumberFromString() {
    RegExp numberRegExp = RegExp(r'\d+');
    Match? match = numberRegExp.firstMatch(this);
    if (match != null) {
      return match.group(0)!;
    }
    return '';
  }

  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String emptyNull() {
    if (contains("null")) {
      return "";
    } else {
      return this;
    }
  }

  String converStringToDate({String? format = "dd/MM/yyyy"}) {
    //String originalDate = "2022-09-12T00:00:00";
    DateTime dateTime = DateTime.parse(this);
    String formattedDate = DateFormat(format ?? 'dd/MM/yyyy').format(dateTime);
    return formattedDate;
  }

  String convertToFormat(String format) {
    DateTime originalDate = DateFormat("dd/MM/yyyy").parse(this);
    return DateFormat(format).format(originalDate);
  }

  bool get dateIsPast {
    DateTime date = DateTime.parse(this);
    DateTime currentDate = DateTime.now();

    if (date.isAfter(currentDate)) {
      // "The date $this is in the future.";
      return false;
    } else if (date.isBefore(currentDate)) {
      //return "The date $this is in the past.";
      return true;
    } else {
      // "The date $this is today.";
      return true;
    }
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension Localization on String {
  String localized() {
    return AppTranslations.of(context: sl<NavigationService>().getContext())!
        .text(this);
  }
}

extension IDValidator on String {
  bool isValidID() {
    List<int> digits = split('').map((e) => int.parse(e)).toList();

    int lastDigit = digits.removeLast();

    for (int i = 0; i < digits.length; i++) {
      int multiplier = i % 2 == 0 ? 1 : 2;
      digits[i] = digits[i] * multiplier;
    }

    String tempID = digits.join();

    List<int> tempIDList = tempID.split('').map((e) => int.parse(e)).toList();

    int tempIDSum = 0;

    for (int i = 0; i < tempIDList.length; i++) {
      tempIDSum += tempIDList[i];
    }

    int expectedDigit = 10 - (tempIDSum % 10);

    return (expectedDigit % 10) == lastDigit;
  }
}

Map<String, String> getJsonFromString(String s) {
  var kv = s.substring(0, s.length - 1).substring(1).split(",");
  final Map<String, String> pairs = {};

  for (int i = 0; i < kv.length; i++) {
    var thisKV = kv[i].split(":");
    pairs[thisKV[0].trim()] = thisKV[1].trim();
  }

  // var encoded = json.encode(pairs);

  return pairs;
}

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension DateTimeExtensions on DateTime {
  String toStringFormat(String format) {
    return DateFormat(format).format(this);
  }
}

extension Context on BuildContext {
  // Custom call a provider for reading method only
  // It will be helpful for us for calling the read function
  // without Consumer,ConsumerWidget or ConsumerStatefulWidget
  // Incase if you face any issue using this then please wrap your widget
  // with consumer and then call your provider

  T read<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }
}
