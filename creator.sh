#!/bin/bash

usage () {
    echo "Project Creator v1.0"
    echo "    -h | show this text"
    echo "    -l | list projects"
    echo "    -n | create new project"
    exit
}

git_init() {
    echo "Initializing git"
    cd $1

    case $4 in
        "go" )
            read -p "What libraries? " libs
            imports=$(echo "$libs" | sed "s/,/\\\\\" \\\\,\\\\\
    \\\\\"/g" | sed 's/\//\\\//g' | tr , '\n')
            echo "$imports"
            sed "s/NAME/$2/g" /Users/jamesnewman/Desktop/PersonalProjects/ProjectCreator/templates/golang.go | sed "s/\"IMPORTS\"/\"$imports\"/g" > $1/$2.go
            cat $1/$2.go
            exit
            ;;
    esac

    if [[ $confirm == [yY] ]]; then 
        git init
        git add README.md
        git commit -m "first commit"
        git branch -M main
        git remote add origin https://github.com/newmanjt/$2.git
        git push --set-upstream origin main
    fi
    cd - > /dev/null
}

list () {
    echo "Listing Projects"
}

clear_projects () {
    rm -rf /Users/jamesnewman/Desktop/PersonalProjects/projects/*
}

new () {
    echo "Creating New Project"
    project_id=$(date +%s)
    project_dir="/Users/jamesnewman/Desktop/PersonalProjects/projects/"$project_id
    mkdir -p $project_dir
    readme_file=$project_dir"/README.md"
    read -p "Enter Project Name: " project_name 
    echo "$project_name" >> $readme_file
    read -p "Project Description: " project_descr
    echo "**********" >> $readme_file
    echo "$project_descr" >> $readme_file
    read -p "Project Languages: " project_lang
    read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
    echo "Committing new project"
    read -p "Have you created the repo? (Y/N): " confirm
    git_init $project_dir $project_name $confirm $project_lang
    echo "$project_dir,$project_name,$confirm" >> "./table_of_contents.txt"
    vim $project_dir
}

while [ "$1" != "" ]; do
    case $1 in 
        -h ) usage
            shift
            ;;
        -l | --list ) list
            shift
            ;;
        -n | --new ) new
            shift
            ;;
        -c | --clear ) clear_projects
            shift
            ;;
        * )
            shift
            ;;
    esac
done
