#!/bin/sh

if ! hash php 2> /dev/null; then
  echo "PHP does not seem installed"
  exit 1
fi

if ! hash composer 2> /dev/null; then
  # curl -sSL https://composer.github.io/installer.sig -o /tmp/composer-installer.sig
  curl -sSL https://getcomposer.org/installer -o /tmp/composer-installer.php
  # checksum "sha384:$(cat /tmp/composer-installer.sig)" /tmp/composer-installer.php
  echo CHECKSUM
  ! sha384 2> /dev/null && alias sha384="sha --alorigthm 384"
  sha384 /tmp/composer-installer.php
  chmod 0755 /tmp/composer-installer.php

  php /tmp/composer-installer.php --install-dir=/usr/local/bin --filename=composer # --version=
fi

composer self-update

# export PATH=$PATH:~/.composer/vendor/bin

# for name in "$@"; do
#   composer global require "$name" # @stable
# done

if [ $# -ne 0 ]; then
  echo composer global require "$@"
fi
