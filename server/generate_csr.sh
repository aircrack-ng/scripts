#!/bin/sh

if [ -z "$1" ]; then
	echo "Missing domain name"
	exit 1
fi

which openssl 2>/dev/null >/dev/null
if [ $? -ne 0 ]; then
	echo "Missing OpenSSL. Please install it."
	exit 1
fi

if [ -f "$1.key" ]; then
	echo "Re-using existing private key: $1"
else
	openssl genrsa -out $1.key 4096
fi
echo ""
echo "[*] Only Common Name (your domain) and email matters for CAcert.org"
echo ""
openssl req -new -sha512 -key $1.key -out $1.csr

if [ ! -f "$1.csr" ]; then
	echo "CSR not generated."
	exit 1
fi
echo ""
echo ""
echo "CSR generated: $1.csr"

echo "Once certificate is generated on CAcert.org, paste the content to"
echo "${PWD}/$1.crt. Download the following to CAcert_chain.pem:"
echo "http://wiki.cacert.org/SimpleApacheCert?action=AttachFile&do=get&target=CAcert_chain.pem"
echo "And add the following lines to your virtual host in Apache:"
echo "SSLCertificateFile ${PWD}/$1.crt"
echo "SSLCertificateKeyFile ${PWD}/$1.key"
echo "SSLCertificateChainFile ${PWD}/CAcert_chain.pem"
