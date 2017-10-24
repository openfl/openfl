package openfl.text;

@:enum abstract FontWeight(Null<Int>) {

	public var NORMAL = 0;
	public var BOLD = 1;
	public var BOLDER = 2;
	public var LIGHTER = 3;
	public var THIN_100 = 100;
	public var THIN_200 = 200;
	public var LIGHT_300 = 300;
	public var REGULAR_400 = 400;
	public var MEDIUM_500 = 500;
	public var MEDIUM_600 = 600;
	public var BOLD_700 = 700;
	public var BOLD_800 = 800;
	public var BLACK_900 = 900;

	@:from private static function fromString(value : String) : FontWeight
	{

		return switch (value) {

			case "normal": NORMAL;
			case "bold": BOLD;
			case "bolder": BOLDER;
			case "lighter": LIGHTER;
			case "100": THIN_100;
			case "200": THIN_200;
			case "300": LIGHT_300;
			case "400": REGULAR_400;
			case "500": MEDIUM_500;
			case "600": MEDIUM_600;
			case "700": BOLD_700;
			case "800": BOLD_800;
			case "900": BLACK_900;
			default: null;

		}

	}

	@:to private static function toString(value : Int) : String
	{

		return switch (value) {

			case NORMAL: "normal";
			case BOLD: "bold";
			case BOLDER: "bolder";
			case LIGHTER: "lighter";
			case THIN_100: "100";
			case THIN_200: "200";
			case LIGHT_300: "300";
			case REGULAR_400: "400";
			case MEDIUM_500: "500";
			case MEDIUM_600: "600";
			case BOLD_700: "700";
			case BOLD_800: "800";
			case BLACK_900: "900";
			default: null;

		}

	}

}