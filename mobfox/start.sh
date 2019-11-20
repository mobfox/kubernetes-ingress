#!/bin/bash
#
# overwrites /fs/start.sh

set -e
/usr/sbin/rsyslogd -f /etc/rsyslog.conf
if [ $# -gt 0 ] && [ "$(echo $1 | cut -b1-2)" != "--" ]; then
    # Probably a `docker run -ti`, so exec and exit
    # redirects this process output to the syslog, which is watched by rsyslog
    exec "$@" 1> >(logger -s -t $(basename $0)) 2>&1
else
	# redirects this process output to the syslog, which is watched by rsyslog
    exec /haproxy-ingress-controller "$@" 1> >(logger -s -t $(basename $0)) 2>&1
fi