mkdir smaller
for i in $( ls *.jpg *.JPG ); do convert -resize 20% $i "smaller/s_$i"; done 
