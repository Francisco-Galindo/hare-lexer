use bufio;
use fmt;
use os;
use strings;

export fn main() void = {
	const user = askname();
	greet(user);
};

fn askname() str = {
	fmt::println("Hello! Please enter your name:")!;
	const name = bufio::read_line(os::stdin)! as []u8;
	return strings::fromutf8(name)!;
};

fn greet(user: str) void = {
	fmt::printfln("Hello, {}!", user)!;
};
