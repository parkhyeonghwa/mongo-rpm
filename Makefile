DIRS=SOURCES SPECS BUILD BUILDROOT RPMS SRPMS workarea
SPEC=mongodb.spec
VERSION=2.2.1
UPSTREAM=http://downloads.mongodb.org/src/mongodb-src-r$(VERSION).tar.gz
TARBALL=$(shell basename $(UPSTREAM))

all: $(DIRS)
	@echo "ready"

distclean:
	rm -r $(DIRS)

$(DIRS):
	test -d $@ || mkdir $@

fetch-tarball: SOURCES/$(TARBALL)
	# git checkout --orphan was added in 1.7.2, too new for CentOS 6.3	
	# 
	git symbolic-ref HEAD refs/heads/$(VERSION)
	-rm .git/index
	tar -C workarea --strip-components 1 -zxf SOURCES/$(TARBALL)
	git add workarea SOURCES/$(TARBALL)
	git commit -m 'import from upstream tarball'
	git tag $(VERSION)_upstream

SOURCES/$(TARBALL): $(DIRS)
	( cd SOURCES/ && curl -R -L $(UPSTREAM) -O )

spec: SPECS/$(SPEC)

SPECS/$(SPEC): $(SPEC).in
	git format-patch --numbered --suffix=_$(VERSION).patch -o SOURCES -u $(VERSION)_upstream..$(VERSION) 
	( find SOURCES -name \*_$(VERSION).patch | awk '{printf "Patch%03d: %s\n",NR, $$0 }' ; \
	  sed < $< \
	   -e s/@@VERSION@@/$(VERSION)/g \
	   -e s#@@UPSTREAM@@#$(UPSTREAM)#g \
	) >$@


rpm: spec
	rpmbuild --define '_topdir $(shell pwd)' --short-circuit -ba SPECS/$(SPEC)
#	rpmbuild --define '_topdir $(shell pwd)' -ba SPECS/$(SPEC)
