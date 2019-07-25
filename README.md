# Log Viewer
Please see [Flutter Web Repo](https://github.com/flutter/flutter_web) to see how to setup flutter web and monitor [Flutter Web Homepage](https://flutter.dev/web) to migrate to a release version of Flutter Web when it is out of beta phase.

## Server Configs
Contents in `lib/config/config.dart`, js in `web/index.html` and `web/scripts/verify_user.php` need to be modified at the same time.

## Other Note
Server ran by `webdev serve` of flutter is currently not able to excecute php scripts on http request. Workaround: Putting scripts on an real server and/or use `webdev build` in combination with other web servers.
