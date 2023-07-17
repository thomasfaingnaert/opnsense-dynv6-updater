#!/usr/bin/env bash
set -Eeuo pipefail

usage()
{
    cat <<EOF >&2
Usage: $0 domain token [OPTIONS]

Update DNS records of dynv6.

Options:
-h, --help          Show this help.
EOF
}

positional=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage; exit 0
            ;;
        -*)
            echo "Unknown command-line option '$1'."
            echo "Try '$0 --help' for more information."
            exit 1
            ;;
        *)
            positional+=("$1")
            shift
            ;;
    esac
done
set -- "${positional[@]}"

if [[ $# -ne 2 ]]; then
    echo "Expected 2 positional arguments, but got $#."
    echo "Try '$0 --help' for more information."
    exit 1
fi

DOMAIN="$1"
TOKEN="$2"

CURRENT_IP4="$(dig -4 +short A myip.opendns.com @resolver1.opendns.com)"
CURRENT_IP6="$(dig -6 +short AAAA myip.opendns.com @resolver1.opendns.com)"

DNS_IP4="$(dig +short A $DOMAIN)"
DNS_IP6="$(dig +short AAAA $DOMAIN)"

[[ "$CURRENT_IP4" != "$DNS_IP4" ]] && curl -fsS "https://ipv4.dynv6.com/api/update?zone=$DOMAIN&token=$TOKEN&ipv4=auto"
[[ "$CURRENT_IP6" != "$DNS_IP6" ]] && curl -fsS "https://ipv6.dynv6.com/api/update?zone=$DOMAIN&token=$TOKEN&ipv6prefix=auto&ipv6=auto"
