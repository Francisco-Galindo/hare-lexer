use errors;
use fmt;
use io;
use os;
use fs;
// use hare::lex;
use lex;
use bufio;
use types;

export fn main() void = {
	let path = os::args[1];

	const file = match(os::open(path)) {
	case let f: io::file =>
		yield f;
	case let err: fs::error =>
		fmt::fatalf("Unable to open {}: {}",
			path, fs::strerror(err));
	};
	defer io::close(file)!;

	let buffer: *[65535]u8 = alloc([0...]);
	defer free(buffer);

	const scan = bufio::newscanner(file, types::SIZE_MAX);
	const lexer = lex::init(&scan, path);

	for (true) {
		const token = match(lex::lex(&lexer)) {
		case let err: lex::error =>
			fmt::fatalf("Could not parse");
		case let tok: lex::token =>
			yield tok;
		};
		fmt::printfln("({}, {}), {} \t{}", token.2.line, token.2.col, token.1, lex::tokstr(token))!;
		if (token.0 == lex::ltok::EOF) {
			break;
		};
	};
};
