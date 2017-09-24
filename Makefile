all: critters debuffs spells interrupts merge

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

debuffs:
	scripts/debuffs.php

spells:
	scripts/spells.php

interrupts:
	tools/mass-translate.sh interrupts.txt

base:
	scripts/base.sh

merge: base
	tools/merge.sh

translations:
	cd ../pfUI && ../pfUI-toolbox/tools/update-translations.sh
