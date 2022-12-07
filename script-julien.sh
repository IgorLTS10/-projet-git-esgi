#!/bin/bash

# option useradd (-u = id user, -s = shell /bin/bash, -d = dir, -m user = /home/user, -r = system user, -e = expiration date )
GREP=/bin/grep

# currentDate=date +"%m-%d-%y"

addUser() {
    useradd -u $identifiant -e $date -d $path -s /bin/bash $username
}

username(){
    
    while [ -z "$username" ]
    do
        read  -p "Enter Username: " username
        [ -z "$username" ] && echo 'Username is empty; try again.'
    done
    $GREP -i $username /etc/passwd
    
    if [ $? == 0 ]
    then
        echo "$username, is already a user"
        exit 0
    fi
}

path(){
    while [ -z "$path" ]
    do
        read -p "Enter path: " path
        [ -z "$path" ] && echo 'Path is empty ! Try again.'
    done
    
    if [ -d $path ]
    then
        echo "Path already exists."
        exit 0
    fi
}

shell(){
    while [ -z "$path" ]
    do
        read  -p "Enter shell: " shell
        [ -z "$shell" ] && echo 'Shell is empty ! Try again.'
    done
}

date(){
    
    while [ -z "$date" ]
    do
        read -p "Enter a date (YYYY-mm-dd):" date
        [ -z "$date" ] && echo 'date is empty ! Try again.'
    done
}

identifiant(){
    while [ -z "$identifiant" ]
    do
        read -p "Enter identifiant (number):" identifiant
        [ -z "$identifiant" ] && echo 'identifiant is empty ! Try again.'
    done
}

password(){
        echo "Enter password for $username"
        sudo passwd $username
}

createUser()
{
    username;
    echo $username
    path;
    echo $path
    shell;
    echo $shell
    date;
    echo $date
    identifiant;
    echo $identifiant
    addUser;
    password;
    cat /etc/passwd | grep $username && chage -l $username
    echo "User created!"
}

modifyUser() {
    
    echo "Enter name for modify user ?"
    read modify_user
    
    $GREP -i $modify_user /etc/passwd
    
    if [ $? == 0 ]
    then
        username;
        echo $username
        path;
        echo $path
        shell;
        echo $shell
        date;
        echo $date
        identifiant;
        echo $identifiant
        addUser;
        password;
        cat /etc/passwd | grep $username && chage -l $username
        echo "User modify!"
    else
        echo "$modify_user does not exist!"
    fi
    
}

deleteUser(){
    
    echo "Enter name for delete user ?"
    read user_name
    
    $GREP -i $user_name /etc/passwd
    
    if [ $? == 0 ]
    then
        echo "Are you sure for delete $user_name ? [y/n]"
        read response
        if [ $response == "y" ]
        then
            echo "Delete folder the $user_name ? [y/n]"
            read responseTwo
            if [ $responseTwo == "y" ]
            then
                sudo userdel -r $user_name
                echo "$user_name deleted!"
            else
                sudo userdel $user_name
            fi
            cat /etc/passwd
            exit 0
        fi
    else
        echo "$user_name does not exist!"
    fi
}

echo "------------------------------"
echo "| 1) Create User             |"
echo "------------------------------"
echo "| 2) Modify User             |"
echo "-----------------------------"
echo "| 3) Delete User             |"
echo "------------------------------"
echo "| 4) Exit                    |"
echo "------------------------------"
echo "Please enter your choice: "

read name

case $name in
    1) createUser;;
    2) modifyUser;;
    3) deleteUser;;
    4) exit;;
esac