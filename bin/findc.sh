find . \( -name .svn -o -name work -o -name opkgbuild -o -name 3rdparty \) -prune -o \( -name *.c -o -name *.cpp \)  -exec grep -i $1 \; -print
