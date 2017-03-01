#!/usr/bin/env bash

set -e

module_path=/var/lib/ircbridge/node_modules/matrix-appservice-irc

case "${1}" in
  "start")
      ${module_path}/bin/matrix-appservice-irc -p 5487 -c /data/config.yaml -f /shared/irc-registration.yaml
    ;;

  "register")
      if [ ! -d /data ]
      then
        mkdir /data
      fi
      if [ ! -e /data/config.yaml ]
      then
        cp ${module_path}/config.sample.yaml /data/config.yaml
        echo "Created sample config.yaml in /data, please review and update the config to suit your needs"
        sed -i "s|passwordEncryptionKeyPath: \"/etc/matrix-synapse/irc/passkey.pem\"|passwordEncryptionKeyPath: \"/data/passkey.pem\"|" /data/config.yaml
      fi
      if [ ! -e /data/passkey.pem ]
      then
        genpkey -out /data/passkey.pem -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:2048
      fi
      ${module_path}/bin/matrix-appservice-irc --generate-registration -u 'http://irc:5487' -c /data/config.yaml -f /shared/irc-registration.yaml
      echo "Registration complete, please update your homeserver config file to point to the registration.yaml"
    ;;

  *)
    echo "Usage : matrix-appservice-irc start|register"
    ;;
esac
