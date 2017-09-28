git clean -dn | cut -c 14-|grep -v "^ign\."|tee|xargs git add
