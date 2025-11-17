#!/bin/bash

# ==========================================================================
# WP-Cron Runner for Multisite
#
# This script triggers 'wp cron event run --due-now' for all subsites in a
# WordPress installation. It is designed to be called from a cron job and
# requires the path to the WordPress installation as its first argument.
#
# CRON JOB USAGE EXAMPLE ---
#
# */15 * * * * flock -n /tmp/wp-cron-multisite-server-cron-runner.lock /path/to/wp-cron-multisite-server-cron-runner.sh /www/sitename/public > /www/sitename/private/cron.log 2>&1
#
# Breakdown:
#   - `flock -n /tmp/wp-cron-multisite-server-cron-runner.lock`: Prevents overlapping runs.
#   - `/path/to/wp-cron-multisite-server-cron-runner.sh`: The path to this script.
#   - `/www/sitename/public`: The required WordPress path argument.
#   - `> ...`: Overwrites the log. Use `>>` to append instead.
# ==========================================================================

# Path to the WP-CLI executable
WP_CLI_PATH="/usr/local/bin/wp"

# --- Main Script ---

# 1. Check if a path argument was provided. Exit with an error if not.
if [ -z "$1" ]; then
    echo "Error: No WordPress path provided." >&2
    echo "Usage: $0 /path/to/wordpress" >&2
    exit 1
fi

# 2. Assign the first command-line argument to our variable.
PATH_TO_WORDPRESS="$1"

# 3. Use the variable to run the WP-CLI commands.
$WP_CLI_PATH site list --fields=url --format=csv --no-header --path="$PATH_TO_WORDPRESS" | while read URL; do
    # Only process lines that are not the literal string "url"
    if [[ "$URL" != "url" ]]; then
        echo "Running cron for $URL at $(date)"
        $WP_CLI_PATH cron event run --due-now --url="$URL" --path="$PATH_TO_WORDPRESS"
    fi
done