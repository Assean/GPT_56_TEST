<?php require_once __DIR__.'/includes/common.php'; require_login(); $uid=(int)($_GET['id']??current_user_id()); $st=db()->prepare('SELECT * FROM users WHERE id=?');$st->execute([$uid]);$u=$st->fetch(); $as=db()->prepare('SELECT * FROM articles WHERE user_id=? ORDER BY created_at DESC');$as->execute([$uid]);$articles=$as->fetchAll(); ?>
<div id="profile-page"><section class="profile-header"><img class="profile-avatar" src="<?=htmlspecialchars($u['avatar'])?>" width="80"><div class="profile-username"><?=htmlspecialchars($u['username'])?></div><div class="profile-bio" tabindex="0"><?=htmlspecialchars($u['bio']??'')?></div><textarea class="profile-bio-input d-none"></textarea><a class="new-post-link" href="#">發表文章</a></section>
<form class="article-create-form d-none"><input class="article-title-input"><textarea class="article-content-input"></textarea><button class="article-submit-button" type="submit">送出</button></form>
<section class="profile-articles"><?php if(!$articles): ?><div class="empty-article-message">目前沒有文章</div><?php endif; foreach($articles as $a): ?><article class="article-item"><a href="article.php?id=<?=$a['id']?>"><?=htmlspecialchars($a['title'])?></a></article><?php endforeach; ?></section>
<div class="profile-friend-actions"></div></div>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script><script>
$('.profile-bio').on('click',function(){const t=$('.profile-bio-input');t.val($(this).text()).removeClass('d-none').focus();});
$('.profile-bio-input').on('keydown',function(e){if(e.key==='Enter'){e.preventDefault();$.post('api/profile.php',{action:'update_bio',bio:$(this).val()}).done(r=>{if(r.success){$('.profile-bio').text($(this).val());$(this).addClass('d-none')}else alert('簡介更新失敗')}).fail(()=>alert('簡介更新失敗'));}});
$('.new-post-link').on('click',function(e){e.preventDefault();$('.article-create-form').toggleClass('d-none');});
$('.article-create-form').on('submit',function(e){e.preventDefault();$.post('api/articles.php',{title:$('.article-title-input').val(),content:$('.article-content-input').val()}).done(r=>{if(r.success){alert('發表成功');location.href='article.php?id='+r.data.id}else alert(r.message)});});
</script>
