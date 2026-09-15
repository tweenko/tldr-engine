for (var i = 0; i < party_length(); ++i) {
	if surface_exists(party_ui_button_surf[i])
		surface_free(party_ui_button_surf[i])
}

if surface_exists(surf)
	surface_free(surf)