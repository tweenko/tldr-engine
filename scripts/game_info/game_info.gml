#macro GAME_VERSION "v1.12.1+1"
#macro GAME_NAME "tlDR Engine"
#macro GAME_LAST_COMPATIBLE_VERSION "v1.12.0" // last compatible save version

/// @arg {real} version
function __game_version_to_real(version) {
    version = string_delete(version, 1, 1)
    
    var __version_array = string_split(string_split(version, "+")[0], ".") // version number array
    var __hotfix = string_split(version, "+")
    
    if array_length(__hotfix) > 1
        __hotfix = real(string_digits(__hotfix[1]))
    else
    	__hotfix = 0
    
    var __ret = 0
    for (var i = 0; i < array_length(__version_array); i ++) {
        __ret += real(__version_array[i]) * power(10, (array_length(__version_array)-1 - i)*3)
    }
    
    return __ret * 100 + __hotfix
}

/// @desc will return true if a >= b 
function __game_versions_compare(a, b) {
    return __game_version_to_real(a) >= __game_version_to_real(b)
}