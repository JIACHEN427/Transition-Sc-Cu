
CYCLE=8
hr='08'
expnr='002'
for i in `seq $CYCLE`; do

temp=$((i-1))
	if [ "$temp" -lt "10" ]; then
ln -s inits${hr}h00mx000y00$temp.${expnr} inits${hr}h00mx000y00$temp
else
ln -s inits${hr}h00mx000y0$temp.${expnr} inits${hr}h00mx000y0$temp
fi


echo 'linking' $i 'restart file'
done

for i in `seq $CYCLE`; do

temp=$((i-1))
if [ "$temp" -lt "10" ]; then
ln -s initd${hr}h00mx000y00$temp.${expnr} initd${hr}h00mx000y00$temp
else
ln -s initd${hr}h00mx000y0$temp.${expnr} initd${hr}h00mx000y0$temp
fi


echo 'linking' $i 'restart file'
done

echo 'linking finished'
