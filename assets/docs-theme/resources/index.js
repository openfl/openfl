function createCookie(name, value, days) {
	localStorage.setItem(name, value);
}

function readCookie(name) {
	return localStorage.getItem(name);
}

function toggleInherited(el) {
	var toggle = $(el).closest(".toggle");
	toggle.toggleClass("toggle-on");
	if (toggle.hasClass("toggle-on")) {
		$("i", toggle).removeClass("fa-arrow-circle-right").addClass("fa-arrow-circle-down");
	} else {
		$("i", toggle).addClass("fa-arrow-circle-right").removeClass("fa-arrow-circle-down");
	}
    return false;
}

function toggleCollapsed(el) {
	var toggle = $(el).closest(".expando");
	toggle.toggleClass("expanded");

	if (toggle.hasClass("expanded")) {
		$(toggle).find("i").first().removeClass("fa-arrow-circle-right").addClass("fa-arrow-circle-down");
	} else {
		$(toggle).find("i").first().addClass("fa-arrow-circle-right").removeClass("fa-arrow-circle-down");
	}
	updateTreeState();
    return false;
}

function updateTreeState(){
	var states = [];
	$("#nav .expando").each(function(i, e){
		states.push($(e).hasClass("expanded") ? 1 : 0);
	});
	var treeState = JSON.stringify(states);
	createCookie("treeState", treeState);
}

var filters = {};

function selectVersion(e) {
	setVersion($(e.target).parent().attr("data"));
}

function setPlatform(platform) {
	createCookie("platform", platform);
	$("#select-platform").val(platform);

	var styles = ".platform { display:inherit } ";
	var platforms = dox.platforms;

	styles += ".package-sys { display:" + ((platform == "Flash" || platform == "HTML5") ? "none" : "inherit") + " } ";
	styles += ".package-cpp { display:" + ((platform == "Flash" || platform == "HTML5" || platform == "Neko") ? "none" : "inherit") + " } ";
	styles += ".package-neko { display:" + ((platform == "Neko" || platform == "all") ? "inherit" : "none") + " } ";
	styles += ".package-js { display:" + ((platform == "HTML5" || platform == "all") ? "inherit" : "none") + " } ";

	for (var i = 0; i < platforms.length; i++) {
		var p = platforms[i];
		if (platform == "all" || p == platform)	{
			styles += ".platform-" + p + " { display:inherit } ";
		} else {
			styles += ".platform-" + p + " { display:none } ";
		}
	}

	$("#dynamicStylesheet").text(styles);
}
/*
function setVersion(version) {
	createCookie("version", version);
}
*/

$(document).ready(function(){
	$("#nav").html(navContent);
	var treeState = readCookie("treeState");

	$("#nav .expando").each(function(i, e){
		$("i", e).first().addClass("fa-arrow-circle-right").removeClass("fa-arrow-circle-down");
	});

	$(".treeLink").each(function() {
		this.href = this.href.replace("::rootPath::", dox.rootPath);
	});

	if (treeState != null)
	{
		var states = JSON.parse(treeState);
		$("#nav .expando").each(function(i, e){
			if (states[i]) {
				$(e).addClass("expanded");
				$("i", e).first().removeClass("fa-arrow-circle-right").addClass("fa-arrow-circle-down");
			}
		});
	}
	$("head").append("<style id='dynamicStylesheet'></style>");

	setPlatform(readCookie("platform") == null ? "all" : readCookie("platform"));
	//setVersion(readCookie("version") == null ? "3_0" : readCookie("version"));

	var searchBox = $("#search");
	searchBox.on("input", function(e){
		searchQuery(e.target.value);
	});
	$(window).keydown(function(e){
		if (searchBox.is(":focus")) {
			return true;
		} else if (e.key === "/" || e.keyCode == 191 /* slash */) {
			searchBox.focus();
			return false;
		} else if (!e.ctrlKey && !e.metaKey && (
			// e.key is only available in newer browsers. On older
			// browsers, we use an ugly blacklist of well-known
			// non-printable keyCodes, and assume everything else is
			// printable.
			(typeof e.key == "string" && e.key.length == 1 && e.key != " ") ||
			(typeof e.key == "undefined" && [8, 9, 13, 16, 17, 32, 33, 34, 35, 36, 37, 38, 39, 40, 45, 46, 91, 92, 93, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 144, 145].indexOf(e.keyCode) >= 0))) {
			searchBox.focus();
			return true;
		} else {
			return true;
		}
	});
	searchBox.keydown(function(e){
		if (e.keyCode == 27 /* Esc */) {
			this.blur();
			return false;
		}
		return true;
	});
	
	$("#select-platform").selectpicker().on("change", function(e){
		var value = $(":selected", this).val();
		setPlatform(value);
	});

	$("#nav a").each(function () {
		if (this.href == location.href) {
			$(this.parentElement).addClass("active");
		}
	});

	$("a.expand-button").click(function (e) {
		var container = $(this).parent().next();
		container.toggle();
		$("i", this).removeClass("fa-arrow-circle-down")
				.removeClass("fa-arrow-circle-right")
				.addClass(container.is(":visible") ? "fa-arrow-circle-down" : "fa-arrow-circle-right");
		return false;
	});

	// Because there is no CSS parent selector
	$("code.prettyprint").parents("pre").addClass("example");
});

function searchQuery(query) {
	$("#searchForm").removeAttr("action");
	query = query.replace(/[&<>"']/g, "");
	if (!query || query.length<2) {
		$("#nav").removeClass("searching");
		$("#nav li").each(function(index, element){
			var e = $(element);
			e.css("display", "");
		});
		$("#nav ul:first-child").css("display", "block");
		$("#search-results-list").css("display", "none");
		return;
	}
	var queryParts = query.toLowerCase().split(" ");
	var listItems = [];
	var bestMatch = 200;
	$("#nav").addClass("searching");
	$("#nav ul:first-child").css("display","none");
	$("#nav li").each(function(index, element) {
		var e = $(element);
		if (!e.hasClass("expando")) {
			var content = e.attr("data_path");
			var score = searchMatch(content, queryParts);
			if (score >= 0) {
				if (score < bestMatch) {
					var url = dox.rootPath + e.attr("data_path").split(".").join("/") + ".html";
					$("#searchForm").attr("action", url);
					 // best match will be form action
					bestMatch = score;
				}

				var elLink = $("a", element);
				// highlight matched parts
				var elLinkContent = elLink.text().replace(new RegExp("(" + queryParts.join("|").split(".").join("|") + ")", "ig"), "<strong>$1</strong>");
				var liStyle = (score == 0) ? ("font-weight:bold") : "";
				listItems.push({score: score, item: "<li style='" + liStyle + "'><a href='"+elLink.attr("href")+"'>" + elLinkContent + "</a></li>"});
			}
		}
	});
	if ($("#search-results-list").length == 0) {
		// append to nav
		$("#nav").parent().append("<ul id='search-results-list' class='nav nav-list'></ul>");
	}
	listItems.sort(function(x, y) { return x.score - y.score; }); // put in order
	$("#search-results-list").css("display","block").html(listItems.map(function(x) { return x.item; }).join(""));
}

function match(textParts, query) {
	var queryParts = query.split(".");
	if (queryParts.length == 1) {
		var queryPart = queryParts[0];
		for (var i = 0; i < textParts.length; ++i) {
			var textPart = textParts[i];
			if (textPart.indexOf(queryPart) > -1) {
				// We don't want to match the same part twice, so let's remove it
				textParts[i] = textParts[i].split(queryPart).join("");
				return textPart.length - queryPart.length;
			}
		}
	} else {
		var offset = -1;
		outer:
		while (true) {
			++offset;
			if (queryParts.length + offset > textParts.length) {
				return -1;
			}
			var scoreSum = 0;
			for (var i = 0; i < queryParts.length; ++i) {
				var queryPart = queryParts[i];
				var textPart = textParts[i + offset];
				var index = textPart.indexOf(queryPart);
				if (index != 0) {
					continue outer;
				}
				scoreSum += textPart.length - queryPart.length;
			}
			return scoreSum;
		}
	}
}

function searchMatch(text, queryParts) {
	text = text.toLowerCase();
	var textParts = text.split(".");
	var scoreSum = 0;
	for (var i = 0; i < queryParts.length; ++i) {
		var score = match(textParts, queryParts[i]);
		if (score == -1) {
			return -1;
		}
		scoreSum += score + text.length;
	}
	return scoreSum;
}
