# print function names
NOTICE_START () {
	echo "${bold} ${FUNCNAME[1]} ... START ... ${normal}"
}
NOTICE_END () {
	echo "${bold}${FUNCNAME[1]}  ... END ... ${normal}"
}