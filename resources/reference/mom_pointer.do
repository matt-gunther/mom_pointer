clear
cd "Z:\pma\admin\staff\Devon\data_releases\investigation\nutrition\"
use pma_00120

*Step 1
bys hhid: egen housesize = max(lineno)
levelsof hhid, local(household)
gen momid = ""
foreach x in `household' {
	local i = 1
	levelsof housesize if hhid == "`x'", local(j)
	while `i' <= `j' {
	bys hhid: replace momid = personid[`i'] if lastbirthyr[`i'] == kidbirthyr & lastbirthmo[`i'] == kidbirthmo & relatekid == 1
	local i = `i' + 1
	}
}


*Step 2

gen flag = 1 if lastbirthyr < 9000
bys hhid: egen moms_in_hh = count(flag)
bys hhid: egen housesize = max(lineno)
levelsof hhid, local(household)
gen momid = ""
foreach x in `household' {
	local i = 1
	levelsof housesize if hhid == "`x'", local(j)
	while `i' <= `j' {
	bys hhid: replace momid = personid[`i'] if lastbirthyr[`i'] == kidbirthyr & lastbirthmo[`i'] == kidbirthmo & relatekid == 1
	bys hhid: replace momid = personid[`i'] if relatekid == 1 & moms_in_hh == 1 & flag[`i'] == 1
	local i = `i' + 1
	}
}
gen linked = 1 if momid != ""
