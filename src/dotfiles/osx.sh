include lib/core.sh

function dotfiles::install_prerequisites() {
  ui::h2 "Preparing OSX"

  if ! os::is_installed? brew; then
    "Installing homebrew ..."

    # Hombrew installation script needs ruby 
    core::assert_available ruby

    os::exec_and_wait ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  
  # Make sure we install the latest versions
  echo -n "Updating homebrew "
  os::exec_and_wait brew update
  echo 

  # Since OSX only comes with bash 3 it needs to be "replaced" with a newer one
  if [[ $BASH_VERSINFO -lt 4 ]]; then 
    echo -n "Installing bash "
    os::exec_and_wait brew install bash
    
    if [[ $? != $RC_OK ]]; then
      exit $RC_ERROR
    fi
  fi
  
  echo
}


