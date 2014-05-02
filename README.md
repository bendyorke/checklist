#Checklist
A simple daily reminders app integrated with the command line

##Overview
Add tasks to complete daily.  There are 3 states of a task:
 - Completed
 - Due
 - Overdue

Each task has a time that it is due.  1 hour (can be set - see below) before the time set, it will be added to the count (which shows up in the prompt) and marked as 'due'.  If the task is overdue, a "!" will be added to the number (or it will show up in red if using the colored version)

##Setup

####Setup executable
Clone the repo and set up a symlink
```
$ cd ~
$ git clone https://github.com/bendyorke/checklist.git
$ ln -s ~/checklist/check /usr/local/bin/check
```
*This will by default create the csv database in /usr/local/checklist.csv.  This can be overwritten - see below*

####Setup zsh
There are two ways to set up zsh:
Greyscale (less intrusive method):
```
$ echo "RPROMPT=\$(check -g)" >> ~/.zshrc
```

Color (more intrusive - RPOMPT is overwritten each command):
```
$ echo "function precmd {\n\tRPROMPT=\$(check -z);\n}" >> ~/.zshrc
```
or copy and paste the following function
```
function precmd {
  RPROMPT=$(check -z);
}
```

####Setup bash
Currently only greyscale works in bash, colors will be added soon
Greyscale:
```
$ echo "PS1="\$(check -g)$PS1" >> ~/.bashrc
```
*This will prepend the numbers to PS1.  A RPROMPT solution for bash is in the works :)*

####Setup fish
Currently only greyscale works in fish, colors will be added soon
Add the following to your fish config (default: ~/.config/fish/config.fish)
```
function fish_right_prompt
  echo -n (check -g)
end
```

##How to use

`$ check -h` is always availiable to see an overview

####Creating tasks
```
$ check -n
Please enter a name
> [enter a name here.  This is what it will be referred to]
Please enter a time
> [enter a time here, any format works. I prefer (H)H:MM mm]
```
And thats it!

####Listing tasks
```
$ check -l
```
Will list all the tasks, their time, and when they were last completed

####Completing tasks
```
$ check
[time]: [name] (y/n)
> [y/n]
```
Loops through all due and overdue tasks.  Pressing return without entering a value is the same as typing 'y' - it marks the task as complete

####Completing all tasks
```
$ check -a
```
Checks all due and overdue tasks as complete

####Deleting tasks
```
$ check -d
Type the name of the task which you want to delete
> [name]
```
Deletes the task permenantly.  Case sensative, must be an exact match

##Variables
```
checklist_file   : path to the csv where you want to store the tasks
checklist_window : time in seconds before a tasks time that you are notified
```
