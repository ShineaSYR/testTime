#!/usr/bin/env sh

_() {
  YEAR="2024"
  tabs 3
  
  echo
  printf "\tStep 0: \e]8;;https://github.com/new\e\\Create a new repo (Ctrl/CMD + Click)\e]8;;\e\\ \n"
  echo
  echo "\tStep 1: Pick your preferred git login method"
  echo
  PS3="Please enter 1 or 2: "
  options=("HTTPS (GitHub Access Token)" "SSH")
  select opt in "${options[@]}"
  do
      case $opt in
          "HTTPS (GitHub Access Token)")
              echo
              printf "\tStep 2: \e]8;;https://github.com/settings/tokens/new\e\\Generate a personal access token (Ctrl/CMD + Click)\e]8;;\e\\ \n"
              echo "\t\t\t  Copy and paste it below: "
              read -r ACCESS_TOKEN
              [ -z "$ACCESS_TOKEN" ] && exit 1
              echo
              echo "\tStep 3: Please enter your GitHub username: "
              read -r USERNAME
              [ -z "$USERNAME" ] && exit 1
              echo
              echo "\tStep 4: Please enter the name of the repo you created in Step 0: "
              read -r USERNAME
              [ -z "$USERNAME" ] && exit 1
              break
              ;;
          "SSH")
              echo
              echo "\tStep 2: Copy the SSH link to your repo and paste it below"
              read -r REPO_LINK
              [ -z "$REPO_LINK" ] && exit 1
              USERNAME=${REPO_LINK%/*} # remove suffix after "/"
              USERNAME=${USERNAME#*:} # remove prefix before ":"
              break
              ;;
          *) echo "invalid option $REPLY, please enter 1 or 2";;
      esac
  done

  [ ! -d $YEAR ] && mkdir $YEAR

  cd "${YEAR}" || exit
  git init
  echo
  echo "\tLast Step: Would you like to add a message to your ${YEAR} repo README? :-) (if not, just press Enter)"
  read -r README
  [ -z "$README" ] && \
    echo "Generated by https://github.com/XueMeijing/1969-script" >README.md || \
      echo "$README \n Generated by https://github.com/XueMeijing/1969-script" > README.md
  git add .
  GIT_AUTHOR_DATE="${YEAR}-01-01T08:00:00" \
    GIT_COMMITTER_DATE="${YEAR}-01-01T08:00:00" \
    git commit -m "${YEAR}"
    [ -z "$REPO_LINK" ] && \
      git remote add origin "https://${ACCESS_TOKEN}@github.com/${USERNAME}/${REPONAME}.git" || \
        git remote add origin "${REPO_LINK}"
  git branch -M main
  git push -u origin main -f
  cd ..
  rm -rf "${YEAR}"

  echo
  echo "Cool, check your profile now: https://github.com/${USERNAME}"
} && _

unset -f _