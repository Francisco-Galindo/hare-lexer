use bufio;
use fmt;
use io;
use os;
use sort;
use strings;

export fn main() void = {
	fmt::println("Enter no more than 10 strings, then press <Ctrl+D>:")!;

	let buf: [10]str = [""...];
	let lines = buf[..0];
	defer for (let line .. buf) {
		free(line);
	};

	for (true) {
		const line = match (bufio::read_line(os::stdin)!) {
		case let line: []u8 =>
			yield line;
		case io::EOF =>
			break;
		};
		static append(lines, strings::fromutf8(line)!);
	};

	static insert(lines[0], strings::dup("test line"));

	for (let i = 0; i < len(lines); i += 1) {
		if (lines[i] == "foobar") {
			free(lines[i]);
			static delete(lines[i]);
			i -= 1;
		};
	};

	sort::strings(lines);

	fmt::println("Your strings, sorted:")!;
	for (let line .. lines) {
		fmt::println(line)!;
	};
};
