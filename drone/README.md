
## Drone Docs

The CPPAlliance drone implementation has been described in other documents. Please review those before proceeding.  
[https://cppalliance.org/sam/2021/01/15/DroneCI.html](https://cppalliance.org/sam/2021/01/15/DroneCI.html)  
[https://github.com/CPPAlliance/drone-ci](https://github.com/CPPAlliance/drone-ci)  
[https://github.com/CPPAlliance/droneconverter](https://github.com/CPPAlliance/droneconverter)  
  
The main server drone.cpp.al is running  
- drone  
- autoscaler  
- starlark  
  
To view processes:  
```
docker ps
```
  
To start the processes:  
```
cd /opt/drone/scripts
./stardrone.sh
./startstarlark.sh
./startautoscaler.sh
```
  
A backend postgres database contains the data. Generally, nothing needs to be done with the database.  
Access root postgres account with "sudo su - postgres".  
Access user account drone1 with the password located in startdrone.sh.  
  
Jobs are run using a combination of the autoscaler and dedicated runners (agents).  

Linux Runners:  
- dronerunnerkh1.cpp.al  
- dronerunnerkh2.cpp.al  

Windows Runners:  
- windowsdronerunner1  
- windowsdronerunner2  

Apple OSX Runners:  
- dronerunnermac2.cpp.al  
- dronerunnermac3.cpp.al  
- dronerunnermac4.cpp.al  
- dronerunnermac5.cpp.al  
  
The list is in flux. Agents may be added or removed. All AWS instances are located in the us-east-2 region, including autoscaled nodes, drone, and windows runners. "kh" refers to hosting provider knownhost.com. Benchmark servers are also at knownhost.com. The macs are hosted by macstadium.com.  
  
Backups of AWS nodes are accomplished with snapshots. The agents are not backed up, with the idea being those servers ought to be built/rebuilt/replaced using Ansible, and do not themselves contain important data. They may be treated as somewhat ephemeral, even if they are dedicated servers.  

The ansible role to install dronerunners is [https://github.com/CPPAlliance/ansible-dronerunner](https://github.com/CPPAlliance/ansible-dronerunner).  Currently it supports linux. The windows and mac scripts should be migrated into that role.  

Most of the logic required to setup a new boost repository with drone is in the [droneconverter](https://github.com/CPPAlliance/droneconverter), and most development effort has been focused there. It converts travis.yml files to .drone.star files, and also to GitHub Actions configs. A dependency of the .drone.star configs is functions.star, located at [https://github.com/boostorg/boost-ci](https://github.com/boostorg/boost-ci).  
