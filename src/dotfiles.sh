include lib/core.sh
include lib/is.sh
include lib/log.sh
include lib/math.sh
include lib/os.sh
include lib/ui.sh

# TODO include from config
DOTFILES_REPOSITORY=https://github.com/moep/dotfiles
DOTFILES_SRC_DIR=${HOME}/.local/ports/dotfiles

# Should be overwritten via dotfiles/xxx.sh
function dotfiles::install_prerequisites() {
  echo
  echo "Nothing to do here."
  echo
}

function dotfiles::install_vim_plugins() {
  ui::h2 "Installing Vim plugins"
  # TODO decide how to handle nvim
  local plugin_dir="${HOME}/.config/nvim/pack/vendor/start"
  local plugin_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/nvim/pack/vendor/start"
  mkdir -p "${plugin_dir}" 

  # fzf needs fzf and fzf.vim
  echo -n "    fzf "
  os::exec_and_wait git clone --depth=1 https://github.com/junegunn/fzf ${plugin_dir}/fzf
  echo

  echo -n "    fzf.vim "
  os::exec_and_wait git clone --depth=1 https://github.com/junegunn/fzf.vim ${plugin_dir}/fzf.vim
  echo

  echo -n "    lightline "
  os::exec_and_wait git clone --depth=1 https://github.com/itchyny/lightline.vim ${plugin_dir}/lightline
  echo

  echo -n "    vim-buftabline "
  os::exec_and_wait git clone --depth=1 https://github.com/ap/vim-buftabline ${plugin_dir}/vim-buftabline
  echo

  echo -n "    comfortable-motion "
  os::exec_and_wait git clone --depth=1 https://github.com/yuttie/comfortable-motion.vim ${plugin_dir}/comfortable-motion
  echo

  echo -n "    tagbar "
  os::exec_and_wait git clone --depth=1 https://github.com/majutsushi/tagbar ${plugin_dir}/tagbar
  echo

  # Theme
  echo -n "    tender "
  os::exec_and_wait git clone --depth=1 https://github.com/jacoborus/tender.vim ${plugin_dir}/tender
  echo
}


function dotfiles::_clone() {
  ui::h2 "Cloning dotfiles repository from ${DOTFILES_REPOSITORY} into ${DOTFILES_SRC_DIR}" 

  if [[ -e "${DOTFILES_SRC_DIR}" ]]; then
    echo "Target direktory already exists. Skipping."
    return 
  else
    echo "mkdir -p ${DOTFILES_SRC_DIR}"
    mkdir -p ${DOTFILES_SRC_DIR}
  fi

  echo -n "Cloning"
  os::exec_and_wait git clone "${DOTFILES_REPOSITORY}" "${DOTFILES_SRC_DIR}"
  echo
}

function dotfiles::install_dotfile() {
  local src="${DOTFILES_SRC_DIR}/$1"
  local target="${HOME}/$1"

  if [[ -e "${target}" ]]; then
    cli::prompt_yn "Overwrite ${target}?" || return 1
  fi

  if [[ $ARG_SYMLINK == "true" ]]; then
    dotfiles::_symlink_dotfile "${src}" "${target}"
  else
    dotfiles::_copy_dotfile "${src}" "${target}"
  fi
}

function dotfiles::copy_dotfiles() {
  echo
  ui::h1 .files

  dotfiles::_clone || return $?

  dotfiles::install_dotfile .config 
  dotfiles::install_dotfile .gitconfig 
  dotfiles::install_dotfile .gitignore 
  dotfiles::install_dotfile .inputrc 
  dotfiles::install_dotfile .lessfilter 

}

function dotfiles::_symlink_dotfile() {
  local src=$1
  local target=$2

  echo -n "  Symlinking "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  ln -s $src $target
  echo
}


function dotfiles::_copy_dotfile() {
  local src=$1
  local target=$2

  echo -n "  Copying "; ansi::cyan; echo -n $src; ansi::reset; 
  ansi::bold; echo -n " ==> "; ansi::reset
  ansi::blue; echo -n $target; ansi::reset
  cp $src $target
  echo
}

function dotfiles::select_tty_theme() {
  dotfiles::install_additional_themes 
  local styles=()
  for f in ${DIR}/themes/tty/extra/*.sh; do
    styles+=("$(basename "$f")")
    #styles+=("$f")
  done

  local i=0
  local numStyles="${#styles[@]}"
  while true; do
    ansi::cls
    ansi::cur_pos 1 1
    source "${DIR}/themes/tty/extra/${styles[$i]}" 2> /dev/null
    dotfiles::_set_tty_colors 2> /dev/null

    ui::h2 "[$i] ${styles[i]}"

      # Prints all colors
    ansi::black '██ '
    ansi::red '██ '
    ansi::green '██ '
    ansi::yellow '██ '
    ansi::blue '██ '
    ansi::magenta '██ '
    ansi::cyan '██ '
    ansi::white '██ '
    echo
    ansi::bright_black '██ '
    ansi::bright_red '██ '
    ansi::bright_green '██ '
    ansi::bright_yellow '██ '
    ansi::bright_blue '██ '
    ansi::bright_magenta '██ '
    ansi::bright_cyan '██ '
    ansi::bright_white '██ '
    echo
    echo
    
    ansi::reset

    read -s -n1 input
    case $input in
      p)
        if [[ $i -ne 0 ]]; then
          i=$((i-1));
        fi
      ;;
      n)
        if [[ $i -lt $numStyles ]]; then
          i=$((i+1));
        fi
      ;;
      q)
        break
      ;;
    esac
  done

  echo "Pick a theme:"
  __MENU_ON_LINE_SELECT="dofiles::_on_menu_change" \
  ui::scroll_menu::show 79 5 "${menuLines[@]}"
  __MENU_ON_LINE_SELECT="dofiles::_on_menu_change" \
  ui::show_menu 'moep_dark' 'moep (dark)' \
                'moep_light' 'moep (light)' 
}

function dofiles::_on_menu_change() {
  #echo "$i: ${__MENU_VALUES[$__MENU_SELECTED_LINE]}"
  local selectedTheme="${__MENU_VALUES[$((__MENU_SELECTED_LINE+__MENU_SCROLL_OFFSET+1))]}" 
  #source "./themes/tty/${selectedTheme}.sh"
  source "${selectedTheme}" 2> /dev/null
  dotfiles::_set_tty_colors 2> /dev/null

  #source "${__MENU_VALUES[$__MENU_SELECTED_LINE]}"
}

function dotfiles::_set_tty_colors() {
  # see https://unix.stackexchange.com/questions/55423/how-to-change-cursor-shape-color-and-blinkrate-of-linux-console
  echo "Black: ${black}"
  tmux::escape "$(echo -en "\e]P0${black}")" 
  tmux::escape "$(echo -en "\e]P1${red}")"
  tmux::escape "$(echo -en "\e]P2${green}")"
  tmux::escape "$(echo -en "\e]P3${yellow}")"
  tmux::escape "$(echo -en "\e]P4${blue}")"
  tmux::escape "$(echo -en "\e]P5${magenta}")"
  tmux::escape "$(echo -en "\e]P6${cyan}")"
  tmux::escape "$(echo -en "\e]P7${white}")"

  tmux::escape "$(echo -en "\e]P8${brightBlack}")" 
  tmux::escape "$(echo -en "\e]P9${brightRed}")"
  tmux::escape "$(echo -en "\e]Pa${brightGreen}")"
  tmux::escape "$(echo -en "\e]Pb${brightYellow}")"
  tmux::escape "$(echo -en "\e]Pc${brightBlue}")"
  tmux::escape "$(echo -en "\e]Pd${brightMagenta}")"
  tmux::escape "$(echo -en "\e]Pe${brightCyan}")"
  tmux::escape "$(echo -en "\e]Pf${brightWhite}")"
  
  # Background color for xterm-like terminals
  #printf %b '\e]11;#xxxxxx\a'
  # Use color 0 as BG
  #printf %b '\e[40m' '\e[8]' '\e[H\e[J'

  # Set FG to color 8
  #printf %b '\e[38m' '\e[8]' '\e[H\e[J'
  
  # TODO if iterm2
  #iterm2::set_tab_color "${background}"
}
# Overwrite function definition with OS specific ones
echo "DEBUG $__OS_ARCH"
case "${__OS_ARCH}" in
  "Darwin")
    include src/dotfiles/osx.sh
  ;;
  "Linux")
    include src/dotfiles/linux.sh
  ;;
  "OpenBSD")
    include src/dotfiles/openbsd.sh
  ;;
  "FreeBSD")
    include src/dotfiles/freebsd.sh
  ;;
  *)
    printf "Unsupported OS."
    exit $RC_ERROR
    ;;
esac

function dotfiles::install_additional_themes() {
  local totalFiles=0
  local numProcessedFiles=1;
  local progressPercent=0
  local themeDir="tmp/iTerm2-Color-Schemes/xfce4terminal/colorschemes/"

  # Themes are already installed
  log::d "Checking for theme dir"
  if is::_ directory "${themeDir}"; then
    log::d "Found ${themeDir}"
    return;
  fi
  

  if cli::prompt_yn "Download additional Themes?" "n"; then
    ui::h2 "Installing additional themes"

    echo -n "    Cloning Color Schemes"
    os::exec_and_wait git clone "https://github.com/mbadolato/iTerm2-Color-Schemes.git" tmp/iTerm2-Color-Schemes
    if [[ "$?" != $RC_OK ]]; then
      echo
      log::e "Could not clone repository."
      log::w "Custom themes will not be available."
      return $RC_ERROR
    fi
    echo
    
    # This is where the converted themes are stored at
    if ! is::_ directory "themes/tty/extra/"; then
      log::d "Creating themes/tty/extra/"
      mkdir "themes/tty/extra/"
    fi

    # Print progress bar loop
    totalFiles=$(find "${themeDir}" -type f -name '*.theme' | wc -l)
    echo "    Converting ${totalFiles} Files"
    printf "    "
    ansi::cur_save
    for f in ${themeDir}/*.theme; do
      progressPercent=$(math::calc "($numProcessedFiles / $totalFiles) * 100")

      # Print progress bar
      ansi::cur_restore
      ui::progressbar::blue 40 "${progressPercent}"

      # Show percentage
      ansi::bg_256 8 
      ansi::reset_fg
      ansi::bold
      ansi::cur_col 50
      printf ' %03d%% ' "$(math::round ${progressPercent})"
      ansi::reset
      
      dotfiles::_convert_theme "$f"

      numProcessedFiles=$((numProcessedFiles+1))
    done
    
    # Show DONE / WARN
    ansi::cur_restore
    ansi::reset
    ansi::bold
    ansi::cur_col 50
    ansi::bg_256 2
    printf ' DONE '
    ansi::reset 

    echo
    ansi::reset
    ansi::delete_line
    echo
  fi
}

function dotfiles::_convert_theme() {
    local themeFile=$1
    local colorLine=$(grep "ColorPalette=" "$f" | cut -f2 -d '=')
    local colors=($(str::split ';' "${colorLine}"))
    local colorBackground=$(grep "ColorBackground=" "$f" | cut -f2 -d '=')
    local baseName=$(basename "$f" | cut -f1 -d '.')
    local outputFile="themes/tty/extra/${baseName}.sh"
    echo
    ansi::delete_line
    ansi::bright_blue
    echo "    Converting ${baseName}"

    touch "${outputFile}" 2> /dev/null
  
    # TODO bg, fg, cursor
    echo "# Automatically created" > "${outputFile}"
    echo "background='${colorBackground}'" >> "${outputFile}"

    # ${colors[0]#'#'} -> deletes # character
    echo "black='${colors[0]#'#'}'" >> "${outputFile}"
    echo "red='${colors[1]#'#'}'" >> "${outputFile}"
    echo "green='${colors[2]#'#'}'" >> "${outputFile}"
    echo "yellow='${colors[3]#'#'}'" >> "${outputFile}"
    echo "blue='${colors[4]#'#'}'" >> "${outputFile}"
    echo "magenta='${colors[5]#'#'}'" >> "${outputFile}"
    echo "cyan='${colors[6]#'#'}'" >> "${outputFile}"
    echo "white='${colors[7]#'#'}'" >> "${outputFile}"
    echo "brightBlack='${colors[8]#'#'}'" >> "${outputFile}"
    echo "brightRed='${colors[9]#'#'}'" >> "${outputFile}"
    echo "brightGreen='${colors[10]#'#'}'" >> "${outputFile}"
    echo "brightYellow='${colors[11]#'#'}'" >> "${outputFile}"
    echo "brightBlue='${colors[12]#'#'}'" >> "${outputFile}"
    echo "brightMagenta='${colors[13]#'#'}'" >> "${outputFile}"
    echo "brightCyan='${colors[14]#'#'}'" >> "${outputFile}"
    echo "brightWhite='${colors[15]#'#'}'" >> "${outputFile}"
  }
