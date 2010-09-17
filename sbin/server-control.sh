#!/bin/sh -e 'echo Do not run this >&2; exit 1'
#
# Alexei Znamensky <russoz@gmail.com>
#
# Feel free to send suggestions, comments. Flames go to /dev/null.
#

[ -n "${_SERVER_CONTROL}" ] && return
_SERVER_CONTROL=1

_msg() {
  echo "$@" >&2
}

##############################################################################

usage_wasctl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _wasctl [options] command
    
DESCRIPTION
    Controls a WAS instance

COMMAND
    start       Starts the application server
    stop        Stops the application server
    restart     Stops and starts the application server
    status      Prints status for the application server
    status-all  Prints status for all application servers

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <WAS profile root> (mandatory)
        Root directory for the working WAS profile
    -s  <server> (mandatory)
        Server instance to apply command
    -u  <user> (optional)
        User name for WAS
    -p  <password> (optional)
        Password for WAS

EOM
  exit 1
}

_wasctl() {
  set -- $(getopt n:r:s:u:p: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_wasctl; return 1; }
  
  unset name root server user pass UP comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      -s)   server="$1"; shift ;;
      -u)   user="$1"; shift ;;
      -p)   pass="$1"; shift ;;
      *)    usage_wasctl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ]   && { usage_wasctl "_wasctl: Must specify a name"; }
  [ -z "${root}" ]   && { usage_wasctl "_wasctl: Must specify a root"; }
  [ -z "${server}" ] && { usage_wasctl "_wasctl: Must specify a server"; }

  if [ -n "${user}" ]; then
    [ -z "${pass}" ] && { 
      usage_wasctl "_wasctl: Must specify both user and password"
    }

    UP="-username ${user} -password ${pass}"
  else # -u has not been passed
    [ -n "${pass}" ] && {
      usage_wasctl "_wasctl: Must specify both user and password"
    }
  fi

  comm="$1"; shift
  _msg "= wasctl ========== ${name}(${server}): ${comm}"

  case "${comm}" in
    start)      ${root}/bin/startServer.sh  ${server} ${UP} ;;
    stop)       ${root}/bin/stopServer.sh   ${server} ${UP} ;;
    status)     ${root}/bin/serverStatus.sh ${server} ${UP} ;;
    status-all) ${root}/bin/serverStatus.sh -all      ${UP} ;;
    restart)    ${root}/bin/stopServer.sh   ${server} ${UP} \
                  && ${root}/bin/startServer.sh ${server} ${UP} ;;
    *)          _msg "usage: ${name} (start|stop|restart|status|status-all)"
                return 1 ;;
  esac
}

##############################################################################

usage_wasnodectl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _wasnodectl [options] command

DESCRIPTION
    Controls a WAS node agent

COMMAND
    start       Starts the node agent
    stop        Stops the node agent
    restart     Stops and starts the node agent
    status      Prints status for the node agent
    status-all  Prints status for all application servers

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <WAS profile root> (mandatory)
        Root directory for the working WAS profile
    -u  <user> (optional)
        User name for WAS
    -p  <password> (optional)
        Password for WAS

EOM
  exit 1
}

_wasnodectl() {
  set -- $(getopt n:r:u:p: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_wasnodectl; return 1; }
  
  unset name root user pass UP comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      -u)   user="$1"; shift ;;
      -p)   pass="$1"; shift ;;
      *)    usage_wasnodectl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ] && { usage_wasnodectl "_wasnodectl: Must specify a name"; }
  [ -z "${root}" ] && { usage_wasnodectl "_wasnodectl: Must specify a root"; }

  if [ -n "${user}" ]; then
    [ -z "${pass}" ] && { 
      usage_wasnodectl "_wasnodectl: Must specify both user and password"
    }

    UP="-username ${user} -password ${pass}"
  else # -u has not been passed
    [ -n "${pass}" ] && { 
      usage_wasnodectl "_wasnodectl: Must specify both user and password"
    }
  fi

  comm="$1"; shift
  _msg "= wasnodectl ====== ${name}: ${comm}"

  case "${comm}" in
    start)      ${root}/bin/startNode.sh ${UP} ;;
    stop)       ${root}/bin/stopNode.sh ${UP} ;;
    status)     ${root}/bin/serverStatus.sh nodeagent ${UP} ;;
    status-all) ${root}/bin/serverStatus.sh -all ${UP} ;;
    restart)    ${root}/bin/stopNode.sh ${UP} && ${root}/bin/startNode.sh ${UP} ;;
    *)          _msg "usage: ${name} (start|stop|restart|status|status-all)"
                return 1 ;;
  esac
}

##############################################################################

usage_wasdmgrctl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _wasdmgrctl [options] command

DESCRIPTION
    Controls a WAS deployment manager

COMMAND
    start       Starts the deployment manager
    stop        Stops the deployment manager
    restart     Stops and starts the deployment manager
    status      Prints status for the deployment manager
    status-all  Prints status for all application servers

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <WAS profile root> (mandatory)
        Root directory for the working WAS profile
    -u  <user> (optional)
        User name for WAS
    -p  <password> (optional)
        Password for WAS

EOM
  exit 1
}

_wasdmgrctl() {
  set -- $(getopt n:r:u:p: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_wasdmgrctl; return 1; }
  
  unset name root user pass UP comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      -u)   user="$1"; shift ;;
      -p)   pass="$1"; shift ;;
      *)    usage_wasdmgrctl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ] && { usage_wasdmgrctl "_wasdmgrctl: Must specify a name"; }
  [ -z "${root}" ] && { usage_wasdmgrctl "_wasdmgrctl: Must specify a root"; }

  if [ -n "${user}" ]; then
    [ -z "${pass}" ] && { 
      usage_wasdmgrctl "_wasdmgrctl: Must specify both user and password"
    }

    UP="-username ${user} -password ${pass}"
  else # -u has not been passed
    [ -n "${pass}" ] && { 
      usage_wasdmgrctl "_wasdmgrctl: Must specify both user and password"
    }
  fi

  comm="$1"; shift
  _msg "= wasdmgrctl ====== ${name}: ${comm}"

  case "${comm}" in
    start)      ${root}/bin/startManager.sh ${UP} ;;
    stop)       ${root}/bin/stopManager.sh ${UP} ;;
    status)     ${root}/bin/serverStatus.sh dmgr ${UP} ;;
    status-all) ${root}/bin/serverStatus.sh -all ${UP} ;;
    restart)    ${root}/bin/stopManager.sh ${UP} \
                  && ${root}/bin/startManager.sh ${UP} ;;
    *)          _msg "usage: ${name} (start|stop|restart|status|status-all)"
                return 1 ;;
  esac
}

##############################################################################

usage_ihsctl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _ihsctl [options] command

DESCRIPTION
    Controls an IHS instance

COMMAND
    start       Starts the IHS server
    stop        Stops the IHS server
    graceful    Graceful restart
    restart     Stops and starts the IHS server
    status      Prints status for the IHS server

    admin-start       Starts the IHS administrative server
    admin-stop        Stops the IHS administrative server
    admin-graceful    Graceful administrative server
    admin-restart     Stops and starts the IHS administrative server
    admin-status      Prints status for the IHS administrative server

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <IHS root> (mandatory)
        IHS installation root directory

EOM
  exit 1
}

_ihsctl() {
  set -- $(getopt n:r: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_ihsctl; return 1; }
  
  unset name root comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      *)    usage_ihsctl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ] && { usage_ihsctl "_ihsctl: Must specify a name"; }
  [ -z "${root}" ] && { usage_ihsctl "_ihsctl: Must specify a root"; }

  comm="$1"; shift
  _msg "= ihsctl ========== ${name}: ${comm}"

  case "${comm}" in
    start)          ${root}/bin/apachectl start ;;
    stop)           ${root}/bin/apachectl stop ;;
    graceful)       ${root}/bin/apachectl graceful ;;
    status)         ${root}/bin/apachectl status ;;
    restart)        ${root}/bin/apachectl stop \
                      && ${root}/bin/apachectl start ;;
                      
    admin-start)    ${root}/bin/adminctl start ;;
    admin-stop)     ${root}/bin/adminctl stop ;;
    admin-graceful) ${root}/bin/adminctl graceful ;;
    admin-status)   ${root}/bin/adminctl status ;;
    admin-restart)  ${root}/bin/adminctl stop \
                      && ${root}/bin/adminctl start ;;
                      
    *) _msg "usage: ${name} [admin-](start|stop|graceful|restart|status)"
       return 1 ;;
  esac
}

##############################################################################

usage_ldapctl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _ldapctl [options] command
    
DESCRIPTION
    Controls a Tivoli Directory Server (TDS) instance

COMMAND
    start       Starts the TDS instance
    stop        Stops the TDS instance
    restart     Stops and starts the TDS instance
    status      Prints status for the TDS instance

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <TDS root> (mandatory)
        Root directory for the TDS installation
    -i  <instance> (mandatory)
        TDS instance to apply command

EOM
  exit 1
}

_ldapctl() {
  set -- $(getopt n:r:i:u:p: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_ldapctl; return 1; }
  
  unset name root inst comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      -i)   inst="$1"; shift ;;
      *)    usage_ldapctl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ] && { usage_ldapctl "_ldapctl: Must specify a name"; }
  [ -z "${root}" ] && { usage_ldapctl "_ldapctl: Must specify a root"; }
  [ -z "${inst}" ] && { usage_ldapctl "_ldapctl: Must specify an instance"; }

  comm="$1"; shift
  _msg "= ldapctl ========= ${name}(${inst}): ${comm}"

  case "${comm}" in
    start)      ${root}/bin/idsdirctl start  -- -I ${inst} ;;
    stop)       ${root}/bin/idsdirctl stop   -- -I ${inst} ;;
    status)     ${root}/bin/idsdirctl status -- -I ${inst} ;;
    restart)    ${root}/bin/idsdirctl stop   -- -I ${inst} \
                  && ${root}/bin/idsdirctl start -- -I ${inst} ;;
    *)          _msg "usage: ${name} (start|stop|restart|status)"
                return 1 ;;
  esac
}

##############################################################################

usage_mqctl() {
  [ -n "$1" ] && _msg 'ERROR:' "$@"
  cat >&2 <<EOM 
USAGE
    _mqctl [options] command
    
DESCRIPTION
    Controls a MQ instance

COMMAND
    start       Starts the MQ instance
    stop        Stops the MQ instance
    restart     Stops and starts the MQ instance
    status      Prints status for the MQ instance

OPTIONS
    -n  <name> (mandatory)
        Service name (usually \${0##*/})
    -r  <MQ root> (mandatory)
        Root directory for the MQ installation
    -m  <queue manager> (mandatory)
        MQ Queue Manager to apply command
    -u  <user> (optional)
        User ID to issue MQ commands

EOM
  exit 1
}

__runmq() {
  user="$1"; shift
  cmd="$1"; shift

  if [ -n "$user" ]; then
    su - "${user}" -c "${cmd}" "$@"
  else
    ${cmd} "$@"
  fi
}

_mqctl() {
  set -- $(getopt n:r:m:u: $*)
  # check result of parsing
  [ $? != 0 ] && { usage_mqctl; return 1; }

  unset name root qmgr user comm
  while [ $1 != -- ]; do
    flag="$1"; shift
    case ${flag} in
      -n)   name="$1"; shift ;;
      -r)   root="$1"; shift ;;
      -m)   qmgr="$1"; shift ;;
      -u)   user="$1"; shift ;;
      *)    usage_mqctl "Invalid option $1" ;;
    esac
  done
  shift   # skip the --

  [ -z "${name}" ] && { usage_mqctl "_mqctl: Must specify a name"; }
  [ -z "${root}" ] && { usage_mqctl "_mqctl: Must specify a root"; }
  [ -z "${qmgr}" ] && { usage_mqctl "_mqctl: Must specify a qmgr"; }

  comm="$1"; shift
  _msg "= mqctl =========== ${name}(${qmgr}): ${comm}"

  case "${comm}" in
    start)    __runmq "${user}" ${root}/bin/strmqm      ${qmgr}
              __runmq "${user}" ${root}/bin/strmqcsv    ${qmgr}
              __runmq "${user}" ${root}/bin/runmqlsr -m ${qmgr} -t TCP &   ;;

    stop)     __runmq "${user}" ${root}/bin/endmqlsr -m ${qmgr}
              __runmq "${user}" ${root}/bin/endmqcsv -c ${qmgr}
              __runmq "${user}" ${root}/bin/endmqm      ${qmgr}   ;;

    status)   __runmq "${user}" ${root}/bin/dspmq -m    ${qmgr}
              __runmq "${user}" ${root}/bin/dspmqcsv    ${qmgr}   ;;

    restart)  #stop
              __runmq "${user}" ${root}/bin/endmqlsr -m ${qmgr}
              __runmq "${user}" ${root}/bin/endmqcsv -c ${qmgr}
              __runmq "${user}" ${root}/bin/endmqm      ${qmgr}
            
              #start
              __runmq "${user}" ${root}/bin/strmqm      ${qmgr}
              __runmq "${user}" ${root}/bin/strmqcsv    ${qmgr}
              __runmq "${user}" ${root}/bin/runmqlsr -m ${qmgr} -t TCP &   ;;

    *)        _msg "usage: ${name} (start|stop|restart|status)"
              return 1 ;;
esac

}

##############################################################################


