# Used restart the DALES from designated time.
# for a in `find . -type l`; do rm $a ;done # To remove all the link in the working dir
CYCLE=8
hr='08' # add '0' if the number is less than 10
expnr='002'
for i in `seq $CYCLE`; do
temp=$((i-1))
ln -s inits${hr}h00mx000y00$temp.${expnr} inits${hr}h00mx000y00$temp
ln -s initd${hr}h00mx000y00$temp.${expnr} initd${hr}h00mx000y00$temp
echo 'linking' $i 'restart file'
done
echo 'linking finished'
