all:
	fpm -s dir -t freebsd \
		-p opnsense-dynv6-updater.txz \
		-f \
		--name opnsense-dynv6-updater \
		--depends bash \
		--license BSD3 \
		--version 1.2.0 \
		--architecture all \
		--after-install=after-install.sh \
		--description "OPNsense Dynamic DNS updater for dynv6" \
		--maintainer "Thomas Faingnaert <thomas.faingnaert@hotmail.com>" \
		actions_update-dynv6-dns.conf=/usr/local/opnsense/service/conf/actions.d/actions_update-dynv6-dns.conf \
		update-dynv6-dns.sh=/usr/local/bin/update-dynv6-dns.sh

clean:
	rm -f opnsense-dynv6-updater.txz
