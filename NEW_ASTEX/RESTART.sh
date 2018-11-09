# A stupid shell script used restart the DALES from designated time.
# for a in `find . -type l`; do rm $a ;done # To remove all the link in the working dir
CYCLE=32 # Total cores used to run the simulation
hr='04' # add '0' if the number is less than 10
expnr='002'
for i in `seq $CYCLE`; do
temp=$((i-1))
temp=$(printf "%03d" "$temp")
ln -s inits${hr}h00mx000y$temp.${expnr} inits${hr}h00mx000y$temp
ln -s initd${hr}h00mx000y$temp.${expnr} initd${hr}h00mx000y$temp
echo 'linking' $i 'restart file'
done
echo 'linking finished'
