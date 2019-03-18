all: critters spells dyndebuffs interrupts resurrections totems merge

clean:
	rm -fv DBC/*.csv
	rm -fv DBC/*.sql
	rm -rf out/

prepare: clean
	mkdir -p DBC/ out/tmp/
	cd DBC/ && wine ../tools/DBCUtil.exe
	cd DBC/ && ../tools/csv2sql.sh

critters:
	scripts/critters.php

spells:
	scripts/spells.lua

interrupts:
	tools/mass-translate.sh interrupts.txt

resurrections:
	tools/mass-translate.sh resurrections.txt

totems:
	tools/mass-translate.sh totems.txt

dyndebuffs:
	tools/mass-translateKV.sh dyndebuffs.txt

base:
	scripts/base.sh

merge: base
	tools/merge.sh

install:
	cp out/locales*.lua ../pfUI/env

translations:
	cd ../pfUI && ../pfUI-toolbox/tools/update-translations.sh
