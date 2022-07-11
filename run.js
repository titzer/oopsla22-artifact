function empty() { }

var imports = {
  wasi_snapshot_preview1: {
    "fd_write": empty,
    "fd_seek": empty,
    "fd_close": empty,
    "proc_exit": x => quit(x), 
    "args_sizes_get": empty,
    "args_get": empty
  }
};

if (typeof WScript != "undefined") {
  arguments = WScript.Arguments
}

if (typeof scriptArgs == "object") {
  arguments = scriptArgs
}

var buffer = typeof readbuffer == "function" ?
    (readbuffer(arguments[0])) :
    (read(arguments[0], 'binary'));

var module = new WebAssembly.Module(buffer);
var instance = new WebAssembly.Instance(module, imports);

instance.exports["_start"]();
