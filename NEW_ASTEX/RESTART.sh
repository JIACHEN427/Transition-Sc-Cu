
CYCLE=32

for i in `seq $CYCLE`; do

temp=$((i-1))
	if [ "$temp" -lt "10" ]; then
ln -s inits12h00mx000y00$temp.001 inits12h00mx000y00$temp
else
ln -s inits12h00mx000y0$temp.001 inits12h00mx000y0$temp
fi


echo 'linking' $i 'restart file'
done

for i in `seq $CYCLE`; do

temp=$((i-1))
if [ "$temp" -lt "10" ]; then
ln -s initd12h00mx000y00$temp.001 initd12h00mx000y00$temp
else
ln -s initd12h00mx000y0$temp.001 initd12h00mx000y0$temp
fi


echo 'linking' $i 'restart file'
done

echo 'Finished linking'
