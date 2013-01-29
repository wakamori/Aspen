/*
 * decode URI
 * encoded URI should be followed RFC3986.
 * http://www.ietf.org/rfc/rfc3986.txt
 * character encode is fixed to UTF-8.
 * kindofbrown(c)2009
 * update by myoan 28/Jul/2012 fix to follow new konoha.
 * update by myoan 22/Oct/2012 fix to follow new konoha.
 */

Import("Syntax.CStyleWhile");
Import("Type.Bytes");
Import("JavaScript.Regexp");
Import("JavaScript.String");
Import("JavaScript.Math");

int strHexToDec(String hex) {
	int ret = 0;
	String tmp = hex.replace(/0x/, "");
	int i = 0;
	int size = tmp.getlength();
	while(i < tmp.getlength()) {
		size = size - 1;
		String c = tmp.get(i);
		if (c.search(/[a-f]|[A-F]|[0-9]/) < 0) {
			return -1;
		}
		else if (c.search(/[0-9]/) >= 0) {
			int ii = c.toint();
			int ii = ii * Math.pow(16, size);
			ret = ret + ii;
		}
		else if (c.search(/[a-f]|[A-F]/) >= 0) {
			if (c == "a" || c == "A") {
				int ii = 10 * Math.pow(16, size);
				ret = ret + ii;
			}
			else if (c == "b" || c == "B") {
				int ii = 11 * Math.pow(16, size);
				ret = ret + ii;
			}
			else if (c == "c" || c == "C") {
				int ii = 12 * Math.pow(16, size);
				ret = ret + ii;
			}
			else if (c == "d" || c == "D") {
				int ii = 13 * Math.pow(16, size);
				ret = ret + ii;
			}
			else if (c == "e" || c == "E") {
				int ii = 14 * Math.pow(16, size);
				ret = ret + ii;
			}
			else if (c == "f" || c == "F") {
				int ii = 15 * Math.pow(16, size);
				ret = ret + ii;
			}
		}
		i = i + 1;
	}
	return ret;
}

int ampersand(int a, int b) {
	return a % b;
}

int lshift(int a, int b) {
	int i = 0;
	while(i < b) {
		a = a * 2;
		i = i + 1;
	}
	return a;
}

String Bytes.toString() {
	Bytes buf = this;
	int i = 0;
	String ret = "";
	while(i < buf.getSize()) {
		int c = buf.get(i);
		if(c == 0) {
			break;
		}
		ret = ret + String.fromCharCode(buf.get(i));
		i = i + 1;
	}
	ret = ret + " ";
	return ret;
}

@Public String decodeURI(String str) {
	int i = 0;
	int setcnt;
	int len = str.getlength();
	Bytes buf = new Bytes(str.getlength());
	int decoded = 0;
	int decode_flag = 0;
	boolean lf_flag = false;
	while(i < len) {
		String c = str.get(i);
		//if (c == "+") {
		//	buf.set(setcnt, " ".charCodeAt(0));
		//	setcnt = setcnt + 1;
		//} else if (c == "%") {
		if (c == "%") {
			String hex = "0x";
			int j = 0;
			while(j < 2) {
				i = i + 1;
				c = str.get(i);
				if (c.search(/[a-f]|[A-F]|[0-9]/) >= 0) {
					hex = hex + c;
				} else {
					i = i - 1;
					break;
				}
				j = j + 1;
			}
			int u = strHexToDec(hex);
			// recognize LF, CR, CR + LF
			if (u == 0x0D && lf_flag == false) {
				lf_flag = true;
			} else if (lf_flag == true && u == 0x0A) {
				// CR + LF
				buf.set(setcnt, "\n".charCodeAt(0));
				setcnt = setcnt + 1;
				lf_flag = false;
			} else {
				// decoding phase
				buf.set(setcnt, u);
				setcnt = setcnt + 1;
			}
		//} else if (c.search(/[a-z]|[A-Z]|[0-9]|\*|\-|\.|_/) >= 0) {
		//	buf.set(setcnt, c.toBytes().get(0));
		//	setcnt = setcnt + 1;
		} else {
			buf.set(setcnt, c.toBytes().get(0));
			setcnt = setcnt + 1;
		}
		i = i + 1;
	}
	return buf.toString();
}
