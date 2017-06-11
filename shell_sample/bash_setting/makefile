
bashrc=~/.bashrc
profile=~/.profile
check=check.txt

install: bashrc.sh profile.sh
	./uninstall.sh ${bashrc}
	./bashrc.sh ${bashrc}
#	./uninstall.sh ${profile}
#	./profile.sh ${profile}

uninstall:
	./uninstall.sh ${bashrc}
#	./uninstall.sh ${profile}

check:
	rm -f ${check}
	touch ${check}	
	./bashrc.sh ${check}
	./profile.sh ${check}
	less ${check}

less:
	less ${check}
