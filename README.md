# Bancha Bash Utilities

A simple bash script that performs many operations

- Requires: **UNIX shell**, **wget** or **curl**, **tar**
- Tested on: **Ubuntu 11+**


# How to install

From an unix shell (we used Ubuntu), type the following commands:

    curl -s http://getbancha.com/utilities.txt > _bnc.sh
    chmod +x _bnc.sh
    sudo mv _bnc.sh /usr/bin/bancha


Or, if you have **curl** instead of wget:

    wget -q http://getbancha.com/utilities.txt -O _bnc.sh
    chmod +x _bnc.sh
    sudo mv _bnc.sh /usr/bin/bancha


# Usage

Fresh Bancha install:

    bancha install


Update an existing installation to the latest available version:

    bancha update


Clear the website and administration cache (db, pages, settings, trees, content types)

    bancha cache clear