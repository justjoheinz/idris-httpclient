build:
	idris --build http.ipkg --warnpartial

install:
	idris --install http.ipkg --warnpartial

doc:
	idris --mkdoc http.ipkg

test:
	idris --testpkg http.ipkg

clean:
	idris --clean http.ipkg
	rm -rf httpclient_doc
