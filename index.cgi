#!/usr/local/bin/konoha

Import("dscript.subproc");
Import("JavaScript.Array");
Import("JavaScript.String");
Import("Type.File");
Import("posix.path");
Import("posix.process");

Load("./decodeURI.k");

void main() {
	SubProc sp = new SubProc("mktemp");
	sp.setArgumentList(["-q", "/tmp/js.XXXXXX"]);
	sp.bg();
	String filename = sp.communicate("")[0].trim();
	FILE tmp = new FILE(filename, "w");
	String input = decodeURI(System.getenv("QUERY_STRING").trim());
	tmp.print(input);
	tmp.flush();
	tmp.close();
	sp = new SubProc("/usr/local/bin/konoha");
	sp.setArgumentList(["-MJavaScript", "-ISyntax.GlobalVariable", "-IType.Float", "-IJavaScript.String", "-IJavaScript.Array", "-ISyntax.CStyleWhile", filename]);
	sp.bg();
	stdout.println("Content-Type: application/javascript; charset=utf-8\n");
	stdout.println(sp.communicate("")[0]);
	System.unlink(filename);
}

main();
