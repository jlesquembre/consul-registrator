SHELL := bash
export version = 0.1

#interface ?= net0
bdir := _build
project := consul-registrator

.PHONY: install pkgbuild clean

install:
	install -D -m 644 src/docker.conf "$(DESTDIR)/etc/systemd/system/docker.service.d/docker.conf"
	install -D -m 644 <(sed -e "s|@project@|$(project)|g" src/consul@.service) "$(DESTDIR)/usr/lib/systemd/system/$(project)@.service"
	install -D -m 744 src/consul.sh "$(DESTDIR)/usr/lib/$(project)/consul.sh"


pkgbuild: $(bdir)/PKGBUILD
	cd $(bdir) && makepkg

$(bdir)/PKGBUILD: $(bdir)/$(project)-$(version).tgz contrib/PKGBUILD.in
	echo "## Generate PKGBUILD"
	sed -e "s|@pkgver@|$(version)|g" \
		-e "s|@pkgname@|$(project)|g" \
		-e "s|@md5sum@|$(shell md5sum $< | cut -d ' ' -f 1)|g" \
		contrib/PKGBUILD.in > $(bdir)/PKGBUILD
	cp contrib/pkg.install $(bdir)/$(project).install

$(bdir)/$(project)-$(version).tgz: .FORCE | $(bdir)
	tar --create --gzip --file $(bdir)/$(project)-$(version).tgz Makefile src contrib

$(bdir):
	mkdir $@

clean:
	rm -rf $(bdir)

.FORCE:
