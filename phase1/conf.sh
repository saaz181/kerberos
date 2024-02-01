addprinc -randkey -e aes256-cts coffeserver/172.17.0.2@UNIVERSITY
addprinc -randkey -e aes256-cts swimserver/172.17.0.2@UNIVERSITY

ktadd -k coffeserver.keytab coffeserver/172.17.0.2@UNIVERSITY
ktadd -k swimserver.keytab swimserver/172.17.0.2@UNIVERSITY

ank -randkey tu1@UNIVERSITY
ank -randkey su1@UNIVERSITY
ank -randkey tu2@UNIVERSITY
ank -randkey su2@UNIVERSITY

xst -norandkey -k tu1.keytab tu1@UNIVERSITY
xst -norandkey -k su1.keytab su1@UNIVERSITY
xst -norandkey -k tu2.keytab tu2@UNIVERSITY
xst -norandkey -k su2.keytab su2@UNIVERSITY

ktadd -k tu1.keytab tu1@UNIVERSITY
ktadd -k su1.keytab su1@UNIVERSITY
ktadd -k tu2.keytab tu2@UNIVERSITY
ktadd -k su2.keytab su2@UNIVERSITY

addprinc -randkey -e aes256-cts coffeserver/172.17.0.2@UNIVERSITY
addprinc -randkey -e aes256-cts swimserver/172.17.0.2@UNIVERSITY

ktadd -k coffeserver.keytab coffeserver/172.17.0.2@UNIVERSITY
ktadd -k swimserver.keytab swimserver/172.17.0.2@UNIVERSITY

# addpol "coffeepolicy" "coffeserver/172.17.0.2@UNIVERSITY"
# addpol "swimpolicy" "swimserver/172.17.0.2@UNIVERSITY"

addprinc -randkey -e aes256-cts -policy coffeepolicy tu1@UNIVERSITY
addprinc -randkey -e aes256-cts -policy coffeepolicy su1@UNIVERSITY
addprinc -randkey -e aes256-cts -policy swimpolicy tu2@UNIVERSITY
addprinc -randkey -e aes256-cts -policy swimpolicy su2@UNIVERSITY

ktadd -k tu1.keytab tu1@UNIVERSITY
ktadd -k su1.keytab su1@UNIVERSITY
ktadd -k tu2.keytab tu2@UNIVERSITY
ktadd -k su2.keytab su2@UNIVERSITY
