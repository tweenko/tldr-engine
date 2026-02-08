/// @desc update
while sleep == 0 {
    if ds_queue_empty(actions)
        exit
    
    var args = ds_queue_dequeue(actions)
    method_call(args[0], args, 1)
}