for file in *.m3u ; do
[[ -d ./bck/ ]] || mkdir ./bck/
# vars
bck="${file}.$(date +%s).bck"
tmp="${file}.$(date +%s).tmp"
# make backup
cp $file $bck
# search for files and insert into temp
< $file rev | cut -d/ -f1 | cut -c5- | rev | tr '\n' '\0' | xargs -0 -I {} mpc -f %file% search filename {} | sed -e 's/\.flac$/\.ogg$/' > $tmp
# print diff
diff $bck $tmp
# move temp into file
< $tmp >! $file
# move backup into storage
mv $bck ./bck/$bck
\rm $tmp
done
