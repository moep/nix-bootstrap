include lib/core.sh

function dotfiles::_install_gentoo_prerequisites() {
  printf "Nothing to do for "
  ansi::magenta "Gentoo"; 
  ansi::reset
  printf '.'
}

function dotfiles::install_prerequisites() {
  ui::h2 "Running linux tasks"
  dotfiles::_create_pgp_keypair 
  dotfiles::_create_git_config

  # Distribution-dependent tasks
  local distribution=$(cat /etc/*-release | grep "^NAME=" | cut -d '=' -f2)
  ui::h2 "Running tasks for distribution ${distribution}"

  case "${distribution}" in
    "Gentoo")
      dotfiles::_install_gentoo_prerequisites
      ;;
    *)
      echo "Unsupported distribution. Will not install anything"
  esac
}

function dotfiles::_create_pgp_keypair() {
  is::_ file "${HOME}/.ssh/id_rsa" && return $RC_OK

  ssh-keygen -t rsa -b 4096
}

function dotfiles::_create_git_config() {
  is::_ file "${HOME}/.gitconfig" && return $RC_OK

  echo "Creating git config"
  # TODO 
  # git config --global user.name ...
  # git config --global user.email ...
}


