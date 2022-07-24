use std::io;

fn main() {
    loop {
        println!("user>");
        rep(String::from("hello"));
    }
}

fn read(code: String) -> String {
    code
}

fn eval(code: String) -> String {
    code
}

fn print(code: String) -> String {
    code
}

fn rep(code: String) {
    println!("{}", print(eval(read(code))));
}
