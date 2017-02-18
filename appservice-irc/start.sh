#!/usr/bin/env bash

set -e

module_path=/var/lib/ircbridge/node_modules/matrix-appservice-irc

case "${1}" in
  "start")
      ${module_path}/bin/matrix-appservice-irc -p 5487 -c /data/irc/config.yaml -f /data/irc/registration.yaml
    ;;

  "register")
      if [ ! -d /data/irc ]
      then
        mkdir /data/irc
      fi
      if [ ! -e /data/irc/config.yaml ]
      then
        cp ${module_path}/config.sample.yaml /data/irc/config.yaml
        echo "Created sample config.yaml in /data/irc, please review and update the config to suit your needs"
        sed -i "s|passwordEncryptionKeyPath: \"/etc/matrix-synapse/irc/passkey.pem\"|passwordEncryptionKeyPath: \"/data/irc/passkey.pem\"|" /data/irc/config.yaml
      fi
      if [ ! -e /data/irc/passkey.pem ]
      then
        genpkey -out /data/irc/passkey.pem -outform PEM -algorithm RSA -pkeyopt rsa_keygen_bits:2048
      fi
      ${node_modules}/bin/matrix-appservice-irc --generate-registration -u 'http://irc:5487' -c /data/irc/config.yaml -f /data/irc/registration.yaml
      echo "Registration complete, please update your homeserver config file to point to the registration.yaml"
    ;;

  *)
    echo "Usage : matrix-appservice-irc start|register"
    ;;
esac
