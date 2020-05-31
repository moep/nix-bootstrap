include lib/core.sh

function dotfiles::_install_gentoo_prerequisites() {
  printf "Nothing to do for "
  ansi::magenta "Gentoo"; 
  ansi::reset
  printf '.'
}

function dotfiles::install_prerequisites() {
  ui::h2 "Running specific linux tasks..."

  local distribution=$(cat /etc/*-release | grep "^NAME=" | cut -d '=' -f2)

  case "${distribution}" in
    "Gentoo")
      dotfiles::_install_gentoo_prerequisites
      ;;
    *)
      echo "Unsupported distribution. Will not install anything"
  esac
}


