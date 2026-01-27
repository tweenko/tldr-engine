bg_data = new DiebackDataGen(320, 240);

bg_data.n_layer(spr_ch5_eff_shriekbg_fountain, 0, 1)
bg_data.s_background_position(30, 30, DIEBACK_MOTION.SCROLLING)
bg_data.s_axis_distortion(DIEBACK_AXIS.X, DIEBACK_DISTORTION.OSCILLATION, 90, 70)
bg_data.s_axis_distortion(DIEBACK_AXIS.Y, DIEBACK_DISTORTION.INTERLACED, 250, 50)
bg_data.s_axis_motion(30, 110, DIEBACK_MOTION.SCROLLING)
bg_data.s_planar(-0.1)

bg_data.n_layer(spr_ch5_eff_shriekbg_depth, 0, .5)
bg_data.s_background_position(-15, -15, DIEBACK_MOTION.SCROLLING)
bg_data.s_blend(DIEBACK_BLENDMODE.ADD)

bg_data.flip()

bg_inst = new DiebackInst();
bg_inst.load(bg_data); // load our from code BG into a dieback instance

animate(0, 1, 120, anime_curve.linear, self, "image_alpha")