#!/usr/bin/env bash
set -euo pipefail
# Manage tenant custom domains in Caddy
# Usage:
#   ./tenant.sh add <domain>        Add a custom domain for a tenant
#   ./tenant.sh remove <domain>     Remove a custom domain
#   ./tenant.sh list                List all custom domains

TENANTS_DIR="/etc/caddy/tenants"

usage() {
    echo "Usage: $0 {add|remove|list} [domain]"
    echo ""
    echo "Commands:"
    echo "  add <domain>      Add a tenant custom domain (e.g. salon-maria.ro)"
    echo "  remove <domain>   Remove a tenant custom domain"
    echo "  list              List all tenant custom domains"
    echo ""
    echo "Note: *.360booking.ro subdomains are handled automatically."
    echo "      This script is for external custom domains only."
    exit 1
}

add_tenant() {
    local domain="$1"
    local config_file="${TENANTS_DIR}/${domain}.caddy"

    if [[ -f "$config_file" ]]; then
        echo "Domain $domain already configured."
        exit 1
    fi

    cat > "$config_file" <<EOF
${domain} {
	tls {
		on_demand
	}
	import site-common
}
EOF

    echo "Added tenant domain: $domain"
    echo "Reloading Caddy..."
    systemctl reload caddy
    echo "Done. Make sure the domain's DNS A record points to this server."
}

remove_tenant() {
    local domain="$1"
    local config_file="${TENANTS_DIR}/${domain}.caddy"

    if [[ ! -f "$config_file" ]]; then
        echo "Domain $domain not found."
        exit 1
    fi

    rm "$config_file"
    echo "Removed tenant domain: $domain"
    echo "Reloading Caddy..."
    systemctl reload caddy
    echo "Done."
}

list_tenants() {
    echo "Custom tenant domains:"
    if ls "${TENANTS_DIR}"/*.caddy &>/dev/null; then
        for f in "${TENANTS_DIR}"/*.caddy; do
            basename "$f" .caddy
        done
    else
        echo "  (none)"
    fi
}

[[ $# -lt 1 ]] && usage

case "$1" in
    add)
        [[ $# -lt 2 ]] && usage
        add_tenant "$2"
        ;;
    remove)
        [[ $# -lt 2 ]] && usage
        remove_tenant "$2"
        ;;
    list)
        list_tenants
        ;;
    *)
        usage
        ;;
esac
