// GoatCounter settings; must run before count.js. One GoatCounter site
// counts both www.softinio.com and watch.softinio.com, so prefix each path
// with the hostname to keep their pages apart (otherwise both "/" pages
// would be counted as the same page). Only the live host is counted: PR
// previews are production builds served from *.pages.dev, and returning
// null tells count.js to skip the pageview.
window.goatcounter = {
	path: function (p) {
		return location.host === 'www.softinio.com' ? location.host + p : null;
	}
};
