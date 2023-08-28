< Harmony\ of\ a\ Hunter.m3u.bck rev | cut -d/ -f1 | cut -c5- | rev | tr '\n' '\0' | xargs -0 -I {} mpc -f %file% search filename {} > Harmony\ of\ a\ Hunter.m3u
