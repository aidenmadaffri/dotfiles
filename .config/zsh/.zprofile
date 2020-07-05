#Global variables
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export QT_QPA_PLATFORMTHEME=gtk2
export EDITOR=nvim
export TERMINAL=kitty
export BROWSER=firefox
export THEOS=$HOME/Applications/theos

#Dotfiles Cleanup
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export XSERVERRC="$XDG_CONFIG_HOME"/x11/xserverrc
export XAUTHORITY="$XDG_RUNTIME_DIR"/Xauthority
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export IDEA_PROPERTIES="${XDG_CONFIG_HOME}"/intellij-idea/idea.properties
export IDEA_VM_OPTIONS="${XDG_CONFIG_HOME}"/intellij-idea/idea.vmoptions
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME"/android
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export WINEPREFIX="$XDG_DATA_HOME"/wineprefixes/default
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

#Autostart X
if [ ! -f /tmp/Xorg.lock ]; then
    touch /tmp/Xorg.lock
    /usr/local/bin/startx
fi

