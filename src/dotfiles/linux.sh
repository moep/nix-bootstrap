include lib/core.sh
include lib/cli.sh
include lib/os.sh

# TODO should be part of a separate script
function dotfiles::_install_gentoo_prerequisites() {
  local basic_pgms=(eix fzf git genlop gentoolkit htop layman ncdu neovim ranger ripgrep tmux ufed)
  local sudo_cmd="sudo"

  # We need sudo or doas for the next steps
  if ! os::is_installed? sudo; then
    core::assert_available doas
    sudo_cmd="doas"
  fi

  echo " [*] emerge --sync "
  #$sudo_cmd emerge --sync
  
  # TODO prevent re-emerge
  echo " [*] emerge ${basic_pgms[@]}"
  #"${sudo_cmd}" emerge -qa "${basic_pgms[@]}"

  if cli::prompt_yn "Install fish?" y; then
    echo " [*] emerge fish"
    #"${sudo_cmd}" emerge -qa fish
  fi

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


