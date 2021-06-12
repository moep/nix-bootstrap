
include lib/core.sh
include lib/cli.sh
include lib/os.sh


function dotfiles::install_prerequisites() {
  ui::h2 "Running FreeBSD tasks"
  
  if cli::prompt_yn "Install recommended programms?" "y"; then 
    doas pkg install bash coreutils curl fish git glow ranger ripgrep w3m zathura-pdf-mupdf
  fi

  if cli::prompt_yn "Install fzf?" "y"; then
    dotfiles::_install_fzf;
  fi

}

function dotfiles::_install_fzf() {
  echo "TODO"
}

