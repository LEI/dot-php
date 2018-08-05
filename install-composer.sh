#!/bin/sh

set -e

if ! hash php 2> /dev/null; then
  1>&2 echo "php: command not found"
  exit 1
fi

install_composer() {
  curl -sSL https://composer.github.io/installer.sig \
    -o /tmp/composer-installer.sig
  sig=$(cat /tmp/composer-installer.sig)

  curl -sSL https://getcomposer.org/installer \
    -o /tmp/composer-installer.php
  sha384sum 2> /dev/null || alias sha384sum="sha --alorigthm 384"
  sum="$(sha384sum /tmp/composer-installer.php | cut -d' ' -f1)"

  # sha384: $sig /tmp/composer-installer.php
  if [ "$sig" != "$sum" ]; then
    1>&2 echo "sha384 sum mismatch"
    exit 1
  fi

  php /tmp/composer-installer.php --help
  chmod 0755 /tmp/composer-installer.php
  php /tmp/composer-installer.php \
    --install-dir=/usr/local/bin \
    --filename=composer \
    --quiet
    # --version=
}

composer_self_update() {
  # --quiet
  composer --no-interaction \
    self-update --no-progress
}

composer_global_require() {
  # [ $# -ne 0 ]
  for name in "$@"; do
    # --quiet
    composer --no-interaction \
      global --no-progress \
      require "$name" # "${name}${release:-@stable}"
  done
}

do_install() {
  if ! hash composer 2> /dev/null; then
    install_composer
  else
    composer_self_update
  fi
  composer_global_require "$@"
}

do_install "$@"
