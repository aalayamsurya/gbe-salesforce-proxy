
PASS="mule12345"
APP="ng-example-api"
HOST="localhost"
ALTNAMES="DNS:$HOST,IP:127.0.0.1"
KEYSTORE="$APP.p12"
DNAME="cn=$HOST, ou=Advisory, o=MuleSoft, c=US"
# client_id is *only* for the output filenames
# incrementing the serial number is important
CLIENT_ID="my-client"
CLIENT_SERIAL=01

###### PICK ONE OF THE TWO FOLLOWING ######

# OPTION ONE: RSA key. these are very well-supported around the internet.
# you can swap out 4096 for whatever RSA key size you want. this'll generate a key
# with password "xxxx" and then turn around and re-export it without a password,
# because genrsa doesn't work without a password of at least 4 characters.
#
# some appliance hardware only works w/2048 so if you're doing IOT keep that in
# mind as you generate CA and client keys. i've found that firefox & chrome will
# happily work with stuff in the bigger 8192 ranges, but doing that vs sticking with
# 4096 doesn't buy you that much extra practical security anyway.

openssl genrsa -aes256 -passout pass:${PASS} -out ca.pass.key 4096
openssl rsa -passin pass:${PASS} -in ca.pass.key -out ca.key
rm ca.pass.key
echo "----------------"
echo "CA Created"
echo "----------------"

# OPTION TWO: make an elliptic curve-based key.
# support for ECC varies widely, and support for the predefined curves also varies.
# it's "secp256r1" in this case, which is as well-supported as it gets but if you want to
# avoid NIST-provided things, or if you want to go with bigger/newer keys, you can
# swap that out:
#
# * check your openssl supported curves: `openssl ecparam -list_curves`
# * check client support for whatever browser/language/system/device you want to use:
#      https://en.wikipedia.org/wiki/Comparison_of_TLS_implementations#Supported_elliptic_curves

# openssl ecparam -genkey -name secp256r1 | openssl ec -out ca.key

###### END  "PICK ONE" SECTION ######

# whichever you picked, you should now have a `ca.key` file.

# now generate the CA root cert
# when prompted, use whatever you'd like, but i'd recommend some human-readable Organization
# and Common Name.
openssl req -new -x509 -days 3650 -key ca.key -out ca.pem

echo "----------------"
echo "X.509 Created"
echo "----------------"


###### PICK ONE OF THE TWO FOLLOWING ######
###### (instrux in the CA section above) ######
# rsa
openssl genrsa -aes256 -passout pass:${PASS} -out ${CLIENT_ID}.pass.key 4096
openssl rsa -passin pass:${PASS} -in ${CLIENT_ID}.pass.key -out ${CLIENT_ID}.key
rm ${CLIENT_ID}.pass.key

echo "----------------"
echo "Client Cert Created"
echo "----------------"
# whichever you picked, you should now have a `client.key` file.

# generate the CSR
# i think the Common Name is the only important thing here. think of it like
# a display name or login.
openssl req -new -key ${CLIENT_ID}.key -out ${CLIENT_ID}.csr
echo "----------------"
echo "CSR Created"
echo "----------------"

# issue this certificate, signed by the CA root we made in the previous section
openssl x509 -req -days 3650 -in ${CLIENT_ID}.csr -CA ca.pem -CAkey ca.key -set_serial ${CLIENT_SERIAL} -out ${CLIENT_ID}.pem
echo "----------------"
echo "Issued X.509 Signed by CA"
echo "----------------"
# Bundle the private key & cert for end-user client use
cat ${CLIENT_ID}.key ${CLIENT_ID}.pem ca.pem > ${CLIENT_ID}.full.pem

# Bundle into PFX file
openssl pkcs12 -export -out ${CLIENT_ID}.full.pfx -inkey ${CLIENT_ID}.key -in ${CLIENT_ID}.pem -certfile ca.pem

echo "----------------"
echo "Bundled for Friendly Usage and Complete"
echo "----------------"

keytool -importkeystore -srckeystore ${CLIENT_ID}.full.pfx \
        -srcstoretype PKCS12 \
        -destkeystore truststore.p12 \
        -deststoretype PKCS12
echo "----------------"
echo "Trust Store Created"
echo "----------------"
