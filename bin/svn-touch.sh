if [ -e /tmp/last.touch ];
then
# hay un ficheros de modificaciones antiguas.
    echo "touching old modifications batch";
    cat /tmp/last.touch;
    cat /tmp/last.touch|xargs touch;
    rm /tmp/last.touch;
else 
    svn status $AE_SANDBOX_PATH|grep "^[M|A]"| cut -f2- -d" "|tee /tmp/$$touch;
    if [ -s /tmp/$$touch ];
    then
# hay modificaciones, guardarlas
        echo "new modifications batch!!";
        mv /tmp/$$touch /tmp/last.touch;
    fi;
fi;
