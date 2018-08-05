#!/bin/sh

set -e

if ! hash php 2> /dev/null; then
  echo "PHP does not seem installed"
  exit 1
fi

if ! hash composer 2> /dev/null; then
  curl -sSL https://composer.github.io/installer.sig -o /tmp/composer-installer.sig
  curl -sSL https://getcomposer.org/installer -o /tmp/composer-installer.php
  ! sha384sum 2> /dev/null && alias sha384sum="sha --alorigthm 384"
  sig=$(cat /tmp/composer-installer.sig)
  sum="$(sha384sum /tmp/composer-installer.php | cut -d' ' -f1)"
  # sha384: $sig /tmp/composer-installer.php
  if [ "$sig" != "$sum" ]; then
    echo "sha384 sum mismatch"
    exit 1
  fi
  chmod 0755 /tmp/composer-installer.php
  php /tmp/composer-installer.php --install-dir=/usr/local/bin --filename=composer # --version=
else
  composer self-update
fi

# for name in "$@"; do
#   composer global require "$name" # @stable
# done

if [ $# -ne 0 ]; then
  echo composer global require "$@"
fi
