if siner >= 100
    siner -= 100
if siner2 >= 100
    siner2 -= 100

if destroy {
    image_alpha -= 0.1
    if image_alpha <= 0
        instance_destroy()
}
else {
	if image_alpha <= 1
        image_alpha += 0.1
}