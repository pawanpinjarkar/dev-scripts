# #!/usr/bin/env bash
set -euxo pipefail

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$(systemd-path user-configuration)}
SCRIPTDIR="$(pwd)"
USER=`whoami`

# Get variables from the config file
if [ -z "${CONFIG:-}" ]; then
    # See if there's a config_$USER.sh in the SCRIPTDIR
    if [ -f ${SCRIPTDIR}/config_${USER}.sh ]; then
        echo "Using CONFIG ${SCRIPTDIR}/config_${USER}.sh" 1>&2
        CONFIG="${SCRIPTDIR}/config_${USER}.sh"
    elif [[ -f "${XDG_CONFIG_HOME}/dev-scripts/config" ]]; then
        echo "Using CONFIG ${XDG_CONFIG_HOME}/dev-scripts/config" 1>&2
        CONFIG="${XDG_CONFIG_HOME}/dev-scripts/config"
    else
        error "Please run with a configuration environment set."
        error "eg CONFIG=config_example.sh ./01_all_in_one.sh"
        exit 1
    fi
fi
export AGENT_CONFIG=${AGENT_CONFIG:-}
source $CONFIG

if [ "${AGENT_CONFIG}" != "COMPACT_IPV4" ] && [ "${AGENT_CONFIG}" != "COMPACT_IPV6" ] && [ "${AGENT_CONFIG}" != "HA_IPV4" ] && [ "${AGENT_CONFIG}" != "HA_IPV6" ] && [ "${AGENT_CONFIG}" != "SNO_IPV4" ] && [ "${AGENT_CONFIG}" != "SNO_IPV6" ] ; then
    echo "Invalid value for AGENT_CONFIG. Did you set a valid value in config_<user>.sh? Supported values: COMPACT_IPV4, COMPACT_IPV6, HA_IPV4, HA_IPV6, SNO_IPV4, SNO_IPV6."
    exit 1
fi
