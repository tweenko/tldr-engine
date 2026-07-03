/// @description init record
var size = pos + 1;

record_targets = [
    new record_target("x", x),
    new record_target("y", y),
    new record_target("dir", dir),
    new record_target("running", false),
    new record_target("sliding", false),
    new record_target("pf_grounded", false),
];
record = array_create_ext(size, function() { return __new_record(true) });