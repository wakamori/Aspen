function p(text) {
	var e = {
		"event": "print",
		"data": text
	};
	postMessage(e);
}

onmessage = function(event) {
	try {
		var block = event.data.replace(/^.*{/m, '{');
		var code  = new Function(block);
		if(code()) {
			var e = {
				"event": "end"
			};
			postMessage(e);
		}
	} catch(e) {
		throw e;
	}
};
