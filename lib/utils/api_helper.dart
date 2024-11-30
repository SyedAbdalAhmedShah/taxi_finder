import 'dart:developer';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  final String placesApiKey = "AIzaSyDOTz4YJ1zDtUDmS7brw6hgCeYj91uq-5U";
  final String googleApiKey = "IzaSyDkUEyqm-ty8D_hpxB7SVQQuC62mk5W4is";

  final String googleMapBaseUrl = "https://maps.googleapis.com/maps/api/";
  final String autoCompleteApi = "place/autocomplete/json?input=";
  final String placeDetailApi = "place/details/json?place_id=";

  final String _type = "service_account";
  final String _projectId = "taxi-finder-93d36";
  final String _privateKeyId = "ba2f797b2e59cd49b908a215d20a0e6e5e9fe98c";
  final String _privatekey =
      "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCbIalOs6DVTOv/\n1talk2y5wEpix13xhzFa4qtB4HeCw/NuOnELhYNurLi2QAyyqFFtOfnKcTWfLsUU\nOcmEP5E9V3X8p9aupS88awQF6D0+JZ64hDyU5VO/ssbFHeAPtIdQqMrwFwf7Ci5T\nv2BbeMUq25Sw3gbozvj9SYpEJWYbnsbWzA6r7usn4v57JmgmvCxHeQyfA1UKMdCp\nh0svLEzwCBbp5euthzsZYO2tjZkTKh+aGS5lJLa9gxnoTCVKKd6hoJ8yiqI6Vufa\ng7ZlC6cun2MFAlM6Q6VMomnWsnjIYKyl33uBp3PMZQIG2bf8nmv/CVCBdGQT+boh\nj10GFlAVAgMBAAECggEAE6QP5Qx+FPNvv80KER2Yuu3bHSWDweQtfgXLzAPo7a/0\nfqS8kkpdqSIKItz6HpaL9KnN8/Egal6ICjcEyg8oSt1rbUkst6DnWZ1s/Xh5ZIhr\nz43Cg9GDKHawjt1o9GQVa8NrKjmoQ4L2+Zh10S75u6LgcQIzWr91q8/nRxh7FIzz\nxm4BDOOTZL5ECvGJ/JDrXDD0vLq2MEtKTM4rYvsW9uRluNOIi2AmUYDU4k9RFbaM\ntD+1sSEAT2s364/i/KrXiNCLg4LPMXodlxGhNDLFxf+tVVuRaRuPYo+6cu9KG0GY\nri/TpQp3QMPdWaH7+gFbmoWA1RI1A7JtdpEgWGPq0wKBgQDH3WKxKJ1EordmMk8Q\nmfYPoSaDS+6AclMPaZ/liNJnB5E89Sb+LGm5y/SQ3GCKNF2BubDJZ0l8O1V+OhGK\nkDkx73KA4AAFTxFn/Kz8srl1dSwOSZYXFsWhgf0WSxMd0nMXB8hDcnTNanv5RYak\nS60UNoCh81b9Wt4FwfDDLnyzMwKBgQDGs+BhS7QAA5GZsoJQb2O9jvEXKfjFwMAl\naOxnmrR7ssT7dIOl+aqC3wcffjjwio1LTj72ENsLmXiVx3EG6NdqW6LO+6pyVWEz\n/oFFP5yQwfel17uwC/PbVwmQ+8O6teMYs6gP4Lr2n4T5tu6p3eplz0Gp3P0Msq1e\n2Z+nE9TvlwKBgHj8UtnbNBhwR4Tdv27VRFaBvsaMGHw4uH8D+X8BLByiQBEeddQ3\nHmkSRaHLRcVjnZcByTqiA6HoaQBYNnYih/zqbe4Fqv2Lt4WzNyRhLFMl8t1TPkAL\n0ObLwWDVYWUUGAdA9sGdb4dJhnKG29Jo3QT3WTawD2CeuPfTRuNgKKxxAoGAFa8r\nnXKVgirhiNRiRETjrZwb01tROsN+NJbutZ+8coNf29ErTMGiSgXs0RMFQ7rbEIzJ\ncjEEto9ZCX9qZkaiu4iki9ILF88ZfIMZuGTowSNp0z9nzB6Bzj4BXUEcaxPOZLO2\nc4Ui4icma9n60a7WFaY4lED5nJkjMmatdZ5EbqECgYBVjpRh9n0bw5jOjJ6BH60H\n15s1qtklIZajlrHWviyol4dX+CmSbAyfvJ1RxKZCWOXez9h/kgJ9zGhoqRotnInF\nmYbl6XGj88LbcbyRM9rwgfDksp4wiFlLhiILzWguXrm5t2tOiA75svNua7/FoDvQ\nmJ3PBCuyZNGTq+JtpZmqGg==\n-----END PRIVATE KEY-----\n";
  final String _clientEmail =
      "firebase-adminsdk-yieha@taxi-finder-93d36.iam.gserviceaccount.com";
  final String _clientId = "111125702740360995191";
  final String _authUri = "https://accounts.google.com/o/oauth2/auth";
  final String _tokenUri = "https://oauth2.googleapis.com/token";
  final String _authProviderX509CertUrl =
      "https://www.googleapis.com/oauth2/v1/certs";
  final String _clientX509CertUrl =
      "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-yieha%40taxi-finder-93d36.iam.gserviceaccount.com";
  final String _universeDomain = "googleapis.com";

  Future<String> generateFCMAccessToken() async {
    final credentials = ServiceAccountCredentials.fromJson({
      "type": _type,
      "project_id": _projectId,
      "private_key_id": _privateKeyId,
      "client_email": _clientEmail,
      "private_key": _privatekey,
      "client_id": _clientId,
      "auth_uri": _authUri,
      "token_uri": _tokenUri,
      "auth_provider_x509_cert_url": _authProviderX509CertUrl,
      "client_x509_cert_url": _clientX509CertUrl,
      "universe_domain": _universeDomain
    });
    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    final client = await obtainAccessCredentialsViaServiceAccount(
        credentials, scopes, http.Client());
    final accessToken = client.accessToken.data;

    return accessToken;
  }
}
