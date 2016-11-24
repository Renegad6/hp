if test -z "$1"
then
    exit -1;
fi;
aefind "( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.xml" -o -name "*.fsm" -o -name "*.isd" ) -print"|xargs grep -iw $1 2>/dev/null;
