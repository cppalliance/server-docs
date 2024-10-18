  
## Mac Agent for Drone    
  
Agents running at macstadium:  
dronerunnermac1.cpp.al 207.254.39.170 Catalina 10.15 # removing  
dronerunnermac2.cpp.al 207.254.41.120 HighSierra 10.13  
dronerunnermac3.cpp.al 207.254.41.120 Catalina 10.15  
dronerunnermac4.cpp.al 207.254.41.120 HighSierra 10.13  
dronerunnermac5.cpp.al 207.254.41.120 Catalina 10.15  
  
Versions of Xcode require certain OSX versions.  
  
Create DNS entry for server in cloudflare.  
  
### Initial Setup of Machine  
  
Connect to machine via ssh.    
ssh -L 5900:localhost:5900 administrator@207.254.39.170  
  
Open VNC. Connect to localhost port 5900. Minimum resolution 16b.  
Run apple updates. Reboot. Log in again.  
  
It's convenient during setup to have sudo privileges:  
  
```  
echo "administrator ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/administrator  
```  
Set the hostname  
```  
scutil --set HostName dronerunnermac  
```  
  
Run the script bootstrap_mac.sh from https://github.com/CPPAlliance/ansible-dronerunner/blob/master/scripts/bootstrap_mac.sh  
  
```  
sudo su -  
export FASTLANE_USER=samueldarwin@yahoo.com  
export FASTLANE_PASSWORD=  
./bootstrap_mac.sh  
```  

Run the ansible playbook, after configuring variables.  
```
ansible-playbook dronerunner-playbook.yml
```
