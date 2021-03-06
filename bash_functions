
# Functions
format_code() { indent -linux -i3 -nut -l120 -fc1 < "$1" -o formatted.c; echo "New output file in formatted.c";}
finder() { find . -iname "$1*" -print;}
hello() { echo 'Hello world!' ; }
function proxy_check {
   echo ${http_proxy} | cut -c 8-12
#  ps aux | grep httpd | grep -v grep | wc -l
}



##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_pwd() {
    # How many characters of the $PWD should be kept
    local pwdmaxlen=25
    # Indicate that there has been dir truncation
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [ ${pwdoffset} -gt "0" ]
    then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi
}

bash_prompt() {

#   bash_prompt_pwd

   local NONE="\[\033[0m\]"

   # regular colors
   local K="\[\033[0;30m\]"    # black
   local R="\[\033[0;31m\]"    # red
   local G="\[\033[0;32m\]"    # green
   local Y="\[\033[0;33m\]"    # yellow
   local B="\[\033[0;34m\]"    # blue
   local M="\[\033[0;35m\]"    # magenta
   local C="\[\033[0;36m\]"    # cyan
   local W="\[\033[0;37m\]"    # white

   # emphasized (bolded) colors
   local EMK="\[\033[1;30m\]"
   local EMR="\[\033[1;31m\]"
   local EMG="\[\033[1;32m\]"
   local EMY="\[\033[1;33m\]"
   local EMB="\[\033[1;34m\]"
   local EMM="\[\033[1;35m\]"
   local EMC="\[\033[1;36m\]"
   local EMW="\[\033[1;37m\]"

   # background colors
   local BGK="\[\033[40m\]"
   local BGR="\[\033[41m\]"
   local BGG="\[\033[42m\]"
   local BGY="\[\033[43m\]"
   local BGB="\[\033[44m\]"
   local BGM="\[\033[45m\]"
   local BGC="\[\033[46m\]"
   local BGW="\[\033[47m\]"

   #depend on type of user
   local UC=$G       # user's color
   [ $UID -eq "0" ] && UC=$G  # root's color

   #git branch stuff
   # for mac
   export __git_ps1="git branch 2>/dev/null | grep '*' | sed 's/* \(.*\)/(\1)/'"
   export GIT_PS1_SHOWDIRTYSTATE=1
   BRANCH='$(__git_ps1)'
   #
   #BRANCH= '$(declare -F __git_ps1 &>/dev/null && __git_ps1 " (%s)")'

# With User
#   export PS1="$UC[\t \u@\h] $C[${NEW_PWD}] $Y$BRANCH\$ ${NONE}"
# No User
# Add proxy_setting
   if [ -z ${DOCKER_HOST} ]; then
        export PS1="$B[\h]$W[\w]$C$BRANCH$Y\`proxy_check\`$Y\$ ${NONE}"
    else
        export PS1="$G[DOCKER_ENV]$W[\w]$C$BRANCH$Y\`proxy_check\`$G\$ ${NONE}"
    fi
}


bash_prompt
