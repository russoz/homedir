
class pkg_install {
    package {
        $packages = [
            "lsb-release", "manpages-dev", "linux-doc", "pinfo",
            "cups-pdf", "mailutils",
            "pwgen", "p7zip-full",

            "zsh", "zsh-doc",
            "htop", "tofrodos", "stow", "lsof", "lshw", 
            "nscd",

            "eclipse",

            "openssh-client", "openssh-server", "telnet", "tcpdump",
            "sshfs", "sshpass", "autofs", 
            "mosh", "ntpdate", "ldap-utils", "ldapscripts",
            "nmap", "iftop", "ethtool", "traceroute", "ntop",
            "terminator", "openvpn", "nagstamon",

            "nautilus-gksu", "nautilus-pastebin", "nautilus-open-terminal",
            "nautilus-image-converter", "nautilus-image-manipulator",
            "nautilus-filename-repairer",

            "msttcorefonts",
            "ttf-liberation",
            "ttf-dejavu",
            "ttf-bitstream-vera",
            "ttf-freefont",
            "ttf-xfree86-nonfree",
            "t1-xfree86-nonfree",

            "ubuntu-restricted-extras",


        ]
        $packages: ensure => "installed" 
    }
}
