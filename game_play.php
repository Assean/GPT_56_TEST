<?php require_once __DIR__.'/includes/common.php'; $id=(int)($_GET['id']??1); $st=db()->prepare('SELECT * FROM games WHERE id=?');$st->execute([$id]);$g=$st->fetch(); $json=@json_decode(@file_get_contents(__DIR__.'/'.$g['folder_path'].'game.json'),true); ?>
<div id="game-play"><div class="current-game-title"><?=htmlspecialchars($g['title'])?></div><section class="game-area"><iframe class="game-frame" src="<?=htmlspecialchars($json['entry']['url']??'about:blank')?>"></iframe></section><aside class="game-leaderboard"><div class="leaderboard-title">排行榜</div><div id="lb"></div></aside></div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script><script>
const pullUrl = <?=json_encode($json['score']['pullUrl']??'')?>;
$.getJSON(pullUrl).done(function(rows){ if(!rows||rows.length===0){$('#lb').html('目前尚無分數紀錄');return;} rows.forEach((r,i)=>$('#lb').append(`<div class='leaderboard-item'><span class='player-rank'>${i+1}</span> ${r[0]} - ${r[1]}</div>`)); }).fail(()=>$('#lb').html('目前尚無分數紀錄'));
</script>
