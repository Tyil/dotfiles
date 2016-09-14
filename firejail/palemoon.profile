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
whitelist ${HOME}/.cache/moonchild productions
whitelist ${HOME}/.config/pulse
whitelist ${HOME}/.gtkrc-2.0
whitelist ${HOME}/.moonchild productions
whitelist ${HOME}/.mozilla
whitelist ${HOME}/.pulse-cookie
whitelist ${HOME}/.themes
whitelist ${HOME}/.vimperator
whitelist ${HOME}/.vimperatorrc
whitelist ${HOME}/.Xauthority
whitelist ${HOME}/downloads/palemoon

# mark specified locations read-only
read-only ${HOME}/.config/pulse
read-only ${HOME}/.gtkrc-2.0
read-only ${HOME}/.themes
read-only ${HOME}/.Xauthority

# private directories
private-dev

