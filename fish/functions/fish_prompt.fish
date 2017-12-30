function fish_prompt
  set -l _display_status $status

  set_color $fish_color_cwd
  echo -n (prompt_pwd)
  set_color normal
  if  [ $_display_status -eq 0 ]
    echo -n " 👾  "
  else 
    echo -e " 💩  "
  end
end
