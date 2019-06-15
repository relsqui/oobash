source oobash

widget=$(new class)
$widget .name = 'Widget Class'
$widget def introduce << 'EOF'
echo "Hi, I'm $($self .name)!"
EOF

widget1=$(new widget)
$widget1 .name = 'Widget One'

widget2=$(new widget)
$widget2 .name = 'Widget Two'

$widget1 .introduce
$widget2 .introduce


