# CouchPotato Movie Downloader

CouchPotato is a web program, built on python, specifically tailored towards automating Movie Downloads, either through public or private torrent sites or using Usenet Services.

Its a beautifully written program, works amazingly well, and is honestly fun to use.

## Shoutout

First, I'd like to go ahead and say that I wouldn't have been able to learn as much as I have as quickly or easily without the help of [HTPCGuides.com][04a25565]. They are an amazing site, they are slowly getting larger, and they are the real, awesome source. My files are more for me, they are better written for everyone. [^Sourcing]

## Base Requirements

First, lets install the basic required programs to help run all-the-things

```bash
sudo apt-get install git-core libffi-dev libssl-dev zlib1g-dev libxslt1-dev libxml2-dev python python-pip python-dev build-essential -y
sudo pip install --upgrade lxml cryptography pyopenssl
```

!!! note
    When running pip with sudo, that then installs those specified programs globally, so the entire system has access.

    If you are using a more shared environment - where your pip install might interfere with another users python programs - its best to invoke virtualenv from within the directory you are going to save and run the main CouchPotato program from.

    This creates a virtual-like environment for installing your python programs within JUST that directory. So, if there are differing versions elsewhere, they wont clash.

    Currently, I am not using virtualenv, so that is currently outside the scope of this document.

## Clone the Repo

Now, to really kick things off, we're going to first clone the github repo, as this is the - well, only way right now - to install and run the software.

But, the other big plus to this is that for running updates, not only does the program have the ability to simply run `git pull` or what have you from within itself, but if that isn't pulling a fresher update due to other various settings it has, YOU are able to go in and just run `git pull` on the CouchPotato directory.

Which, is why...

!!! note "Custom Repo Location"
    I keep all of my cloned git repos inside of one, singular directory:

    `~/git`

    This way, I don't have to hunt all over my system for where my repo's are and it makes it easier to keep them updated. Then, I symlink the library to wherever either the developer wants/requires it or where is easiest.

    The other way of handing this is to clone your PROGRAMS into the /opt directory - so /opt/couchpotato, /opt/NzbDrone, /opt/plexpy and so on. Then clone your working repos for projects into ~/git/[repo]

Now, onto the cloning:

```bash
git clone https://github.com/RuudBurger/CouchPotatoServer ~/git/couchpotato
sudo ln -s ~/git/couchpotato /opt/couchpotato
```

Which, again, your other option is to:

```bash
git clone https://github.com/RuudBurger/CouchPotatoServer /opt/couchpotato
```

## User Management

Either way, make sure the directories are marked as owned by the specific user you want to run the actual program. For CouchPotato, I have my main user running it. Technically, for proper security and the Linux Way, you're supposed to have specific, security-neutered, non-home-directory-having users running these programs. Helps stop any random, drive-by-login attempts, or rogue access if your password or keys were to ever get out.

So, if we want to go the right way, we would create a user that has no shell access, isn't allowed to actually log in, but is able to run programs.

```bash
sudo adduser --system --group --disabled-login couchpotato --home /opt/couchpotato --shell /bin/nologin
```

So, lets break that down:

1. `--system` dictates that this is a system-type user account.
2. `--group` man document states: "When combined with --system, a group with the same name and ID as the system user is created."
3. `--disabled`-login basically means, well, you cannot login to the system using this account.
4. `--home` states that the location of the programs files is the users home directory, which if you already have the files there, it will display an error. You can ignore it for now.
5. `--shell /bin/nologin` is a special shell that, as the name implys, helps further negate the login capabilities of the user.

So now, we want to make sure our directories actually are assigned to this user.:

```bash
sudo chown -R couchpotato:couchpotato ~/git/couchpotato
sudo chown -R couchpotato:couchpotato /opt/couchpotato
```

The other thing we also want to pay attention to is whether we have external drives mounted on our system; if we are running our Linux Software as a VirtualMachine, thus changing the way items might be mounted; and needing to pay attention to what users/groups are assigned those external drives/directories that we might need access to, in order to process/watch/download/etc. properly!

So, for running this inside of a VirtualBox instance locally, using folder mounting through VBox, they have a custom group for the file ownership in the machine, `vboxsf`. So, to allow users to have access to read-write on these directories:

```bash
sudo usermod -aG vboxsf $USER
```

So, the `-aG` part is adding a user to a group by addition, not replacing.
Then, the first name is the group, and the 2nd is the user.

Usually in order to have the addition take in the filesystem, you would log the user out then back in, but the system users normally don't have login/out abilities. So, restart the server instance.

## Test if it works

Now, we'll run the python program just within the Command Line output, which shows all the text output, including any errors and what not.

```bash
sudo python /opt/couchpotato/CouchPotato.py
```

This will run only as long as you allow it directly inside the terminal, and it will also give each step that the program runs, so you can see if it gives any errors or what else might need to be changed.

Then, to stop the CL output and control, hit `Ctrl-C` to quit the program.

## Copy/Edit Default File

!!! note
    The `/etc/default` is generally where a lot of programs like to keep their default settings files. Its a nice, centrally located spot that init or systemctl program files can reference when wanting a central place that a user can amend different settings, like the user that is running the program, or the directory location of different files.

So, we want to copy over the defaut `/etc/default` file from the github location, and then make any necessary changes.

```bash
sudo cp /opt/couchpotato/init/ubuntu.default /etc/default/couchpotato
sudo nano /etc/default/couchpotato
```

The below code field is not the entire file, but rather just an excerpt of items of interest.

```bash
# COPY THIS FILE TO /etc/default/couchpotato
# Accepted variables with default values -if any- in parentheses:

# username to run couchpotato under (couchpotato)
CP_USER=couchpotato
# directory of CouchPotato.py (/opt/couchpotato)
CP_HOME=/opt/couchpotato

# directory of couchpotato's db, cache and logs (/var/opt/couchpotato)
CP_DATA=/var/opt/couchpotato
# full path of couchpotato.pid (/var/run/couchpotato/couchpotato.pid)
CP_PIDFILE=/var/run/couchpotato.pid
# full path of the python binary (/usr/bin/python)
PYTHON_BIN=/usr/bin/python
```

So, the `CP_USER` would be the system account we created earlier.
`CP_HOME` is where it runs from
`CP_DATA` is where it stores files like the metadata for your movie directory. This one I like to have stored on a mounted, shared drive. This way, if I ever need to reinstall CouchPotato, or the VM fraks up and needs to be spun fresh, the big time stuff is saved elsewhere. So, mine is `/media/sf_Ext1/shared/couchpotato`

## Copy/Edit the init.d file

Now, if you're running Ubuntu, the `./init/ubuntu` script gets copied and amended thusly:

```bash
sudo cp /opt/couchpotato/init/ubuntu /etc/init.d/couchpotato
sudo chmod +x /etc/init.d/couchpotato
sudo update-rc.d couchpotato defaults
```

So the `chmod +x` makes the file executable - instead of running a bash script as `bash ./script.sh`,  when you `chmod +x` it, you're able to just say `./script` and remove the .sh from the file name as well. Then, the system pulls the language from the first line, `#!/bin/bash` or `#!/bin/sh` etc.

Then, the `update-rc.d` inputs the startup script into the actual upstart, startup system, telling ubuntu to run it on boot - if the script wants that.

Then, you can run `sudo service couchpotato start`, and so long as it doesn't output errors, you can now access it at [http://127.0.0.1:5050][3e06e9c6]

I will have reverse-proxying stuff posted in the future, but for now you can look at HTPCGuides.com, as they have a lot of those specific how-to's.

[^Sourcing]: [Directions copied - liberally - from HTPC-Guides][eccd07fa]

  [04a25565]: htpcguides.com "HTPCGuides"
  [3e06e9c6]: 127.0.0.1:5050 "CouchPotato Local"
  [eccd07fa]: http://www.htpcguides.com/install-couchpotato-ubuntu/ "HTPC Guides CouchPotato Ubuntu Installation"