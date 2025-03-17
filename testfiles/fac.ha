use fmt;

export fn main() void = {
	let n = 5;
	for (n >= 0) {
		fmt::printfln("n: {} \tfac(n): {}", n, fac(n))!;
		n -= 1;
	};
};

fn fac(n: int) int = {
	if (n <= 1) {
		return 1;
	};
	return n * fac(n-1);
};
