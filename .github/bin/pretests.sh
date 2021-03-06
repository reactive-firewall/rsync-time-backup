#! /bin/bash
# Disclaimer of Warranties.
# A. YOU EXPRESSLY ACKNOWLEDGE AND AGREE THAT, TO THE EXTENT PERMITTED BY
#    APPLICABLE LAW, USE OF THIS SHELL SCRIPT AND ANY SERVICES PERFORMED
#    BY OR ACCESSED THROUGH THIS SHELL SCRIPT IS AT YOUR SOLE RISK AND
#    THAT THE ENTIRE RISK AS TO SATISFACTORY QUALITY, PERFORMANCE, ACCURACY AND
#    EFFORT IS WITH YOU.
#
# B. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THIS SHELL SCRIPT
#    AND SERVICES ARE PROVIDED "AS IS" AND “AS AVAILABLE”, WITH ALL FAULTS AND
#    WITHOUT WARRANTY OF ANY KIND, AND THE AUTHOR OF THIS SHELL SCRIPT'S LICENSORS
#    (COLLECTIVELY REFERRED TO AS "THE AUTHOR" FOR THE PURPOSES OF THIS DISCLAIMER)
#    HEREBY DISCLAIM ALL WARRANTIES AND CONDITIONS WITH RESPECT TO THIS SHELL SCRIPT
#    SOFTWARE AND SERVICES, EITHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT
#    NOT LIMITED TO, THE IMPLIED WARRANTIES AND/OR CONDITIONS OF
#    MERCHANTABILITY, SATISFACTORY QUALITY, FITNESS FOR A PARTICULAR PURPOSE,
#    ACCURACY, QUIET ENJOYMENT, AND NON-INFRINGEMENT OF THIRD PARTY RIGHTS.
#
# C. THE AUTHOR DOES NOT WARRANT AGAINST INTERFERENCE WITH YOUR ENJOYMENT OF THE
#    THE AUTHOR's SOFTWARE AND SERVICES, THAT THE FUNCTIONS CONTAINED IN, OR
#    SERVICES PERFORMED OR PROVIDED BY, THIS SHELL SCRIPT WILL MEET YOUR
#    REQUIREMENTS, THAT THE OPERATION OF THIS SHELL SCRIPT OR SERVICES WILL
#    BE UNINTERRUPTED OR ERROR-FREE, THAT ANY SERVICES WILL CONTINUE TO BE MADE
#    AVAILABLE, THAT THIS SHELL SCRIPT OR SERVICES WILL BE COMPATIBLE OR
#    WORK WITH ANY THIRD PARTY SOFTWARE, APPLICATIONS OR THIRD PARTY SERVICES,
#    OR THAT DEFECTS IN THIS SHELL SCRIPT OR SERVICES WILL BE CORRECTED.
#    INSTALLATION OF THIS THE AUTHOR SOFTWARE MAY AFFECT THE USABILITY OF THIRD
#    PARTY SOFTWARE, APPLICATIONS OR THIRD PARTY SERVICES.
#
# D. YOU FURTHER ACKNOWLEDGE THAT THIS SHELL SCRIPT AND SERVICES ARE NOT
#    INTENDED OR SUITABLE FOR USE IN SITUATIONS OR ENVIRONMENTS WHERE THE FAILURE
#    OR TIME DELAYS OF, OR ERRORS OR INACCURACIES IN, THE CONTENT, DATA OR
#    INFORMATION PROVIDED BY THIS SHELL SCRIPT OR SERVICES COULD LEAD TO
#    DEATH, PERSONAL INJURY, OR SEVERE PHYSICAL OR ENVIRONMENTAL DAMAGE,
#    INCLUDING WITHOUT LIMITATION THE OPERATION OF NUCLEAR FACILITIES, AIRCRAFT
#    NAVIGATION OR COMMUNICATION SYSTEMS, AIR TRAFFIC CONTROL, LIFE SUPPORT OR
#    WEAPONS SYSTEMS.
#
# E. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY THE AUTHOR
#    SHALL CREATE A WARRANTY. SHOULD THIS SHELL SCRIPT OR SERVICES PROVE DEFECTIVE,
#    YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.
#
#    Limitation of Liability.
# F. TO THE EXTENT NOT PROHIBITED BY APPLICABLE LAW, IN NO EVENT SHALL THE AUTHOR
#    BE LIABLE FOR PERSONAL INJURY, OR ANY INCIDENTAL, SPECIAL, INDIRECT OR
#    CONSEQUENTIAL DAMAGES WHATSOEVER, INCLUDING, WITHOUT LIMITATION, DAMAGES
#    FOR LOSS OF PROFITS, CORRUPTION OR LOSS OF DATA, FAILURE TO TRANSMIT OR
#    RECEIVE ANY DATA OR INFORMATION, BUSINESS INTERRUPTION OR ANY OTHER
#    COMMERCIAL DAMAGES OR LOSSES, ARISING OUT OF OR RELATED TO YOUR USE OR
#    INABILITY TO USE THIS SHELL SCRIPT OR SERVICES OR ANY THIRD PARTY
#    SOFTWARE OR APPLICATIONS IN CONJUNCTION WITH THIS SHELL SCRIPT OR
#    SERVICES, HOWEVER CAUSED, REGARDLESS OF THE THEORY OF LIABILITY (CONTRACT,
#    TORT OR OTHERWISE) AND EVEN IF THE AUTHOR HAS BEEN ADVISED OF THE
#    POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION
#    OR LIMITATION OF LIABILITY FOR PERSONAL INJURY, OR OF INCIDENTAL OR
#    CONSEQUENTIAL DAMAGES, SO THIS LIMITATION MAY NOT APPLY TO YOU. In no event
#    shall THE AUTHOR's total liability to you for all damages (other than as may
#    be required by applicable law in cases involving personal injury) exceed
#    the amount of five dollars ($5.00). The foregoing limitations will apply
#    even if the above stated remedy fails of its essential purpose.
################################################################################

# bootstrap checks (pre pre-checks)
EXIT_CODE=0

test -x `command -v uname` || exit 1 ;
test -x `command -v git` || exit 1 ;

if [[ ( $(uname -s) = "Darwin" ) ]] ; then
	export CI_OS_NAME="osx" ;
else
	export CI_OS_NAME="linux" ;
fi


# if locking was needed:
####
# ulimit -t 600
# PATH="/bin:/sbin:/usr/sbin:/usr/bin"
# umask 137
#
# LOCK_FILE="/tmp/pre_test_script_lock"
# 
# if [[ -f ${LOCK_FILE} ]] ; then
# 	exit 0 ;
# fi
# 
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 1 ;' SIGABORT
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 1 ;' SIGHUP
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 1 ;' SIGTERM
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 1 ;' SIGQUIT
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 1 ;' SIGINT
# trap 'rm -f ${LOCK_FILE} 2>/dev/null || true ; wait ; exit 0 ;' EXIT
# 
# touch ${LOCK_FILE} 2>/dev/null || exit 0 ;

# THIS IS THE ACTUAL WORK:

# use this for codecov.io if enabled
#export CODECOV_TOKEN="" ;
# use for a github token if enabled (USE HARDCODE AT OWN RISK)
#export GITHUB_TOKEN="" ;
export CI=true ; # we are running CI
export CONTINUOUS_INTEGRATION=true ;
# if you run on-prem
#export GITLAB_CI=true ;
# get the repository name
export CI_REPO=$(basename `git rev-parse --show-toplevel`) ;
export CI_BRANCH=$(git symbolic-ref --short HEAD ) ;
export GIT_BRANCH=$(git symbolic-ref --short HEAD ) ;
export BRANCH_NAME=$(git symbolic-ref --short HEAD) ;
export SOURCE_BRANCH=$(git symbolic-ref --short HEAD ) ;
export CF_BRANCH=$(git symbolic-ref --short HEAD ) ;
export CIRCLE_BRANCH=$(git symbolic-ref --short HEAD ) ;
export APPVEYOR_REPO_BRANCH=$(git symbolic-ref --short HEAD ) ;
export TEAMCITY_BUILD_BRANCH=$(git symbolic-ref --short HEAD ) ;
export VCS_BRANCH_NAME=$(git symbolic-ref --short HEAD ) ;
export TRAVIS_BRANCH=$(git symbolic-ref --short HEAD ) ;
# Next line commented as this can mess with codecov if in use
# export WERCKER_GIT_BRANCH=$(git symbolic-ref --short HEAD ) ;
export TRAVIS_OS_NAME="${TRAVIS_OS_NAME:-${CI_OS_NAME}}" ;
export TRAVIS_PYTHON_VERSION=$($(command -v python) --version 2>&1 3>&1 | head -n 1 | grep -oE "[0-9]+.[0-9]+" | head -n 1 ) ;
export TRAVIS_COMMIT=$(git rev-parse --verify HEAD)
export CI_BUILD_ID=$(git rev-list --all --count)
export CI_BUILD_REF=$(git rev-parse --verify HEAD)
export CI_JOB_ID=$(date '+%y%m%d%H%M%S')
export CI_COMMIT_NAME=$(git symbolic-ref --short HEAD ) ;
# used by some tools to link back to this build's log
#export CI_BUILD_URL="https://localhost:443/codecov/fake/ci/build/${CI_BUILD_ID}/${CI_JOB_ID}"
export VCS_COMMIT_ID=$(git rev-parse --verify HEAD)
export GITHUB_USER=$(git config --get user.name)
export GITHUB_REPO=$(basename `git rev-parse --show-toplevel`) ;
export GITHUB_COMMENTS_URL="https://api.github.com/repos/${GITHUB_USER}/${GITHUB_REPO}/commits/${CI_BUILD_REF}/comments"

##############################
# can more run setup code here
##############################
# ideas: pull down resources need for tests like docker images or test tools

# if locking is used: clean up here
####
# rm -f ${LOCK_FILE} >/dev/null || true ; wait ;

# goodbye
exit ${EXIT_CODE:-255} ;
