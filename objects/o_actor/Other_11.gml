/// @description init record
var size = max(pos_max, pos) + 1;

record_targets = [
    new record_target("x", x),
    new record_target("y", y),
    new record_target("dir", dir),
    new record_target("running", false),
    new record_target("sliding", false),
    new record_target("pf_grounded", true),
    new record_target("pf_land", 0),
];
record = array_create_ext(size, function() { return __new_record(true) });