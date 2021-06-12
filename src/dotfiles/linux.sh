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

function dotfiles::_install_ubuntu_prerequisites() {
  local basic_pgms=(fish fzf git htop ncdu neovim ranger ripgrep tmux)
  local sudo_cmd="sudo"

  echo " [*] sudo apt update"
  sudo apt update

  echo " [*] sudo apt install ${basic_pgms[@]}"
  sudo apt install "${basic_pgms[@]}"
}

function dotfiles::install_prerequisites() {
  ui::h2 "Running linux tasks"
  dotfiles::_create_pgp_keypair 
  dotfiles::_create_git_config

  # Distribution-dependent tasks
  local distribution=$(cat /etc/*-release | grep "^NAME=" | cut -d '=' -f2 | tr -d '"')
  ui::h2 "Running tasks for distribution ${distribution}"

  case "${distribution}" in
    "Gentoo")
      dotfiles::_install_gentoo_prerequisites
      ;;
    "Ubuntu")
      dotfiles::_install_ubuntu_prerequisites
      ;;
    *)
      echo "Unsupported distribution. Will not install anything."
      ;;
  esac
  
  ui::h2 "Creating user ports"

  echo -n "    delta"
  os::exec_and_wait dotfiles::_install_delta
  echo
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

function dotfiles::_install_delta() {
  local tmp_dir=$(mktemp -d) 
  cd ${tmp_dir} || return $RC_FAIL
  curl -LO https://github.com/dandavison/delta/releases/download/0.8.0/delta-0.8.0-x86_64-unknown-linux-gnu.tar.gz || return $RC_FAIL
  tar xvzf delta-0.8.0-x86_64-unknown-linux-gnu.tar.gz

  mkdir -p ~/.local/bin > /dev/null
  cp delta-0.8.0-x86_64-unknown-linux-gnu/delta ~/.local/bin

  return $?
}
