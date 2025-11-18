This script triggers `wp cron event run --due-now` for all subsites in a WordPress installation. It is designed to be called from a cron job and requires the path to the WordPress installation as its first argument.

CRON JOB USAGE EXAMPLE ---

`*/15 * * * * flock -n /tmp/wp-cron-multisite-server-cron-runner.lock /path/to/wp-cron-multisite-server-cron-runner.sh /www/sitename/public > /www/sitename/private/cron.log 2>&1`

Breakdown:
- `flock -n /tmp/wp-cron-multisite-server-cron-runner.lock`: Prevents overlapping runs.
- `/path/to/wp-cron-multisite-server-cron-runner.sh`: The path to this script.
- `/www/sitename/public`: The required WordPress path argument.
- `> ...`: Overwrites the log. Use `>>` to append instead.
