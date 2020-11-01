include lib/core.sh
include lib/cli.sh
include lib/os.sh


function dotfiles::install_prerequisites() {
  ui::h2 "Running OpenBSD tasks"
  
  cli::prompt_yn "Install recommended programms?" "y" || return 0
  doas pkg_add bash colorls curl fish fzf git ranger ripgrep w3m 


}

