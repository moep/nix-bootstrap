include lib/core.sh
include lib/cli.sh
include lib/os.sh


function dotfiles::install_prerequisites() {
  ui::h2 "Running OpenBSD tasks"

  # TODO ranger
  if cli::prompt_yn "Install recommended programms?" "y"; then 
    doas pkg_add bash coreutils curl fish git ripgrep tmux w3m 
  fi

  if cli::prompt_yn "Install fzf?" "y"; then
    dotfiles::_install_fzf;
  fi

}

function dotfiles::_install_fzf() {
  echo "TODO"
}

