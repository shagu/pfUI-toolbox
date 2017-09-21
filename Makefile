all: critters debuffs spells interrupts

clean:
	rm -fv DBC/*.csv
	rm -fv DBC/*.sql
	rm -fv out/*

prepare: clean
	cd DBC/ && wine ../tools/DBCUtil.exe
	cd DBC/ && ../tools/csv2sql.sh

critters:
	cd out/ && ../scripts/critters.php

debuffs:
	cd out/ && ../scripts/debuffs.php

spells:
	cd out/ && ../scripts/spells.php

interrupts:
	cd DBC/ && ../tools/mass-translate.sh ../lists/interrupts.txt
	mv DBC/*.lua out/

translations:
	cd ../pfUI && ../pfUI-toolbox/tools/update-translations.sh

