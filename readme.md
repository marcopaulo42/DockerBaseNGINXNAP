# NGINX Workshop pre-work
## Prep for your upcoming F5/NGINX workshop! 

If you're here that probably means you are currently in, or registered for, an upcoming NGINX workshop. By taking the time to run through this exercise you are helping us save time during the workshop- we appreciate it.

## Step 0: Build NGINX Plus Image
Run command

**` sudo DOCKER_BUILDKIT=1 docker build --no-cache -t nginxplus --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key .`**.

`sudo DOCKER_BUILDKIT=1 docker build --no-cache -t nginxplus --secret id=nginx-crt,src=nginx-repo.crt --secret id=nginx-key,src=nginx-repo.key .`
 
 
This will have your temporary password.








Example Playbook
----------------

To use this role you can create a playbook such as the following (let's name it `nginx_controller_user_role.yaml` for the purposes of this example).

```yaml
- hosts: localhost
  gather_facts: no

  vars:
    nginx_controller_user_email: "user@example.com" # Required by nginx_controller_generate_token role
    nginx_controller_user_password: "mySecurePassword" # Required by nginx_controller_generate_token role
    nginx_controller_fqdn: "controller.mydomain.com"
    nginx_controller_validate_certs: false

  tasks:
    - name: Retrieve the NGINX Controller auth token
      include_role:
        name: nginxinc.nginx_controller_generate_token

    - name: Configure the Auth Provider
      include_role:
        name: nginxinc.nginx_controller_auth_provider
      vars:
        nginx_controller_auth_provider:
          metadata:
            name:  # the name of the user role
            displayName:   # a friendly display name for the user role (spaces and special characters allowed)
            description:  # a description of the user role
          desiredState:
            provider:
              type:             # The type of provider, ACTIVE_DIRECTORY
              connection:
                - uri:          # The ldap(s) url of the provider
                  sslMode:      # SSL Mode (PLAIN_TEXT, REQUIRE, VERIFY_CA)
                  rawCa: |
                    -----BEGIN CERTIFICATE-----
                    MIIFyjCCA7KgAwIBAgIJAP9cqU0MKsAtMA0GCSqGSIb3DQEBCwUAMHoxCzAJBgNV
                    <-- snip -->
                    GOy2S3QRVAIMJw8axbh3G5gzdj54/dUyX39ITTwHRQCLlKb2dTZII553ONj+ndqI
                    fkifDFvo8zPc/vIxji4y3s2WFW4I5Fw6TprI1/R/8GWgN2bvQNVVWyLY/UauJg==
                    -----END CERTIFICATE-----
              bindUser:
                type:         # The bind method, PASSWORD
                username:     # The bind user
                password:     # The bind password
              userFormat:           # The login format (USER_DOMAIN, UPN)
              defaultLoginDomain:   # The default domain for login
              domain:               # The domain DN
              pollIntervalSec:      # Poll interval in seconds (300)
              groupCacheTimeSec:    # Cache time in seconds (600)
              honorStaleGroups:     # Use stale groups if AD unavailable (true,false)
              groupSearchFilter:    # Filter to apply to group search ( (objectClass=group) )
              groupMemberAttribute: # Group attribute of user (memberOf)
              groupMappings:
                - external:         # External group name
                  internal:
                    ref:            # Internal group ref (/platform/auth/groups/admin_group)
                  caseSensitive:    # Case sesntive (true,false)
```

You can then run `ansible-playbook nginx_controller_auth_provider.yaml` to execute the playbook.


### If you cannot find your invite email ("Welcome to F5's Unified Demonstration Framework") STOP
  * These commonly get caught by spam filters. *Make sure to check your spam folder **and** your system's email Quarantine.*
  * If you still cannot find your invite email, you either have not been invited to a workshop or we have an incorrect email. Please get help from whoever sent you to this page.

## Step 1: Get yourself to UDF
### Navigate to https://udf.f5.com/ and select ```Non-F5 Users```
![Non F5](images/udfloginnonf5.png "clever alt text")
If this is your first time using UDF, use your temporary password to login, and go through all the readings of the fine prints. NOTE: this will *not be the password to the Jumphost or other VMs in the class!* 

### If you already have an account but you can't remember your password, simply reset it using your corporate email that you used to register for the workshop.
![Non F5](images/udfloginreset.png "happens to the best of us")

## Step 2: Get into the test course
### Click ```Launch``` (This will open a new tab.)
![Non F5](images/courselist.png "click launch")

### And then ```Join```
![Non F5](images/joinbutton.png "'Yes I'm sure'")

### Click the ```DEPLOYMENT``` tab at the top
![Non F5](images/almostthere.png "I'm up here")

## Step 3: RDP to the Jumpbox
   * username: `user`
   * password: `user`

THIS REQUIRES AN RDP CLIENT! If you have a Mac *and* haven't downloaded an RDP client before, here is the first-party version:

[Microsoft's RDP client on the Apple Apps Store](https://apps.apple.com/us/app/microsoft-remote-desktop/id1295203466?mt=12)

### Now we just have to wait for the Jumpbox to finish booting. . .
![Non F5](images/waitforboot.png "loading. . .")

### Make sure to select a small enough resolution to see the whole screen.
![Non F5](images/launchrdp.png "almost there")

### Accept the self-signed cert, and your username and password will be `user` and `user`. (This is *not* your email & UDF password.)
![Non F5](images/useruser.png "rogerroger")

### If you cant connect to the Jumphost, _remember to shut off your VPN_, or join a non-proxied network (sometimes a guest network in the office will work).

### For machines running Windows and attached to a domain, Windows will helpfully attempt to use your domain creds to log in, and you'll see:
![Non F5](images/domaincreds.png "everyone has credentials.com email accounts right?")

### Click "More choices" to enter both a username and a password.
![Non F5](images/domaincredsannotated.png "green arrows")


The final instruction is inside the VM.
Thank you!
