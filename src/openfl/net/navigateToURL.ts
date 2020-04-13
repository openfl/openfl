import URLRequest from "../net/URLRequest";
import Lib from "../Lib";

export default function navigateToURL(request: URLRequest, window?: string): void
{
	return Lib.navigateToURL(request, window);
}
