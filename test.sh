source oobash

eval $(new object widget)
widget .intro = 'I am a widget!'
widget def fancy_echo << 'EOF'
echo "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv"
echo "~!~ $@ ~!~"
echo "^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
EOF

widget .fancy_echo $(widget .intro)


