# Makefile for clojure-site-ja

COPYRIGHT_HOLDER = "Japan Clojurians"
PACKAGE_NAME     = clojure-site-ja
PACKAGE_VERSION  = 0.0.1
PO4A_CONF        = po4a.cfg

MSGMERGE_POT     = "--width=120"

RE_CREATE_CFG_CMD = ./bin/re_create_cfg.clj
JBAKE_CMD         = jbake

REDPEN_CMD        = redpen
REDPEN_CONF       = redpen-ja.xml

FROM_DIR  = en
TO_DIR    = ja
SITE_DIR  = site
BUILD_DIR = build

ORIGINAL_GIT_PATH = https://github.com/japan-clojurians/clojure-site-intl.git

clean:
	rm -rf $(FROM_DIR) $(TO_DIR) $(BUILD_DIR)/*
	@echo
	@echo "Cleanup finished."

test:
	exit 0

 # find ./ja -type f | xargs redpen -c redpen-ja.xml -f asciidoc

updatepot: clean
	git clone $(ORIGINAL_GIT_PATH) $(FROM_DIR)
	$(RE_CREATE_CFG_CMD)
	po4a $(PO4A_CONF) --copyright-holder $(COPYRIGHT_HOLDER) --package-name $(PACKAGE_NAME) --package-version $(PACKAGE_VERSION) --no-translations --msgmerge-opt $(MSGMERGE_POT)
	@echo
	@echo "Update finished. POT/PO files are updated."

# find i18n/po -name '*.pot' | xargs sed -i '/$$"POT-Creation-Date: 20/d'

translate:
	[ -d $(FROM_DIR) ] || git clone $(ORIGINAL_GIT_PATH) $(FROM_DIR)
	po4a $(PO4A_CONF) --copyright-holder $(COPYRIGHT_HOLDER) --package-name $(PACKAGE_NAME) --package-version $(PACKAGE_VERSION) --msgmerge-opt $(MSGMERGE_POT)
	@echo
	@echo "Translate finished."

check: translate
	find $(TO_DIR) -type f | xargs $(REDPEN_CMD) -c $(REDPEN_CONF) -f asciidoc

build: clean translate
	[ -d $(BUILD_DIR) ] || mkdir $(BUILD_DIR)
	cp -r $(SITE_DIR)/* $(BUILD_DIR) && cp -r $(FROM_DIR)/* $(BUILD_DIR) && cp -r $(TO_DIR)/* $(BUILD_DIR)
	cd $(BUILD_DIR) && $(JBAKE_CMD) -b
	@echo
	@echo "Build finished."

preview:
	docker run -v $(PWD)/$(BUILD_DIR)/output:/usr/src/app -p "4000:4000" starefossen/github-pages

publish: build
	git config --global user.name circle-ci
	ghp-import -n -m "[ci skip] update site :books:" -b gh-pages $(BUILD_DIR)/output
	git push origin gh-pages
	@echo
	@echo "Published."
