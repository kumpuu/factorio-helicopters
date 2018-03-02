mogrify -fill rgba(0,0,0,0.01) -draw "point 0,0" *.png
mogrify -fill rgba(0,0,0,0.01) -draw "point 0,127" *.png
mogrify -fill rgba(0,0,0,0.01) -draw "point 127,0" *.png
mogrify -fill rgba(0,0,0,0.01) -draw "point 127,127" *.png

pause