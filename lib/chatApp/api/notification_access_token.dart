import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';

class NotificationAccessToken {
  static String? _token;

  //to generate token only once for an app run
  static Future<String?> get getToken async => _token ?? await _getAccessToken();

  // to get admin bearer token
  static Future<String?> _getAccessToken() async {
    try {
      const fMessagingScope =
          'https://www.googleapis.com/auth/firebase.messaging';

      final client = await clientViaServiceAccount(
        // To get Admin Json File: Go to Firebase > Project Settings > Service Accounts
        // > Click on 'Generate new private key' Btn & Json file will be downloaded

        // Paste Your Generated Json File Content
        ServiceAccountCredentials.fromJson({
  "type": "service_account",
  "project_id": "sellkaroindia-268ac",
  "private_key_id": "45f3dd0a0217de7f61e21faf92500534310b7c2d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCYHOcM7u1lHjc/\n0dNVsitgctpmFvkX69IIdksmogpWSuLvWAfmmbHmLCEVJBcidSi0kumZ1kCxhgRV\nZ8dCVGblVwp885bhzCRMUeRiu1+MJzhQKio4agx4E3O185M525m/fOJ28sORAGzi\nn4uUUtboYm5RFp+o55uhw0cn9nq5EjIQ6oJT2cNEvGiaArPoM4ZN7mPUR7hzF4Cf\ntnjTsZd+pTbYIfZCAo5SIi5kA8VDcdbaLBhiJEIrxosRojIRk+KUX62kz8Fn1MVl\nTlosRVZWBETJt7uC6/t4H4r1z+IjEG/NNv+IIvwdbqFGUt7KFMX+vwNnI4H5f74s\nhHFIloAdAgMBAAECggEADJc9ML7eJjk4DYT1Xz8zg/TodabVJiZo6OERxg2HmYOd\nVn5iOQjjxs+ZoBcFVd7TaGROCGPJpb1tbRGoAVTcfNiVj6jXW7Kla9kjdGCvafnH\nxCrupQ4cy3D2FPYnwOmXx60zTvE36tqu00YC1wYnBRk7VGRGVu7E3RY9ijtGsTww\nPlp4+SUvFaLxbddl8UGlWyEBFzyCheWU1W4bMYy97mfOQIf7nARC+U/wP0VRkj0j\n6wVZRRl/u5JbvUniiVj0YG6SQgk7cqdo4bdXJd6FsNGWhLco7897SAL6R+dkl2AR\nFiqJbWa9nIywRfPoooCuJK99dlYkF5+OfxBWKB5YaQKBgQDUKQGiHhmjcR1sW1qu\n99C8Zt4u/F8S4Gb4ZWHe/RWJd0QdovwmmlcI4/n7dL1w7NTp3lbm6fPlFIqe+p/O\nnMhofzLWx1T9aIgzKWrhk7XU0S/TNnC3IaTA4GbZgqsMpoq56PfZOpotCbg3np1c\ngleWkFvT4pZOKEZOodTLiF5InwKBgQC3i3lotPDYz7fyXED2Z4yKUHkOavo2pyp5\nDBndZtzDeXhZRzoQx5v2ziI17ekyKS5M9t10LXaz/8J7ofW3xu7CCDMpdCPUxX7u\nXLk9pLhdBgMhxnrhsgT7oZaLPub1Mc1ji+vcBpzlcq4JYox0q2i2fiKm07H952O+\n04LSDulxwwKBgQCsrouzxkgb7c+DCIAw9WeiUR/6olNH6/ojp3EXrGrBLp/0d1pA\nmVLJ27T2ZDhlF37cs6mL3VQ0WpnReDBmXNoJo65ffnLApzpkWguyeyV+iJ0ijqcD\nh5CvpHZSB7btXwh+9Q32c2pVyhl0u9ddGoHr/KehOEYaa1F+Yt3uo5oKBQKBgQCl\nczBp1lEU34ltCwP0GbtyIsA84unRwjZjDylxjnuKKUD3GWGaJpTMkVv9SQxgjwaR\nkiZlx2WtM+tYDtK0arpmZYXY5Dw4XB7jNuo0Svt1vymrlILIV/Rt72cI9hazB8Wg\n6kwd9kgP/KQtCYyazriBaIpL36AexCoBph/SwmZkiQKBgDG2MxO96UQNKxfjSLP2\nr5LWb2uq48b8iiRK156OnST3Dm7ULn0bcw6AMRHY0mrXhODqvuYN54Jx5sdzbDmH\n7bBnkA/VZ+ei69r3kFdefTII/ECfsv+lCCCdaO1AqH0jl4Rf3tE7b/jJOClWTe1A\nc52SVlOuQQ2n8v/1Qa3qj4ln\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-aeaqg@sellkaroindia-268ac.iam.gserviceaccount.com",
  "client_id": "100820546030959574803",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-aeaqg%40sellkaroindia-268ac.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
        }),
        [fMessagingScope],
      );

      _token = client.credentials.accessToken.data;

      return _token;
    } catch (e) {
      log('$e');
      return null;
    }
  }
}


