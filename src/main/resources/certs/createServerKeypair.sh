PASS="mule12345"
APP="ng-example-api"
HOST="localhost"
ALTNAMES="DNS:$HOST,IP:127.0.0.1"
KEYSTORE="$APP.p12"
DNAME="cn=$HOST, ou=Advisory, o=MuleSoft, c=US"

keytool -v -genkeypair -keyalg RSA -dname "$DNAME" \
 -ext SAN="$ALTNAMES" -validity 365 -alias server \
 -keystore "$KEYSTORE" -storetype pkcs12 -storepass "$PASS"