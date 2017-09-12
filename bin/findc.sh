if test $# -eq 0
then
    echo "wrong args!";
    exit -1;
fi;
(aefind "( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.xml" -o -name "*.qml" -o -name "*.fsm" -o -name "*.isd" -o -name "*.proto" -o -name "*.py" -o -name "*.tcl" ) -print"|xargs grep -n $@ 2>/dev/null)|tee /tmp/findcout;
