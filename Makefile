build:
				idris --build http.ipkg

install:
				idris --install http.ipkg

doc:
				idris --mkdoc http.ipkg

test:
				idris --testpkg http.ipkg

clean:
				idris --clean http.ipkg
