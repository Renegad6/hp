if test -z "$1"
then
    exit -1;
fi;
aefind "( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.xml" -o -name "*.fsm" -o -name "*.isd" -o -name "*.proto" -o -name "*.py" ) -print"|xargs grep -iwn $1 2>/dev/null;
