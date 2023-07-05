You can choose to pin either the root certificate (NSPinnedCAIdentities) or leaf certficate (NSPinnedLeafIdentities). 

Exporting .pem 
There are 2 ways
a. Save certificate into your keychain and export as .pem
b. Convert .cer by using openssl command 
openssl x509 -inform der -in certificate.cer -outform pem -out certificate.pem


Calculate SPKI-SHA256-BASE64 value using openssl
cat ca.pem | openssl x509 -inform pem -noout -outform pem -pubkey | openssl pkey -pubin -inform pem -outform der | openssl dgst -sha256 -binary | openssl enc -base64

Getting the .pem value by running this command
openssl s_client -showcerts -connect apple.com:443

References:
https://developer.apple.com/news/?id=g9ejcf8y
https://serverfault.com/questions/254627/how-do-i-convert-a-cer-certificate-to-pem
https://cheatsheetseries.owasp.org/cheatsheets/Pinning_Cheat_Sheet.html
