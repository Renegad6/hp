rm -f ~/updsir.trz;
echo "$(date) updating tools dirs" > ~/updsir.trz;
/sirius/tools/bin/update_sirius >> ~/updsir.trz 2>&1;
/usr/local/bin/vprintermanager updateprofiles >> ~/updsir.trz 2>&1;
