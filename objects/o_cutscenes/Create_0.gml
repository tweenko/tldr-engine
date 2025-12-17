if room == room_castle_town_cutscene_1 and global.save.PLOT = 0
{
    cutscene_create()
    cutscene_func(function(){
        fader_fade(1,0,60)
        instance_create(o_actor_susie,160,240)
        instance_create(o_actor_ralsei,160,0)
    })
    cutscene_actor_move(o_actor_susie, new actor_movement(160,180,60,,,DIR.UP),,true,true)
    cutscene_sleep(30)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left_serious)
    cutscene_sleep(20)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_right_serious)
    cutscene_sleep(20)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_up_serious)
    cutscene_dialogue([
        "{char(susie,13)}* Ralsei...?"
    ],,,false)
    cutscene_sleep(30)
    cutscene_actor_move(o_actor_ralsei, new actor_movement(160,100,30,,,DIR.DOWN),,true,true)
    cutscene_dialogue([
        "{char(ralsei,21)}* Susie...?",
        "{char(susie,13)}* 'Sup.",
        "{char(ralsei,11)}* Susie, I'm so glad to see you...",
        "{f_ex(4)}* But... why did you come here...?",
        "{f_ex(5)}* You're not supposed to--",
        "{char(susie,21)}* Well, I'm here whether you like it or not.",
        "{char(ralsei,12)}* O-Oh, that's not what I--",
    ])
    cutscene_actor_move(o_actor_susie, new actor_movement(179,100,20,,,DIR.UP),,true,true)
    cutscene_set_variable(o_actor_susie,"image_speed",1)
    cutscene_set_variable(o_actor_susie,"custom_depth",-2200)
    cutscene_animate(5,0,5,"linear",o_actor_susie,"shake")
    cutscene_animate(5,0,5,"linear",o_actor_ralsei,"shake")
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_punch_left)
    cutscene_audio_play(snd_impact)
    cutscene_sleep(10)
    cutscene_set_variable(o_actor_susie,"image_speed",0)
    cutscene_dialogue([
        "{char(susie,2)}* You're such a dork, you know that?",
        "{char(ralsei,1)}* ...",
        "{f_ex(2)}* Well, I'm happy to have you here regardless, Susie.",
    ])
    cutscene_actor_move(o_actor_ralsei,new actor_movement(150,100,10,,,DIR.RIGHT),,false,true)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left)
    cutscene_set_variable(o_actor_susie,"image_index",0)
    cutscene_dialogue([
        "{char(ralsei,9)}* Isn't it a bit late, though? You should get some rest.",
        "{char(susie,6)}* Huh?"
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left_serious)
    cutscene_dialogue([
        "{char(susie,11)}* Ralsei...",
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_arm_cross)
    cutscene_dialogue([
        "{char(susie,5)}* Are you KIDDING me?",
        "* Don't you know the first rule of sleepovers?",
        "{char(susie,34)}* We are gonna stay the HELL up.",
        "* It's gonna beat the crap out of my sleepover with Kris last night.",
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_arm_cross_sweat)
    cutscene_dialogue([
        "{char(ralsei,19)}* Oh, is that what we're doing? A sleepover?",
        "{char(susie,5)}* Duh!",
        "{char(ralsei,9)}* That reminds me...",
        "{f_ex(10)}* Where's Kris?",
        "{char(susie,13)}* Uh..."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left)
    cutscene_dialogue([
        "{char(susie,10)}* They're at their house.",
        "* I... dropped them off and then, uh, came here.",
        "{char(ralsei,10)}* I see."
    ])
    cutscene_sleep(10)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_pose)
    cutscene_dialogue([
        "{char(ralsei,17)}* Well, what do you want to do?",
        "{char(susie,21)}* Well, I...",
        "{f_ex(20)}* I was thinking... maybe we could...",
        "* ..."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right)
    cutscene_dialogue([
        "{char(ralsei,2)}* Yes, Susie...?",
        "{char(susie,20)}* ... I, um...",
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_rage_left)
    cutscene_animate(5,0,5,"linear",o_actor_susie,"shake")
    cutscene_audio_play(snd_impact)
    cutscene_dialogue([
        "{char(susie,17)}* I wanna have another tea party, okay!?"
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_laughing)
    cutscene_set_variable(o_actor_ralsei,"image_speed",1)
    cutscene_dialogue([
        "{char(ralsei,25)}* Hahaha! Alright, let's have another tea party.",
        "{char(susie,17)}* The hell are you laughing at!?",
        "{char(ralsei,2)}* Nothing, Susie."
        ])
    cutscene_set_variable(o_actor_ralsei,"image_speed",0)
    cutscene_set_variable(o_actor_ralsei,"image_index",0)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left)
    cutscene_dialogue([
        "{char(susie,3)}* Okay, let's go already."
    ])
    cutscene_actor_move(o_actor_ralsei,new actor_movement(150,0,60,,,DIR.UP),,false)
    cutscene_actor_move(o_actor_susie, new actor_movement(179,0,60,,,DIR.UP),,false)
    cutscene_sleep(30)
    cutscene_func(fader_fade,[0,1,30])
    cutscene_sleep(30)
    cutscene_func(room_goto,[room_castle_town_cutscene_2])
    cutscene_play()
}

if room == room_castle_town_cutscene_2
{
    cutscene_create()
    cutscene_func(function(){
        instance_create(o_actor_susie,70,270)
        instance_create(o_actor_ralsei,70,300)
        fader_fade(1,0,30)
    })
    cutscene_actor_move(o_actor_susie,[
        new actor_movement(70,160,55,,,DIR.UP),
        new actor_movement(210,160,70,,,DIR.RIGHT)
    ],,false,true)
    cutscene_actor_move(o_actor_ralsei,[
        new actor_movement(70,160,70,,,DIR.UP)
    ],,false,true)
    cutscene_sleep(70)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right)
    cutscene_sleep(55)
    cutscene_dialogue([
        "{char(ralsei,22)}* Um, Susie?",
        "* Your rooms are right here."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_left)
    cutscene_dialogue([
        "{char(susie,1)}* Oh yeah.",
        "{f_ex(21)}* I was thinking we could have the tea party at your room."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right_blushing)
    cutscene_dialogue([
        "{char(ralsei,13)}* M... My room...?",
        "{char(susie,4)}* Don't make it weird.",
        "{f_ex(13)}* It's just...",
        "{f_ex(29)}* It would really liven it up, you know?"
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right)
    cutscene_dialogue([
        "{char(ralsei,0)}* Of course.",
        "{f_ex(2)}* Alright then!"
    ])
    cutscene_actor_move(o_actor_susie,new actor_movement(330,160,60,,,DIR.RIGHT),,false)
    cutscene_actor_move(o_actor_ralsei,new actor_movement(330,160,130,,,DIR.RIGHT),,false)
    cutscene_sleep(70)
    cutscene_func(fader_fade,[0,1,30])
    cutscene_sleep(60)
    cutscene_func(room_goto,[room_castle_town_cutscene_3])
    cutscene_play()
}

if room == room_castle_town_cutscene_3
{
    cutscene_create()
    cutscene_func(function(){
        instance_destroy(o_actor_mover)
        instance_create(o_actor_susie,216,150)
        instance_create(o_actor_ralsei,113,142)
        o_actor_susie.s_override = true
        o_actor_ralsei.s_override = true
        o_actor_susie.sprite_index = spr_susie_tea
        o_actor_ralsei.sprite_index = spr_ralsei_tea
        o_actor_ralsei.custom_depth = -2400
        inst_apple.custom_depth = -2500
        inst_cake.custom_depth = -2500
        inst_cake_slice_1.custom_depth = -2500
        inst_cake_slice_2.custom_depth = -2500
        inst_kettle.custom_depth = -2500
        inst_tea_cup_susie.custom_depth = -2500
        inst_tea_cup_ralsei.custom_depth = -2500
        fader_fade(1,0,30)
    })
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(susie,21)}* So... what's up?"
    ])
    cutscene_func(music_play,[mus_friends,0,true])
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(ralsei,5)}* Well...",
        "{f_ex(2)}* Admittedly, I've had more of my cake.",
        "{f_ex(13)}* It's really, really yummy...",
        "{char(susie,2)}* Heh. Nice.",
    ])
    cutscene_sleep(30)
    cutscene_dialogue("{char(ralsei,9)}* ... Susie...")
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_serious)
    cutscene_dialogue([
        "{char(ralsei,2)}* Thank you.",
        "{f_ex(26)}* You've really... helped me appreciate things more.",
        "* If that, um, makes sense.",
        "{f_ex(4)}* Before, I didn't really care about...",
        "{f_ex(40)}* Well... myself.",
        "{f_ex(5)}* But now, knowing you and Kris care about me...",
        "{f_ex(9)}* Knowing that you really care about me... that we're friends...",
        "{f_ex(5)}* ...",
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_happy)
    cutscene_dialogue([
        "{char(ralsei,2)}* Thank you for being my friend, Susie.",
        "{char(susie,13)}* Ralsei...",
        "{f_ex(29)} * ..."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea)
    cutscene_dialogue([
        "{char(susie,21)}* I feel the same way.",
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_reach)
    cutscene_sleep(5)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(inst_tea_cup_susie,"visible",false)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_far)
    cutscene_sleep(5)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold)
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(susie,9)}* Man, these adventures...",
        "{f_ex(10)}* They're so... stupid sometimes...",
        "{f_ex(21)}* But they've really brought us closer, huh."
    ])
    cutscene_audio_play(snd_swallow)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_drink)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_happy)
    cutscene_dialogue([
        "{char(ralsei,26)}* They have.",
        "{f_ex(5)}* I... want to have another one..."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold)
    cutscene_dialogue([
        "{char(susie,2)}* You can say that again.",
        "{f_ex(0)}* ...",
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_serious)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_serious)
    cutscene_dialogue([
        "{char(susie,1)}* Knight's still an issue, though.",
        "{f_ex(13)}* We still don't know what they want, and they're really dangerous.",
        "{f_ex(24)}* No progress in rescuing Officer Undyne either.",
        "{f_ex(27)}* Man, I feel so dumb for WANTING another Dark World.",
        "{f_ex(28)}* But I just... wanna have fun, you know?",
        "{char(ralsei,5)}* ..."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_reach)
    cutscene_sleep(5)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(inst_tea_cup_ralsei,"visible",false)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_hold_far)
    cutscene_sleep(5)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_hold)
    cutscene_sleep(10)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_drink)
    cutscene_audio_play(snd_swallow)
    cutscene_sleep(30)
    cutscene_audio_play(snd_swallow)
    cutscene_sleep(30)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_hold_far)
    cutscene_sleep(5)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(inst_tea_cup_ralsei,"visible",true)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_reach)
    cutscene_sleep(5)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_serious)
    cutscene_sleep(30)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_serious)
    cutscene_dialogue([
        "{char(ralsei,4)}* Susie... Why did you come here, really?"
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_lookaway)
    cutscene_dialogue([
        "{char(susie,0)}* I told you, I just wanted to have a tea party."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_serious)
    cutscene_dialogue([
        "{char(ralsei,4)}* But... now? In the middle of the night...?",
        "{char(susie,23)}* ..."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_lookaway)
    cutscene_dialogue([
        "{char(susie,0)}* Look, something happened...",
        "* And I guess I just wanted to be with a friend.",
        "{f_ex(23)}* It's stupid, I know.{br}{resetx}* But that's how I feel."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_hold_serious)
    cutscene_dialogue([
        "{char(ralsei,3)}* It's not stupid at all, Susie.",
        "{f_ex(2)}* I... I get it, I think.",
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_happy)
    cutscene_dialogue([
        "{char(ralsei,2)}* If you want to talk about it, I'm here for you."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea)
    cutscene_dialogue([
        "{char(susie,3)}* Um... thanks. But really, it's no big deal. I'm fine.",
        "{char(ralsei,2)}* Alright. We can talk about anything you want, Susie.",
        "{char(susie,28)}* ..."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_drink)
    cutscene_audio_play(snd_swallow)
    cutscene_sleep(30)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_reach_tea)
    cutscene_sleep(5)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(inst_tea_cup_susie,"visible",true)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_reach)
    cutscene_sleep(5)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea)
    cutscene_dialogue([
        "{char(susie,21)}* So, isn't this the first time we're hanging out alone in a while?",
        "{char(ralsei,19)}* Oh. I guess that's right.",
        "{f_ex(18)}* The last time we were alone was... when we played games at TV World.",
        "* And before that, when we split up in the Cyber World.",
        "{char(susie,9)}* Oh yeah. When I became the healing master.",
        "{char(ralsei,16)}* Right.",
        "{f_ex(2)}* Your healing's been getting really good, by the way!",
        "{char(susie,21)}* Oh yeah. Thanks.",
        "{f_ex(2)}* Turns out you just need to practice.",
        "* The more I do it, the better I get."
        ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_happy)
    cutscene_dialogue([
        "{char(ralsei,2)}* That's really good, Susie. Congratulations!",
        "{char(susie,2)}* Heh... it's nothing, really."
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea)
    cutscene_dialogue([
        "{char(susie,10)}* So, hey, the festival's tomorrow...",
        "{char(ralsei,10)}* Oh, is that so...?",
        "{f_ex(0)}* Are you going with Kris?",
        "{char(susie,6)}* Huh? I mean, yeah, of course.",
        "{f_ex(2)}* But I'm going with Noelle too.",
        "{char(ralsei,19)}* Oh, really?",
        "{char(susie,2)}* Yeah, it's gonna be awesome.",
        "{f_ex(6)}* Hey, now that I think about it...",
        "{f_ex(10)}* Wouldn't it be cool to have her join us in the next Dark World?",
        "{char(ralsei,19)}* ...",
    ])
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_happy)
    cutscene_dialogue([
        "{char(ralsei,2)}* That's a--{c}"
    ],,false)
    cutscene_wait_dialogue_boxes(1)
    cutscene_func(function(){
        instance_destroy(o_ui_dialogue)
        instance_destroy(o_text_typer)
        instance_destroy(o_text_face)
    })
    cutscene_func(music_stop,0)
    cutscene_audio_play(snd_knock)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_tea_shocked)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_shocked)
    cutscene_func(screen_shake,[5,5])
    cutscene_sleep(45)
    cutscene_audio_play(snd_knock)
    cutscene_sleep(30)
    cutscene_audio_play(snd_knock)
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(ralsei,21)}* Um, who's there--{c}"
    ],,false)
    cutscene_wait_dialogue_boxes(1)
    cutscene_func(function(){
        instance_destroy(o_ui_dialogue)
        instance_destroy(o_text_typer)
        instance_destroy(o_text_face)
    })
    cutscene_audio_play(snd_knock)
    cutscene_func(screen_shake,[5,15])
    cutscene_sleep(30)
    cutscene_dialogue([
        "{char(ralsei,22)}* ...",
        "{f_ex(20)}* I'll, erm, go get it."
    ])
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_serious)
    cutscene_audio_play(snd_noise)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_down)
    cutscene_set_variable(o_actor_ralsei,"y",150)
    cutscene_sleep(5)
    cutscene_actor_move(o_actor_ralsei,[
        new actor_movement(113,190,20,,,DIR.DOWN),
        new actor_movement(160,190,20,,,DIR.RIGHT),
        new actor_movement(160,235,20,,,DIR.DOWN)
    ],,true,true)
    cutscene_audio_play(snd_dooropen)
    cutscene_sleep(20)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_down_shocked)
    cutscene_animate(10,0,5,"linear",o_actor_ralsei,"shake")
    cutscene_sleep(10)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_tea_shocked)
    cutscene_dialogue([
        "{char(ralsei,35)}* K... Kris!?"
    ],,true,false)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_down_serious)
    cutscene_set_variable(o_actor_ralsei,"image_speed",2)
    cutscene_animate(235,300,15,"linear",o_actor_ralsei,"y")
    cutscene_sleep(15)
    cutscene_func(fader_fade,[0,1,20])
    cutscene_sleep(20)
    cutscene_func(room_goto,[room_castle_town_cutscene_4])
    cutscene_play()
}

if room == room_castle_town_cutscene_4
{
    cutscene_create()
    cutscene_func(function(){
        instance_create(o_actor_ralsei,140,160)
        instance_create(o_actor_kris,180,160)
        o_actor_ralsei.s_override = true
        o_actor_kris.s_override = true
        o_actor_ralsei.sprite_index = spr_ralsei_shock
        o_actor_kris.sprite_index = spr_kris_fallen
        fader_fade(1,0,20)
        o_actor_kris.shake = 1
    })
    cutscene_sleep(20)
    cutscene_func(function(){
        instance_create(o_actor_susie,100,140)
        o_actor_susie.s_move[DIR.DOWN] = spr_susie_down_serious
        o_actor_susie.s_move[DIR.RIGHT] = spr_susie_right_serious
        o_actor_ralsei.s_move[DIR.RIGHT] = spr_ralsei_right_serious
        
    })
    cutscene_actor_move(o_actor_susie,new actor_movement(100,160,5,,,DIR.DOWN),,true,true)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_surprise)
    cutscene_dialogue([
        "{char(susie,43)}* K... Kris!? What's going on!?"
    ],,true,false)
    cutscene_set_variable(o_actor_kris,"shake",0)
    cutscene_sleep(30)
    cutscene_audio_play(snd_petrify)
    cutscene_set_variable(o_actor_kris,"sprite_index",spr_kris_fallen_stone_anim)
    cutscene_set_variable(o_actor_kris,"image_speed",1)
    cutscene_sleep(20)
    cutscene_set_variable(o_actor_kris,"sprite_index",spr_kris_fallen_stone)
    cutscene_sleep(30)
    cutscene_func(music_play,[mus_chase,0,true])
    cutscene_set_variable(o_actor_ralsei,"image_speed",0)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_left_serious)
    cutscene_dialogue([
        "{char(ralsei,51)}* Susie, you need to take Kris back to their house NOW.",
        "{char(susie,44)}* Why!? What's happening!?",
        "{char(ralsei,52)}* There's no time to explain!",
        "* Get them to their house and to their room!",
        "* They can't move their legs, so you'll have to carry them.",
        "{char(susie,44)}* Okay!"
    ],,true,false)
    cutscene_set_variable(o_actor_ralsei,"sprite_index",spr_ralsei_right_serious)
    cutscene_actor_move(o_actor_susie,new actor_movement(180,160,20,,,DIR.RIGHT),,true,true)
    cutscene_sleep(5)
    cutscene_audio_play(snd_wing)
    cutscene_animate(10,0,5,"linear",o_actor_susie,"shake")
    cutscene_set_variable(o_actor_kris,"visible",false)
    cutscene_func(function(){
        o_actor_susie.s_move[DIR.RIGHT] = spr_susie_right_kris
    })
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_right_kris)
    cutscene_sleep(10)
    cutscene_actor_move(o_actor_susie,new actor_movement(350,160,30,,,DIR.RIGHT),,false)
    cutscene_actor_move(o_actor_ralsei,new actor_movement(310,160,30,,,DIR.RIGHT),,false)
    cutscene_sleep(10)
    cutscene_func(fader_fade,[0,1,20])
    cutscene_func(function(){global.save.PLOT = 1})
    cutscene_sleep(20)
    cutscene_func(room_goto,[room_castle_town_cutscene_1])
    cutscene_play()
}

if room == room_castle_town_cutscene_1 and global.save.PLOT = 1
{
    cutscene_create()
    cutscene_func(function(){
        instance_create(o_actor_susie,160,0)
        instance_create(o_actor_ralsei,160,0)
        o_actor_susie.s_move[DIR.DOWN] = spr_susie_down_kris
        o_actor_ralsei.s_move[DIR.DOWN] = spr_ralsei_down_serious
        fader_fade(1,0,20)
    })
    cutscene_actor_move(o_actor_susie,new actor_movement(160,200,60,,,DIR.DOWN),,false,true)
    cutscene_sleep(20)
    cutscene_actor_move(o_actor_ralsei,new actor_movement(160,132,40,,,DIR.DOWN),,false,true)
    cutscene_sleep(40)
    cutscene_set_variable(o_actor_susie,"sprite_index",spr_susie_up_kris)
    cutscene_dialogue([
        "{char(susie,31)}* Bye."
    ],,true,false)
    cutscene_actor_move(o_actor_susie,new actor_movement(160,300,30,,,DIR.DOWN),,false)
    cutscene_func(music_fade,[0,0,30])
    cutscene_sleep(60)
    cutscene_dialogue([
        "{char(ralsei,39)}* ...",
        "{f_ex(38)}* (Why did Kris...)",
        "* ...",
        "{f_ex(37)}* ...",
        "{f_ex(36)}* (Well, it was nice spending time with Susie for a while.)",
        "* ...",
        "* (Gosh, she really is something special, isn't she...?)",
        "{f_ex(38)}* ...",
    ])
    cutscene_func(fader_fade,[0,1,60])
    cutscene_sleep(90)
    cutscene_play()
}