if test -z "$1"
then
    exit -1;
fi;
find . \( -name .svn -o -name work -o -name opkgbuild -o -name 3rdparty \) -prune -o \( -name *.c -o -name *.cpp \) -print|xargs grep -i $1;
