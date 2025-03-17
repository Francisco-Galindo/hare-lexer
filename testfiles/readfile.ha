use errors;
use fmt;
use io;
use os;
use fs;

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

	for (true) {
		const n = match(io::read(file, buffer)) {
		case let err: errors::error =>
			fmt::fatalf("Error reading {}: {}",
				path, errors::strerror(err));
		case let m: (size | io::EOF) =>
			yield m as size;
		};
		io::write(os::stdout, buffer[..n])!;
		if (n < 65535) {
			break;
		};
	};
};
