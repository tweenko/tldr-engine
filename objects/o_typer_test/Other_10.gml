var possible_text = "* Lorem ipsum dolor sit amet, consectetur adipiscing elit.{p}{c}* In vitae dolor libero.{p}{c}* Hello";
if loc_getlang() == "ja"
    possible_text = "＊ (スージィは　なにをしようと していたか 忘れた！ スージィの アクションは　キャンセルされた)";

t = new typer(possible_text, 32, 320, 0, true);
t.break_tabulation_enabled = true;

t.create_projection();