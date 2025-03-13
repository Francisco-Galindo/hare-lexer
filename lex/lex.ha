use ascii;
use bufio;
use encoding::utf8;
use fmt;
use io;
use memio;
use path;
use sort;
use sort::cmp;
use strconv;
use strings;
use types;

export type flag = enum uint {
	NONE = 0,
	COMMENTS = 1 << 0, // Enables lexing comments
};

export type error = !(io::error | syntax);

export type syntax = !(location, str);

export type lexer = struct {
	in: *bufio::scanner,
	path: str,
	loc: (uint, uint),
	prevrloc: (uint, uint),
	// ltok::EOF when no token was unlexed
	un: token,
	prevunlocs: [2]((uint, uint), (uint, uint)),
	flags: flag,
	comment: str,
	require_int: bool,
};

export fn comment(lex: *lexer) str = {
	return "TODO";
};

export fn init(in: *bufio::scanner, path: str, flags: flag = flag::NONE) lexer = {
	return lexer {
		in = in,
		path = path,
		loc = (1, 1),
		prevrloc = (1, 1),
		un = (ltok::EOF, void, location { path = path, line = 1, col = 1 }),
		prevunlocs = [((1, 1), (1, 1))...],
		flags = flags,
		...
	};
};

export fn lex(lexr: *lexer) (token | error) = {

	const run = match (advance(lexr)?) {
	case io::EOF =>
		const loc = location {
			path = lexr.path,
			line = lexr.loc.0,
			col = lexr.loc.1
		};
		return (ltok::EOF, void, loc);
	case let r: (rune, location) =>
		yield r;
	};

	if (ascii::isblank(run.0) || run.0 == '\n') {
		return lex(lexr);
	};

	if (is_word_rune(run.0, true)) {
		backpedal(lexr, run.0);
		return lex_word(lexr);
	};

	if (ascii::isdigit(run.0)) {
		backpedal(lexr, run.0);
		return lex_number(lexr);
	};

	const token = switch (run.0) {
	case '(' =>
		yield ltok::LPAREN;
	case ')' =>
		yield ltok::RPAREN;
	case '{' =>
		yield ltok::LBRACE;
	case '}' =>
		yield ltok::RBRACE;
	case '[' =>
		yield ltok::LBRACKET;
	case ']' =>
		yield ltok::RBRACKET;
	case ',' =>
		yield ltok::COMMA;
	case ';' =>
		yield ltok::SEMICOLON;
	case '?' =>
		yield ltok::QUESTION;
	case '~' =>
		yield ltok::BNOT;
	case '.', '<', '>', '&', '|', '^', '*', '%', '/', '+', '-', ':', '!', '=' =>
		backpedal(lexr, run.0);
		return lex_troll(lexr);
	case '"' =>
		return lex_literal_str(lexr);
	case =>
		// return syntaxerr(run.1, "invalid character");
		yield ltok::AS;
	};

	return (token, void, run.1);
};

export fn strerror(err: error) const str = {
	// return fmt::asprintf("Error while parsing ({}): {}\n", error.0, error.1);
	return fmt::asprintf("ERROR");
};

export fn unlex(lexr: *lexer, tok: token) void = {
	return;
};

fn advance(lexr: *lexer) ((rune, location) | io::EOF | io::error | syntax) = {
	const loc = location {
		path = lexr.path,
		line = lexr.loc.0,
		col = lexr.loc.1
	};
	match (bufio::scan_rune(lexr.in)) {
	case let r: rune =>
		updateloc(lexr, r);
		return (r, loc);
	case let e: (io::EOF | io::error) =>
		return e;
	case let invalid: utf8::invalid =>
		return (loc, "Invalid utf8 encoding found.");
	};
};

fn backpedal(lexr: *lexer, r: rune) void = {
	bufio::unreadrune(lexr.in, r);
	lexr.loc = lexr.prevrloc;
};

export fn syntaxerr(loc: location, why: str) error = {
	static let buf = path::buffer{...};
	path::set(&buf, loc.path)!;
	loc.path = path::string(&buf);
	return (loc, why);
};

fn updateloc(lexr: *lexer, r: rune) void = {
	lexr.prevrloc = lexr.loc;
	switch (r) {
	case '\n' =>
		lexr.loc.0 += 1;
		lexr.loc.1 = 1;
	case '\t' =>
		lexr.loc.1 += 8;
	case =>
		lexr.loc.1 += 1;
	};
};

fn is_word_rune(r: rune, is_first_rune: bool) bool = {
	if (ascii::isalpha(r) || r == '@' || r == '_') {
		return true;
	};

	if (!is_first_rune && ascii::isalnum(r)) {
		return true;
	};

	return false;
};

fn lex_word(lexr: *lexer) (token | error) = {
	const buffer = memio::dynamic();

	const loc = location {
		path = lexr.path,
		line = lexr.loc.0,
		col = lexr.loc.1
	};

	let is_first_rune = true;
	for (true) {
		const tok = match (advance(lexr)?) {
		case let t: (rune, location) =>
			yield t;
		};

		if (!is_word_rune(tok.0, is_first_rune)) {
			backpedal(lexr, tok.0);
			break;
		};

		is_first_rune = false;
		memio::appendrune(&buffer, tok.0)!;
	};

	let key = memio::string(&buffer) as str;

	match (sort::search(bmap[..ltok::LAST_KEYWORD+1],
		size(str), &key, &cmp::strs)) {
	case void =>
		return (ltok::NAME, key, loc);
	case let i: size =>
		free (key);
		return (i: ltok, void, loc);
	};
};

fn lex_number(lexr: *lexer) (token | error) = {
	const buffer = memio::dynamic();

	const loc = location {
		path = lexr.path,
		line = lexr.loc.0,
		col = lexr.loc.1
	};

	let tok = match (advance(lexr)?) {
	case let t: (rune, location) =>
		yield t;
	};

	let base_digits = "1234567890";
	if (tok.0 == '0') {
		memio::appendrune(&buffer, tok.0)!;
		tok = match (advance(lexr)?) {
		case let t: (rune, location) =>
			yield t;
		};

		switch (tok.0) {
		case 'b' =>
			base_digits = "01";
		case 'o' =>
			base_digits = "01234567";
		case 'x' =>
			base_digits = "1234567890ABCDEFabcdef";
		case =>
			if (strings::contains(base_digits, tok.0)) {
				return syntaxerr(loc, "Base 10 numbers cannot have leading zeroes.");
			} else {
				backpedal(lexr, tok.0);
				let num = memio::string(&buffer) as str;
				return (ltok::LIT_ICONST, num, loc);
			};
		};

		memio::appendrune(&buffer, tok.0)!;
	} else  {
		backpedal(lexr, tok.0);
	};

	for (true) {

		tok = match (advance(lexr)?) {
		case let t: (rune, location) =>
			yield t;
		};

		if (!strings::contains(base_digits, tok.0)) {
			backpedal(lexr, tok.0);
			break;
		};

		memio::appendrune(&buffer, tok.0)!;
	};

	let key = memio::string(&buffer) as str;

	return (ltok::LIT_ICONST, key, loc);
};

fn match_rune(lexr: *lexer, r: rune) bool = {
	match (advance(lexr)!) {
	case io::EOF =>
		backpedal(lexr, r);
		return false;
	case let r2: (rune, location) =>
		if (r2.0 == r) {
			return true;
		} else {
			backpedal(lexr, r2.0);
			return false;
		};
	};
};

fn lex_troll(lexr: *lexer) (token | error) = {
	const run = match (advance(lexr)?) {
	case io::EOF =>
		const loc = location {
			path = lexr.path,
			line = lexr.loc.0,
			col = lexr.loc.1
		};
		return (ltok::EOF, void, loc);
	case let r: (rune, location) =>
		yield r;
	};

	const token = switch (run.0) {
	case '.' =>
		if (match_rune(lexr, '.')) {
			if (match_rune(lexr, '.')) {
				return (ltok::ELLIPSIS, void, run.1);
			};
			return (ltok::DOUBLE_DOT, void, run.1);
		};
		return (ltok::DOT, void, run.1);
	case '<' =>
		if (match_rune(lexr, '=')) {
			return (ltok::LESSEQ, void, run.1);
		} else if (match_rune(lexr, '<')) {
			if (match_rune(lexr, '=')) {
				return (ltok::LSHIFTEQ, void, run.1);
			};
			return (ltok::LSHIFT, void, run.1);
		};
		return (ltok::LESS, void, run.1);
	case '>' =>
		if (match_rune(lexr, '=')) {
			return (ltok::GTEQ, void, run.1);
		} else if (match_rune(lexr, '>')) {
			if (match_rune(lexr, '=')) {
				return (ltok::RSHIFTEQ, void, run.1);
			};
			return (ltok::RSHIFT, void, run.1);
		};
		yield ltok::GT;
	case '&' =>
		if (match_rune(lexr, '=')) {
			return (ltok::BANDEQ, void, run.1);
		} else if (match_rune(lexr, '&')) {
			if (match_rune(lexr, '=')) {
				return (ltok::LANDEQ, void, run.1);
			};
			return (ltok::LAND, void, run.1);
		};
		return (ltok::BAND, void, run.1);
	case '|' =>
		if (match_rune(lexr, '=')) {
			return (ltok::BOREQ, void, run.1);
		} else if (match_rune(lexr, '&')) {
			if (match_rune(lexr, '=')) {
				return (ltok::LOREQ, void, run.1);
			};
			return (ltok::LOR, void, run.1);
		};
		return (ltok::BOR, void, run.1);
	case '^' =>
		if (match_rune(lexr, '=')) {
			return (ltok::BXOREQ, void, run.1);
		} else if (match_rune(lexr, '&')) {
			if (match_rune(lexr, '=')) {
				return (ltok::LXOREQ, void, run.1);
			};
			return (ltok::LXOR, void, run.1);
		};
		return (ltok::BXOR, void, run.1);
	case '*' =>
		if (match_rune(lexr, '=')) {
			return (ltok::TIMESEQ, void, run.1);
		};
		return (ltok::TIMES, void, run.1);
	case '%' =>
		if (match_rune(lexr, '=')) {
			return (ltok::MODEQ, void, run.1);
		};
		return (ltok::MODULO, void, run.1);
	case '/' =>
		if (match_rune(lexr, '=')) {
			return (ltok::DIVEQ, void, run.1);
		} else if (match_rune(lexr, '=')) {
			return (ltok::DIVEQ, void, run.1);
		};
		return (ltok::DIV, void, run.1);
	case '+' =>
		if (match_rune(lexr, '=')) {
			return (ltok::PLUSEQ, void, run.1);
		};
		return (ltok::PLUS, void, run.1);
	case '-' =>
		if (match_rune(lexr, '=')) {
			return (ltok::MINUSEQ, void, run.1);
		};
		return (ltok::MINUS, void, run.1);
	case ':' =>
		if (match_rune(lexr, ':')) {
			return (ltok::DOUBLE_COLON, void, run.1);
		};
		return (ltok::COLON, void, run.1);
	case '!' =>
		if (match_rune(lexr, '=')) {
			return (ltok::NEQUAL, void, run.1);
		};
		return (ltok::LNOT, void, run.1);
	case '=' =>
		if (match_rune(lexr, '=')) {
			return (ltok::LEQUAL, void, run.1);
		} else if (match_rune(lexr, '>')) {
			return (ltok::ARROW, void, run.1);
		};
		return (ltok::EQUAL, void, run.1);
	case =>
		return syntaxerr(run.1, "invalid character");
	};

	return (token, void, run.1);
};

fn lex_literal_str(lexr: *lexer) (token | error) = {
	const buffer = memio::dynamic();

	const loc = location {
		path = lexr.path,
		line = lexr.loc.0,
		col = lexr.loc.1 - 1
	};

	let is_first_rune = true;
	for (true) {
		const tok = match (advance(lexr)?) {
		case let t: (rune, location) =>
			yield t;
		};


		if (tok.0 == '"') {
			break;
		};

		is_first_rune = false;
		memio::appendrune(&buffer, tok.0)!;
	};

	if (is_first_rune) {
		return (ltok::LIT_STR, "", loc);
	};

	let key = memio::string(&buffer) as str;

	return (ltok::LIT_STR, key, loc);
};
