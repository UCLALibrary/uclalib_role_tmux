#! /bin/bash

# Color hints for alerts and messages
GREEN='\033[1;32m'
RED='\033[0;31m'
NC='\033[0m'

# An informational message in case a test fails
die () {
  echo ""
  printf "${RED}Tests failed!${NC}\n"
  echo ""

  if [ "$TRAVIS" != 'true' ]; then
    printf "  ${GREEN}To clean up the testing container, run:${NC}\n"
    echo "    docker rm -f \"$(cat $1)\""
    echo ""
    printf "  ${GREEN}To clean up all system containers, run:${NC}\n"
    echo "    docker rm -f \$(docker ps -a -q)"
    echo ""
  fi

  exit $?
}

# Validation tests that are specific to a particular distro
if [ "$1" == "centos7" ]; then
  docker exec --tty "$(cat ${2})" env TERM=xterm yum list installed tmux || die "$2"
elif [ "$1" == "ubuntu1404" ]; then
  docker exec --tty "$(cat ${2})" env TERM=xterm test $(dpkg-query -W -f='${Status}' tmux 2>/dev/null | grep -c "ok installed") != 0 || die "$2"
else
  echo "Unexpected distro value: ${1}"; exit 1
fi
