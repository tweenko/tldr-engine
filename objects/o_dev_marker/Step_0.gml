if walk_toggle {
	if collision_point(get_leader().x, get_leader().y, id, 0, 0) {
		if !toggled {
			var idd = m_toggle_group
			with(o_dev_marker) {
				if idd == m_toggle_group 
					toggled = false
			}
			toggled = true
		}
	}
}