///@desc changes a value in the party data struct
///@arg {String} name
///@arg {String} hash
///@arg {Any} value
///@return {Struct}
function party_setdata(name, hash, value) {
	struct_set(party_nametostruct(name), hash, value)
}

///@desc adds to a value in the party data struct (works like a var struct)
///@arg {String} name
///@arg {String} hash
///@arg {Any} value
function party_adddata(name, hash, value) {
	if is_struct(value) {
		var st = party_getdata(name, hash)
        
		for (var i = 0; i < struct_names_count(value); ++i) {
			var n = struct_get_names(value)[i] 
            var val = struct_get(value, n)
            
		    if struct_exists(st, n) 
				val += struct_get(st, n)
			struct_set(st, n, val)
		}
	}
	else
		struct_set(party_nametostruct(name), hash, struct_get(party_nametostruct(name), hash) + value)
}

///@desc substracts from a value in the party data struct
///@arg {String} name
///@arg {String} hash
///@arg {Any} value
function party_subtractdata(name, hash, value) {
	if is_struct(value) {
		var st = party_getdata(name, hash)
        
		for (var i = 0; i < struct_names_count(value); ++i) {
			var n = struct_get_names(value)[i] 
            var val = -struct_get(value, n)
            
		    if struct_exists(st, n) 
				val += struct_get(st, n)
			struct_set(st, n, val)
		}
	}
	else
		struct_set(party_nametostruct(name), hash, struct_get(party_nametostruct(name), hash) - value)
}

///@desc set whether the party members should be following their leader
function party_setfollow(follow) {
	for (var i = 1; i < array_length(global.party_names); ++i) {
		party_get_inst(global.party_names[i]).follow = follow
	}
}