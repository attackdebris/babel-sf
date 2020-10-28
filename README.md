# Babel-sf

The Babel Scripting Framework (babel-sf) is a collection of tools to faciliitate useful pentest related tasks, replicated in a number of different scripting languages.

## Bable-sf Tools:
```bash
    Port Scanner
    ARP Scanner
    FTP Client
    WGET Client
    Bind Metasploit Payload
    Reverse Metasploit Payload
````

### The Tools are Replicated in the Following Languages:
```bash
    Perl
    Python 2.x
    Python 3.x
    Ruby
    PowerShell
```

### Why a custom scripting framework?

babel-sf has been created for testing minimal installations, locked down and/or hardened environments e.g.

* When the target Operating System has a minimal installation
* When the Operating System’s native tools have been removed
* When the Operating System’s native tools have been locked down via ACLs, Group Policy or AppLocker

But crucially, you still have access to one or more scripting languages e.g. Python or PowerShell

Its development was also partially driven by my own needs:

* Proof of Concept i.e. to demonstrate why access to scripting languages can be bad!
* System Administrator “Yeah, users have access to [ruby/perl/python/PowerShell], so what?”

### But really Why?

To solve reoccurring problems encountered during my testing:

* Having to write your own code to perform a required task (takes time!)
* Having to Google for code to (re)use, tweak and/or just to get working (takes time!)

I expect babel-sf to be used when you don’t have any tools or Operating System utilities available e.g.

1. No telnet
2. No FTP
3. No wget
4. No SSH
5. No netcat, nmap etc. etc.

In this scenario you simply download babel-sf onto the target box via a short one liner (in whichever scripting language is available to you).

### Aims?

babel-sf “aspires” to be identical in each scripting language:

* Identical Usage (switches etc.)
* Identical Output
* Offer an identical ‘Look and Feel’

### Functionality?

As it stands, babel-sf provides scripts for the following functions:

1. Port Scanner 
2. Arp Scanner 
3. FTP client (crude)
4. WGET client
5. HTTP Server
6. Bind Metasploit Payload
7. Reverse Metasploit Payload

### Initial Download?

Assuming that at least one scripting language is supported on the target system, an initial single line script (which provides wget type functionality) will be run to download babel-sf to the target host.

In practice to download babel-sf to our target system we run the relevant script, for our available programming language.  This will have to be typed in manually (but thankfully these scripts short and succinct).

### Perl:

Create ‘download.pl’ containing the following code and execute via: ‘perl download.pl’

```bash
use LWP::Simple; mirror('https://github.com/attackdebris/babel-sf/archive/master.zip', 'babel-sf.zip');
```

### Python:

Create ‘download.py’ containing the following code and execute via: ‘python download.py’

```bash
import urllib; urllib.urlretrieve('https://github.com/attackdebris/babel-sf/archive/master.zip', 'babel-sf.zip')
```

### Ruby:

Create ‘download.rb’ containing the following code and execute via: ‘ruby download.rb’

```bash
require 'open-uri'; File.open("babel-sf.zip", "wb").write(open("https://github.com/attackdebris/babel-sf/archive/master.zip", "rb").read)
```

### PowerShell:

Create ‘download.ps1' containing the following code and execute via: ‘powershell .\download.ps1'

```bash
(new-object System.Net.WebClient).Downloadfile("https://github.com/attackdebris/babel-sf/archive/master.zip","babel-sf.zip")
```

Obviously, if you were located on a closed network you would download from your own host, rather than from github.

### Script Uniformity?

The scripts offer uniform functionality to a point, some exceptions are:

1. Ruby has a socket limit (approx 1024):  This limits the maximum number of ports that can be scanned at once

2. I had to be flexible with the type of metasploit shells included:  Whilst, bind and reverse shells are included for each scripting language, one language may provide tcp_shells whlilst another may provide meterpreter shells

3. Whilst the underlying functionality is similar for all of the different HTTP servers: It proved tricky getting HTTP servers to provide a uniform look/feel:

4. Arpscanner usage varies a little between languages: The interface switch (e.g. eth0) is not currently supported in all languages

### Confessions!

* I’m not a coder (if you are a coder, look away now!)
* Coding in 4 different languages at the same time is foolhardy!
* Bugs / Errors abound
* If you don’t like certain aspects, contribute! Make them better!

### Testing!

* Only limited testing has been conducted
* Further testing, testing, testing is required e.g. What versions of Perl, Python, Ruby and PowerShell do the scripts run on?

### Supported Operating Systems

babel-sf has been tested on the following target Operating Systems (but it should work on many, many more):

* Perl, Python and Ruby (Currently only targeting Nix systems)

```bash
Ubuntu 12.04
Debian “wheezy”
```

* PowerShell (Windows)

Created on and tested in `PowerShell version 2.0 (Windows 7)`

### Future Additions?

Addition of further scripting languages:

```bash
    PHP
    VBScript
    Java
    More?
```
