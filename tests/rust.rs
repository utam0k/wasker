use wasker::compiler;

#[test]
fn rust() {
    let wat = "./helloworld.wat";
    let args = compiler::Args {
        input_file: wat.to_string(),
        output_file: "/tmp/wasm.o".to_string(),
    };
    compiler::compile_wasm_from_file(&args).expect("fail compile");
}
