// import 'dart:developer';
// import 'dart:io';

// import 'package:ftpconnect/ftpconnect.dart';
// import 'package:get/get.dart';

// class FTPConnection extends GetxController {
//   late FTPConnect _ftpConnect;

//   @override
//   void onInit() {
//     super.onInit();
//     _ftpConnect = FTPConnect(
//       "https://www.mymultiplex.net/images/",
//       // user: "",
//       // pass: "",
//       showLog: true,
//     );
//   }

//   ///mock a file for the demonstration example
//   Future<File> _fileMock({fileName = 'FlutterTest.txt', content = ''}) async {
//     final Directory directory = Directory('/test')..createSync(recursive: true);
//     final File file = File('${directory.path}/$fileName');
//     await file.writeAsString(content);
//     return file;
//   }

//   Future<void> uploadWithRetry() async {
//     try {
//       File fileToUpload = await _fileMock(
//           fileName: 'uploadwithRetry.txt', content: 'uploaded with Retry');
//       log('Uploading ...');
//       await _ftpConnect.connect();
//       await _ftpConnect.changeDirectory('upload');
//       bool res =
//           await _ftpConnect.uploadFileWithRetry(fileToUpload, pRetryCount: 2);
//       log('file uploaded: ${res ? 'SUCCESSFULLY' : 'FAILED'}');
//       await _ftpConnect.disconnect();
//     } catch (e) {
//       log('Uploading FAILED: ${e.toString()}');
//     }
//   }
// }
