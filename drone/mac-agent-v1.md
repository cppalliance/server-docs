
This is an earlier version of the documentation. Obsolete. Refer to the latest "version" in this same directory.

## Mac Agent for Drone
  
Agents running at macstadium:  
dronerunnermac1.cpp.al 207.254.39.170 Catalina 10.15  
dronerunnermac2.cpp.al 207.254.41.120 HighSierra 10.13  
_more_

Versions of Xcode require certain OSX versions. 

Create DNS entry for server in cloudflare.

### Initial Setup of Machine

Connect to machine via ssh.  
ssh -L 5900:localhost:5900 administrator@207.254.39.170

Open VNC. Connect to localhost port 5900 

It's convenient during setup to have sudo privileges:

```
echo "administrator ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/administrator
```
Set the hostname
```
scutil --set HostName dronerunnermac
```

Refer to the script macsetup.sh in this directory, which will  
- install brew
- install multiple versions of XCode

```
sudo su -
export XCODE_INSTALL_USER=samueldarwin@yahoo.com
export XCODE_INSTALL_PASSWORD=
./macsetup.sh
```

### Create drone user  
```
#!/bin/bash
set -xe
sudo su -
sysadminctl -addUser drone -fullName Drone -shell /bin/bash -password - -home /Users/drone
mkdir /Users/drone
chown drone:staff /Users/drone
```

Log into VNC, go to System Preferences, and set auto login for drone. Also, log in as drone. This is required for launchd.

### Install Drone Agent
  
```
#!/bin/bash
set -xe
curl -L https://github.com/drone-runners/drone-runner-exec/releases/latest/download/drone_runner_exec_darwin_amd64.tar.gz | tar zx
sudo cp drone-runner-exec /usr/local/bin
```

Create config files  

mac1:  
sudo su - drone

```
#!/bin/bash
set -xe
mkdir -p /Users/drone/.drone-runner-exec
vi /Users/drone/.drone-runner-exec/config  
```

```
DRONE_RPC_PROTO=https
DRONE_RPC_HOST=drone.cpp.al
DRONE_RPC_SECRET=_set_this_
DRONE_RUNNER_CAPACITY=4
DRONE_RUNNER_NAME=dronerunnermac1.cpp.al
#DRONE_RUNNER_PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin
DRONE_LOG_FILE=/Users/drone/.drone-runner-exec/log.txt
DRONE_RUNNER_LABELS=os:catalina
```

mac2:  
```
mkdir -p /Users/drone/.drone-runner-exec  
vi /Users/drone/.drone-runner-exec/config  
```
 
```
DRONE_RPC_PROTO=https
DRONE_RPC_HOST=drone.cpp.al
DRONE_RPC_SECRET=_set_this_
DRONE_RUNNER_CAPACITY=4
DRONE_RUNNER_NAME=dronerunnermac2.cpp.al
#DRONE_RUNNER_PATH=/usr/local/bin:/usr/bin:/usr/sbin:/sbin
DRONE_LOG_FILE=/Users/drone/.drone-runner-exec/log.txt
DRONE_RUNNER_LABELS=os:highsierra
```
  
as the drone user  
```
drone-runner-exec service install
drone-runner-exec service start
```
