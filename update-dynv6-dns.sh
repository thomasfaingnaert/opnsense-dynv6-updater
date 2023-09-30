#!/usr/bin/env bash
set -Eeuo pipefail

usage()
{
    cat <<EOF >&2
Usage: $0 domain token ipv4-interface ipv6-interface [OPTIONS]

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

if [[ $# -ne 4 ]]; then
    echo "Expected 4 positional arguments, but got $#."
    echo "Try '$0 --help' for more information."
    exit 1
fi

DOMAIN="$1"
TOKEN="$2"
IPV4_INTERFACE="$3"
IPV6_INTERFACE="$4"

CURRENT_IP4="$(ifconfig $IPV4_INTERFACE | grep '\<inet\>' | cut -d' ' -f2)"
CURRENT_IP6="$(ifconfig $IPV6_INTERFACE | grep '\<inet6\> [23]' | cut -d' ' -f2)"

IP4_FILE="/.opnsense.dynv6.updater.last.ip4"
IP6_FILE="/.opnsense.dynv6.updater.last.ip6"

LAST_IP4=""
LAST_IP6=""

[[ -f "$IP4_FILE" ]] && LAST_IP4="$(cat "$IP4_FILE")"
[[ -f "$IP6_FILE" ]] && LAST_IP6="$(cat "$IP6_FILE")"

[[ "$CURRENT_IP4" != "$LAST_IP4" ]] && curl -fsS "https://ipv4.dynv6.com/api/update?zone=$DOMAIN&token=$TOKEN&ipv4=$CURRENT_IP4" && echo $CURRENT_IP4 >"$IP4_FILE"
[[ "$CURRENT_IP6" != "$LAST_IP6" ]] && curl -fsS "https://ipv6.dynv6.com/api/update?zone=$DOMAIN&token=$TOKEN&ipv6=$CURRENT_IP6/64" && echo $CURRENT_IP6 >"$IP6_FILE"
