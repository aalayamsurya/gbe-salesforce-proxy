### Run with these VM Arguments:
```
-M-Danypoint.platform.client_id=dceabcf58e9a4441b41e691844b63571 -M-Danypoint.platform.client_secret=30BC078B520A481C8990E460a73aECfD -M-Denv=local -M-Dencrypt.key=secure12345 -M-Danypoint.platform.gatekeeper=disabled
```
### For Invoking Mutual TLS via CURL:
`curl -v -H "Accept: application/json" -H "Content-Type: application/json" --cert client.cer:mule12345 --key client.key --cacert root.cer  https://localhost:8082/api/v1/customers`

### Encrypt Secure Properties File
```java -jar /tmp/secure-properties-tool.jar \
file encrypt Blowfish CBC secure12345 \
dev-secure-properties.yaml tmp.yaml \
mv tmp.yaml dev-secure-properties.yaml
```
