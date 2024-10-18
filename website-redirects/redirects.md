  
# Website Redirects   
  
## Summary  
  
There are four subdomains which redirect to cppalliance.org.  
  
cpp.al    
redirect : https://cppalliance.org/  
  
chat.cpp.al  
redirect : https://cppalliance.org/slack/  
  
slack.cpp.al  
redirect : https://cppalliance.org/slack/  
  
slack-invite.cpp.al  
redirect : https://cppalliance.org/slack/  
  
The redirects act as shortcuts to quickly reach the slack invitations page or the main homepage.  

These were hosted on Dreamhost, but have been migrated to AWS on the cpplang-inviter.cppalliance.org server.  
  
## Detailed Implementation  
  
Each subdomain is hosted as an nginx vhost with a format similar to the following:  
  
```  
server {  
    listen 80;  
    server_name slack-invite.cpp.al www.slack-invite.cpp.al;  
    error_log /var/log/nginx/error-slack-invite.cpp.al.log;  
    access_log /var/log/nginx/access-slack-invite.cpp.al.log;  
    location '/.well-known/acme-challenge' {  
        default_type "text/plain";  
        root /var/www/letsencrypt;  
    }  
    location / {  
        return 301 https://cppalliance.org/slack$request_uri;  
    }  
}  
  
server {  
    listen 443 ssl;  
    listen [::]:443 ssl;  
    server_name slack-invite.cpp.al www.slack-invite.cpp.al;  
    error_log /var/log/nginx/error-slack-invite.cpp.al.log;  
    access_log /var/log/nginx/access-slack-invite.cpp.al.log;  
  
    ssl_certificate /etc/letsencrypt/live/slack-invite.cpp.al/fullchain.pem;  
    ssl_certificate_key /etc/letsencrypt/live/slack-invite.cpp.al/privkey.pem;  
  
    return 301 https://cppalliance.org/slack$request_uri;  
}  
```  
  
Notice that the "www" domain has been included in the config.  That was originally configured on dreamhost, and it makes sense to support both with or without "www".  
  
```  
ln -s /etc/nginx/sites-available/slack-invite.cpp.al /etc/nginx/sites-enabled/slack-invite.cpp.al  
  
systemctl restart nginx  
```  
 
## Certs  
  
The ssl certs were initially copied over from dreamhost, and then renewed again locally.    
The ssl certs in /etc/letsencrypt are organized as follows:  
  
```  
.  
├── accounts  
│   └── acme-v02.api.letsencrypt.org  
│       └── directory  
│           └── e1ab2b086f9c33212fbb7c14ee98de5f  
│               ├── meta.json  
│               ├── private_key.json  
│               └── regr.json  
├── archive  
│   ├── slack-invite.cpp.al  
│   │   ├── cert1.pem  
│   │   ├── chain1.pem  
│   │   ├── fullchain1.pem  
│   │   └── privkey1.pem  
├── cli.ini  
├── csr  
│   ├── 0000_csr-certbot.pem  
├── keys  
│   ├── 0000_key-certbot.pem  
├── live  
│   ├── slack-invite.cpp.al  
│   │   ├── cert.pem -> /etc/letsencrypt/archive/slack-invite.cpp.al/cert1.pem  
│   │   ├── chain.pem -> /etc/letsencrypt/archive/slack-invite.cpp.al/chain1.pem  
│   │   ├── fullchain.pem -> /etc/letsencrypt/archive/slack-invite.cpp.al/fullchain1.pem  
│   │   └── privkey.pem -> /etc/letsencrypt/archive/slack-invite.cpp.al/privkey1.pem  
├── renewal  
│   ├── slack-invite.cpp.al.conf  
├── renewal-hooks  
│   ├── deploy  
│   ├── post  
│   └── pre  
```  
  
SSL renewals:    
  
Make sure each renewal file is in place. For example,      
  
/etc/letsencrypt/renewal/slack-invite.cpp.al.conf    
  
```  
# renew_before_expiry = 30 days  
version = 0.27.0  
archive_dir = /etc/letsencrypt/archive/slack-invite.cpp.al  
cert = /etc/letsencrypt/live/slack-invite.cpp.al/cert.pem  
privkey = /etc/letsencrypt/live/slack-invite.cpp.al/privkey.pem  
chain = /etc/letsencrypt/live/slack-invite.cpp.al/chain.pem  
fullchain = /etc/letsencrypt/live/slack-invite.cpp.al/fullchain.pem  
  
# Options used in the renewal process  
[renewalparams]  
account = e1ab2b086f9c33212fbb7c14ee98de5f  
authenticator = webroot  
server = https://acme-v02.api.letsencrypt.org/directory  
[[webroot_map]]  
slack-invite.cpp.al = /var/www/letsencrypt  
www.slack-invite.cpp.al = /var/www/letsencrypt  
```  
  
Renewal can be done from the command-line:  
  
```  
certbot renew --force-renewal --cert-name slack-invite.cpp.al  
```  
(add --webroot-path /var/www/letsencrypt to the command in certain cases to fix errors. Add -q for quiet.)  
 
The setup should be completed for all domains:  
chat.cpp.al    
slack.cpp.al    
slack-invite.cpp.al    
cpp.al    
  
Let's Encrypt automatically adds a cronjob for future renewals.  

When copying over certs from dreamhost, this script was helpful.    
```  
#!/bin/bash  
cd /etc/letsencrypt/live  
for URL in chat.cpp.al slack.cpp.al slack-invite.cpp.al  
do  
  mkdir $URL  
  cd $URL  
  ln -s /etc/letsencrypt/archive/$URL/cert1.pem cert.pem  
  ln -s /etc/letsencrypt/archive/$URL/chain1.pem chain.pem  
  ln -s /etc/letsencrypt/archive/$URL/fullchain1.pem fullchain.pem  
  ln -s /etc/letsencrypt/archive/$URL/privkey1.pem privkey.pem  
  cd ..  
done  
```  
  
## DNS  
  
Migrate the DNS zone from dreamhost to cloudflare.com as an initial step to facilitate switching individual A records, one by one.   
  
The cpp.al zone registrar is 101domain.com.    
     
The zone was being hosted by dreamhost.com.    
- created zone in cloudflare.    
- changed NS records at 101domain.com from     
ns3.dreamhost.com    
ns2.dreamhost.com    
ns1.dreamhost.com    
to    
asa.ns.cloudflare.com    
guy.ns.cloudflare.com    
