#!/bin/bash

function usage_traffic () {
echo "        traffic <ingress> <svc-old> <svc-new> <percentage-new>"
}

function usage () {
    echo "Usage: kubectl plugin skipper <subcommand> <args>
subcommands:"
    usage_traffic
}


if [ -z ${2} ]
then
  usage
  exit 1
fi

SUBCMD=${2}

case $SUBCMD in
traffic )
  if [ -z ${6} ]
  then
    usage_traffic
    exit 1
  fi

  old=$(( 100 - $6 ))

  kubectl patch ingress $3  -p "{\"metadata\": { \"annotations\": { \"zalando.org/backend-weights\": \"{\\\"$4\\\": $old, \\\"$5\\\": $6 }\" } } }"

;;

*)
  echo "ERR: unknown subcommand ${SUBCMD}"
  echo ""
  usage
  exit 2
  ;;

esac
