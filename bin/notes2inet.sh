#!/bin/sh
#
# notes2inet.sh
#
# Comments, suggestions: Alexei Znamensky <alexeiz@br.ibm.com>
# Complaints, flames...: >/dev/null 2>&1
#

LDAPSEARCH="ldapsearch"
LDAP_OPT="-x -LL"

search() {
    n="$1"
    ss=$(echo "$n" | perl -lne 's|/|/\*=|g; print "CN=".$_')
    ${LDAPSEARCH} ${LDAP_OPT} \
        -h bluepages.ibm.com \
        -b 'ou=bluepages,o=ibm.com' \
        notesEmail="${ss}" mail \
      | perl -lne 'next if ! /^mail/; s/^.*:\s+//; print' \
      | head -1
}

cat "$@" | while read notesEmail; do
    m=$(search "$notesEmail")
    [ -z "$m" ] && echo "Cannot find [$notesEmail]" >&2 && continue
    echo "$m"
done

