#!/bin/bash

__kube_ps1()
{
  if [ -x "$(command -v kubectl)" ]; then
    if [ -f "${HOME}/.kube/config" ]; then
        CONTEXT=$(kubectl config current-context)
        NS=$(kubectl config view --minify | grep namespace:)
        if [ -z "$NS" ]; then
            NS=default
        fi
        if [ -n "$CONTEXT" ]; then
            echo "[${CONTEXT}:${NS}]"
        fi
    fi
  fi
}
 
set_prompt()
{
   # git-prompt location in fedora
   local gitprompt='/usr/share/git-core/contrib/completion/git-prompt.sh'
   if [ -f $gitprompt ]; then
     source $gitprompt
   fi
 
   local last_cmd=$?
   local reset='$(tput sgr0)'
   local bold='$(tput bold)'
   local black='$(tput setaf 0)'
   local red='$(tput setaf 1)'
   local green='$(tput setaf 2)'
   local yellow='$(tput setaf 3)'
   local blue='$(tput setaf 4)'
   local purple='$(tput setaf 5)'
   local cyan='$(tput setaf 6)'
   local white='$(tput setaf 7)'
   # unicode "✗"
   local fancyx='\342\234\227'
   # unicode "✓"
   local checkmark='\342\234\223'
   # Line 1: Full date + full time (24h)
   PS1="\[$bold\]\[$white\]\n\D{%A %d %B %Y %H:%M:%S}\n"
   # user@host
   PS1+="\[$green\]\u\[$white\] at \[$green\]\h"

   # k8s context and namespace
   PS1+="\[$blue\]$(__kube_ps1)\[$white\]"
 
   # current path
   # User color: red for root, yellow for others
   if [[ $EUID == 0 ]]; then
       PS1+="\[$red\]"
   else
       PS1+="\[$yellow\]"   
   fi
   PS1+=" \w"
 
   # green git branch
   PS1+="\[$cyan\]$(__git_ps1 ' (%s)')\[$white\]"
   # good old prompt, $ for user, # for root
   PS1+="\n\\$ "
}
PROMPT_COMMAND='set_prompt'
