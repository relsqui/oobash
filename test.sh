source oobash

eval $(new class widget)
widget name = 'Widget Class'
widget introduce << 'EOF'
echo "Hi, I'm $($self name)!"
echo "My parent is $($super name)."
echo
EOF

eval $(new widget widget1)
widget1 name = 'Widget One'

eval $(new widget widget2)
widget2 name = 'Widget Two'

widget1 introduce
widget2 introduce


