#!/usr/bin/env bash
set -euo pipefail
# Manage tenant domains in Caddy
# Usage:
#   ./tenant.sh add <subdomain-or-domain>   Add a tenant (subdomain or custom domain)
#   ./tenant.sh remove <subdomain-or-domain> Remove a tenant
#   ./tenant.sh list                         List all tenant domains

TENANTS_DIR="/etc/caddy/tenants"
MAIN_DOMAIN="360booking.ro"

usage() {
    echo "Usage: $0 {add|remove|list} [domain]"
    echo ""
    echo "Commands:"
    echo "  add <name>      Add a tenant domain. Examples:"
    echo "                    ./tenant.sh add salon-maria        → salon-maria.360booking.ro"
    echo "                    ./tenant.sh add salon-maria.ro     → salon-maria.ro (custom domain)"
    echo "  remove <name>   Remove a tenant domain"
    echo "  list            List all tenant domains"
    exit 1
}

resolve_domain() {
    local input="$1"
    # If input contains a dot, treat as custom domain; otherwise as subdomain
    if [[ "$input" == *.* ]]; then
        echo "$input"
    else
        echo "${input}.${MAIN_DOMAIN}"
    fi
}

add_tenant() {
    local domain
    domain=$(resolve_domain "$1")
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
    echo "Done."
    if [[ "$domain" == *".${MAIN_DOMAIN}" ]]; then
        echo "Subdomain is ready (DNS wildcard *.${MAIN_DOMAIN} covers it)."
    else
        echo "Make sure the domain's DNS A record points to this server."
    fi
}

remove_tenant() {
    local domain
    domain=$(resolve_domain "$1")
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
    echo "Tenant domains:"
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
