#!/bin/bash
cat ~/.config/i3/conf.d/0-Main > ~/.config/i3/config
cat ~/.config/i3/conf.d/10-Keybindings >> ~/.config/i3/config
cat ~/.config/i3/conf.d/20-Workspaces >> ~/.config/i3/config
cat ~/.config/i3/conf.d/30-KeybindedPrograms >> ~/.config/i3/config
cat ~/.config/i3/conf.d/40-WindowRules >> ~/.config/i3/config
cat ~/.config/i3/conf.d/50-AutostartedServices >> ~/.config/i3/config
cat ~/.config/i3/conf.d/60-Colors >> ~/.config/i3/config
cat ~/.config/i3/conf.d/70-Gaps >> ~/.config/i3/config
cat ~/.config/i3/conf.d/90-AutostartedPrograms >> ~/.config/i3/config
