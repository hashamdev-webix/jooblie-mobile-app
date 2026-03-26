import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<String> getServerKeyToken() async {
    final sccopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "jooblienotifactions",
        "private_key_id": "6d46bde0cfa0e43c185088732db777f56e48ca19",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCtRoTboJnC575r\nYh4HNwAVQPxHCD47A/xwvvw5iRGjAigQTj5QCw/DgBKTuMFnyrtAzHre9tllKQTy\nhanxfss/vEnNV41vEtLzN85iFF0+i1X+ziD9aqsaQIp1f9Fzdpe7J6rFDy2ZZEel\nkkAYbsCaMpl2syevFPwAoBFNqBy7usaBwuE9Vs1ycB5RqAlsLWP+OY27j5JVUc+A\nS2clWNUlLEqOR1EDWKo3Uu3LCCZP5zyR/tggLjAYS14v1fmeAGZVTJijdqzTErh7\no6Z2IHcZhf4Rvhq+cuY1/oX15iAzjYVIzFtuA5eh6I8eG1117LvdvUGKaudGnFPj\nYB38eik7AgMBAAECggEAMs3z42911fNb3iFhG41xTUoGDg+pK2WSTT56NqZtUOWv\neIRwecicgR5alAx+TJ/hAnFR73DiMepyhGdTejbKgjADVZ0/n1seFej9br14z39M\nIg8vFg6CB4r37dahw2B4wYuyYt/95zVDWpUEjQVgHHYMkAScdJXLA6XrHOFXN2Vj\nBuckS2HEQJVG254ItUZdlJLlGDA+Xq0AmnlTBLSDoDH98vgTWS8BIZ0PRq9M61wV\nh4hSdmAdbuWfYwQgn0oSZdZihlMGNpYo+NJWjFjsQZWmXjJwNaddXNQXCCMmZ1Ry\n7/mW76Q8uLGZrWyNzu2J1bvqSGsr7qxuIT6WuL+nVQKBgQDXtr+wlG6SaRbZsQEB\nHLArlDrEnnE4GZQKaSu/SOwd8h7QR2hfeqrRcQXpSD7yeNvOoEKavWa6sG42OcTC\nSv1wrvUStfWjASEyUvLeiPt0ifarz7O4t/k2m5KvyhsSfANQWQnOjME+u07YvXze\nUnCwUGJCGYQ24T2L2yUiTuZWtQKBgQDNosvHYmxZTP5jjqzSzYvgi7jA03QaO5b7\n8I/6fL3RrpJEvZaJp4C5xXqdmO1TRcMK75zCM+Hz/yeDJU8VlgBmLh18NMXE39Be\nuyQ6wE0YpJIgWNMiqyXoHXFY7CfMVHtXheKUN7NN+HR/XIvGezPTm2aZ/5tFnGTy\nGIp+IogGLwKBgGCgxztlMia5lnfLd0S1QiEzVCPxSYw0wQDs3aDhHIvJgo4P/qwO\neeg59cjrCO96vhPP7CX+w77K+4Ok2wOhrefFJ5jLE46CGgm96HdQ6zrn9iw+bSZI\nmwUgKVQ/d2MPVDiwudjhakscgpRKRV4dlccVKv6rCXO/797vOrIkn7+lAoGAEgKs\nLm5kZv3jWfzpDh2KnsQeDmV2ycVmV/Kd6aZ7SZ4smXCxeqT9FUhCkQMP5jc5+f86\nj5fTtncmksn1v0JADrMDShmlKLUhnuptJegp2HqxgbvF4kdzLn1FrDAi3DaaBvRm\n/+xQ/AdCzNTiOSQZSfNWbS6B/vrPrJSRrLKBj2kCgYBcRmHTLf/kfaYZhO+/LeBI\nyCFuXjEhb7vum8qrmyYCXPGb5WORF0cDMet4J8odHd/8NUsHESjaUwdR1VmSTT1q\n8SON9Q/DdPpuRO+6lkdOGYmS/6P2uaGPk50kV4vZY1r/ContUVn5T/iruSNeevit\n1xJoxTJIbtYOUrJzmHfJgA==\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@jooblienotifactions.iam.gserviceaccount.com",
        "client_id": "101065140354953200538",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40jooblienotifactions.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      }),
      sccopes,
    );

    final accessServerKey = client.credentials.accessToken.data;
    return accessServerKey;
  }
}
