// GoatCounter settings; must run before count.js. One GoatCounter site
// counts both www.softinio.com and watch.softinio.com, so prefix each path
// with the hostname to keep their pages apart (otherwise both "/" pages
// would be counted as the same page).
window.goatcounter = {
	path: function (p) { return location.host + p; }
};
