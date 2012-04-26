![Logo](http://static.squallstar.it/images/bancha-trasp.png)

# Bancha Bash Utilities

A simple bash script that performs many useful operations.

- Requires: **UNIX shell**, **wget** or **curl**, **tar**.
- Tested on: **Ubuntu 10+**.
- Does **NOT** work on **Mac OSX** crappy FreeBSD shell.

## 1. How to install

From an unix shell (we used Ubuntu), type the following commands:

    wget -q https://raw.github.com/squallstar/bancha-bash/master/bancha.sh -O _bnc.sh
    chmod +x _bnc.sh
    sudo mv _bnc.sh /usr/bin/bancha

Or, if you have **curl** instead of wget:

    curl -s https://raw.github.com/squallstar/bancha-bash/master/bancha.sh > _bnc.sh
    chmod +x _bnc.sh
    sudo mv _bnc.sh /usr/bin/bancha


## 2. Usage

### 2.1 Install Bancha on the current directory
To do a fresh Bancha install:

    bancha install


The script will ask you for a directory (leave blank to install in the current path).

---

### 2.2 Update an existing Bancha installation

Update an existing installation to the latest available version on GitHub:

    bancha update


The following folders will be updated: **core** and **themes/admin**.
A backup copy of both directories will be created in their paths with a **._old.** prefix.

---

## 3. Utilities

### 3.1 Clear the website/admin cache

To clear the website and administration cache (db, pages, settings, trees, content types):

    bancha clear cache

---

### 3.2 Clear the image presets cache

To clear the image presets cache (tipically will be the **/attach/cache** directory):

    bancha clear presets

---

### 3.3 Clear the minified resources cache

**To be added soon.**
