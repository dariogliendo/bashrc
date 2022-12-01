alias gs='git status'
alias gs-u='git status --untracked-files=all'
alias nvmpenta='nvm use 12.18.0'
alias gupdate='git fetch && git merge origin/master'

eval "$(starship init bash)"

INSTDATE=`date '+%A %d-%B, %Y'`
HOSTNAME=$(hostname)
echo "Hola $HOSTNAME, hoy es $INSTDATE"

mcommit() { 
  BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
  read -p "Introduzca el mensaje: " MSG_INPUT
  MESSAGE="[$BRANCH_NAME] $MSG_INPUT"
  git add . && git commit -a -m "$MESSAGE" && git push
  echo 
  read -p "Mergear a dev? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then 
    echo
    echo "Se finalizó sin mergear a dev"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
  else
    git checkout dev2023 && git fetch && git merge origin/master && git merge origin/$BRANCH_NAME
    echo
    echo "Merge completado!"
  fi
}