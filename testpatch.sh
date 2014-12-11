#!/bin/bash
##
# Runs the current branch phpunit and behat tests.
#
# Uses:
#   git remote show travis
#   git@github.com:dmonllao/moodle-to-travis.git
#   ~/my-ubuntu-defaults/travis/moodle.yml
#
# Example:
#   mootestandforget
##
function mootestandforget {

    # Check that there is a travis remote.
    git remote show | grep "travis" > /dev/null || \
        return "A git remote named 'travis' pointing to git@github.com:ankitagarwal/scripts.git is needed"

    # Check the travis file exists.
    travisyml=/var/www/scripts/.travis.yml
    if [ ! -f "$travisyml" ]; then
        return $travisyml' does not exist!'
    fi

    # Just in case.
    currentbranch=$(git rev-parse --abbrev-ref HEAD)
    if [ -z "$currentbranch" ]; then
        return "No current branch?"
    fi

    newbranch=$currentbranch'-travis'

    # Create a tmp branch from the current one to fuck it up.
    git checkout -b $newbranch 2> /dev/null > /dev/null || git branch -D $newbranch > /dev/null  ; git checkout -b $newbranch > /dev/null

    cp $travisyml .travis.yml
    git add .travis.yml
    git commit .travis.yml -m 'Testing '$currentbranch' in Travis CI' > /dev/null
    git push travis $newbranch -f > /dev/null

    # And return to the current branch.
    git checkout $currentbranch > /dev/null
    git branch -D $newbranch > /dev/null
}