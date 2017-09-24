all: static critters debuffs spells interrupts

clean:
	rm -fv DBC/*.csv
	rm -fv DBC/*.sql
	rm -rf out/

prepare: clean
	mkdir -p DBC/ out/tmp/
	cd DBC/ && wine ../tools/DBCUtil.exe
	cd DBC/ && ../tools/csv2sql.sh

static:
	scripts/grep-dbc.sh

critters:
	scripts/critters.php

debuffs:
	scripts/debuffs.php

spells:
	scripts/spells.php

interrupts:
	tools/mass-translate.sh interrupts.txt

translations:
	cd ../pfUI && ../pfUI-toolbox/tools/update-translations.sh
