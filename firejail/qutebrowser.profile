# include other rulesets
#include /etc/firejail/disable-mgmt.inc
#include /etc/firejail/disable-secret.inc
#include /etc/firejail/disable-common.inc
#include /etc/firejail/disable-devel.inc

# explicitly blacklist sensitive locations
blacklist ${HOME}/.pki/nssdb
blacklist ${HOME}/.password-store

# keep track of all violations
tracelog

# limit capabilities
caps.drop all
seccomp
protocol unix,inet,inet6
netfilter
noroot

# allow access to specified locations
whitelist ${HOME}/.cache/qutebrowser
whitelist ${HOME}/.config/qutebrowser
whitelist ${HOME}/.config/Trolltech.conf
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.local/share/qutebrowser
whitelist ${HOME}/.themes
whitelist ${HOME}/.Xauthority
whitelist ${HOME}/downloads/qutebrowser

# mark specified locations read-only
read-only ${HOME}/.config/Trolltech.conf
read-only ${HOME}/.gtkrc-2.0
read-only ${HOME}/.themes
read-only ${HOME}/.Xauthority

# private directories
private-dev
private-tmp

