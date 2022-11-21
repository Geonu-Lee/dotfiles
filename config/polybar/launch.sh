polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar1.log

polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars Launcher..."
