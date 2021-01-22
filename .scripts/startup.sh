# Clear spaces
sleep 5
yabai -m space 1 --destroy
yabai -m space 2 --destroy
yabai -m space 3 --destroy
yabai -m space 4 --destroy
yabai -m space 5 --destroy
yabai -m space 6 --destroy
yabai -m space 7 --destroy
yabai -m space 8 --destroy
yabai -m space 9 --destroy
yabai -m space 10 --destroy
yabai -m space 11 --destroy
yabai -m space 12 --destroy
yabai -m space 13 --destroy
yabai -m space 14 --destroy
yabai -m space 15 --destroy
yabai -m space 16 --destroy
yabai -m space 17 --destroy
yabai -m space 18 --destroy
yabai -m space 19 --destroy
yabai -m space 10 --destroy
sleep 0.5
yabai -m space A1 --destroy
yabai -m space A2 --destroy
yabai -m space A3 --destroy
yabai -m space A4 --destroy
yabai -m space A5 --destroy
yabai -m space B1 --destroy
yabai -m space B2 --destroy
yabai -m space B3 --destroy
yabai -m space B4 --destroy
yabai -m space B5 --destroy
sleep 3

# Create spaces
yabai -m space --create
yabai -m space --create
yabai -m space --create
yabai -m space --create
yabai -m space --create
yabai -m space --create
yabai -m space --create
yabai -m space --create
sleep 3

# Label spaces
yabai -m space 1 --label A1
yabai -m space 2 --label B1
yabai -m space 3 --label A2
yabai -m space 4 --label A3
yabai -m space 5 --label A4
yabai -m space 6 --label A5
yabai -m space 7 --label B2
yabai -m space 8 --label B3
yabai -m space 9 --label B4
yabai -m space 10 --label B5
sleep 3

# Send spaces to correct displays
yabai -m space A1 --display 1
yabai -m space A2 --display 1
yabai -m space A3 --display 1
yabai -m space A4 --display 1
yabai -m space A5 --display 1
yabai -m space B1 --display 2
yabai -m space B2 --display 2
yabai -m space B3 --display 2
yabai -m space B4 --display 2
yabai -m space B5 --display 2

# Launch Applications
sleep 10
open -n /Applications/iTerm.app
open -n /Applications/Google\ Chrome.app
sleep 5
open -n /Applications/Google\ Chrome.app
osascript -e "tell application \"iTerm2\" to set newWindow to (create window with default profile)" # iTerm2
sleep 0.5
osascript -e "tell application \"iTerm2\" to set newWindow to (create window with default profile)" # iTerm2
open -n /Applications/Discord.app
open -n /Applications/Spark.app
sleep 5

# Get ids of Applications
CHROME_A=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "Google Chrome").id' | head -n 1)
CHROME_B=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "Google Chrome").id' | tail -n 1)
TERM_A=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "iTerm2").id' | head -n 1)
TERM_B=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "iTerm2").id' | tail -n 1)
DISCORD=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "Discord").id' | head -n 1)
SPARK=$(yabai -m query --windows | jq '.[] | {id: .id, name: .app} | select(.name == "Spark").id' | head -n 1)

# Move Applications
yabai -m window $CHROME_A --space A1
yabai -m window $CHROME_B --space B1
yabai -m window $TERM_A --space A3
yabai -m window $TERM_B --space B3
yabai -m window $DISCORD --space B2
yabai -m window $SPARK --space A2
