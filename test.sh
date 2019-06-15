source oobash.sh

widget_count=0

eval $(new class widget)
widget name = 'Widget Class'

widget __constructor << 'EOF'
    let widget_count++
    $self widget_number = $widget_count
EOF

widget introduce << 'EOF'
    echo "Hi, I'm $($self name), widget #$($self widget_number)."
    echo "My parent is $($super name)."
    echo "Please meet my friend, $($1 name)."
EOF

eval $(new widget widget1)
widget1 name = 'Widgeter'

eval $(new widget widget2)
widget2 name = 'Widgetest'

widget1 introduce widget2
echo
widget2 introduce widget1


