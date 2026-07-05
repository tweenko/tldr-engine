perspective_prev = 0;
surf_pal = -1;

start = method(self, function() {
    pal_swap_set(surf_pal, 1, true);
})
stop = method(self, function() {
    pal_swap_reset();
})