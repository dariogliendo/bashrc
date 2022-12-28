alias gs='git status'
alias gs-u='git status --untracked-files=all'
alias nvmpenta='nvm use 12.18.0'
alias gupdate='git fetch && git merge origin/master'

eval "$(starship init bash)"

INSTDATE=`date '+%A %d-%B, %Y'`
HOSTNAME=$(hostname)
echo "Hola $HOSTNAME - $INSTDATE"

mcommit() { 
  BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
  read -p "Introduzca el mensaje: " MSG_INPUT
  MESSAGE="[$BRANCH_NAME] $MSG_INPUT"
  git add . && git commit -a -m "$MESSAGE" && git push --set-upstream origin $BRANCH_NAME
  echo 
  read -p "Mergear a dev? (y/n) " -n 1 -r
  if [[ ! $REPLY =~ ^[Yy]$ ]];
  then
    # Si NO desea mergear a dev
    echo
    echo "Se finalizo sin mergear a dev"
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
  else
    # Si SI desea mergear a dev
    git checkout dev2023
    git fetch
    git merge origin/master
    git pull 
    MERGE_RESULT=`git merge origin/$BRANCH_NAME`
    echo
    echo "Merge completado!"
    echo
    if [[ ! "$MERGE_RESULT" =~ .*"CONFLICT".* ]];
    then
      # Si NO hay conflictos
      read -p 'Parece que no hay conflictos. Pushear a dev? (y/n) ' -n 1 -r FINAL_PUSH
      if [[ ! $FINAL_PUSH =~ ^[Yy]$ ]];
      then
        # Si NO desea pushear
        echo
        echo 'Saliendo sin pushear'
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
      else
        # Si SI desea pushear
        git push
        echo 'Listo!'
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
      fi
    else
      # Si SI hay conflictos
      read -p 'Hay conflictos. Desea abortar el merge? (y/n) ' -n 1 -r ABORT
      if [[ ! $ABORT =~ ^[Yy]$ ]];
      then
        #Si NO desea abortar
        echo
        echo 'Resuolver conflictos antes de continuar'
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
      else
        #Si SI desea abortar
        git merge --abort
        echo
        echo 'Se abortó el merge. Saliendo'
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
      fi
    fi
  fi
}
