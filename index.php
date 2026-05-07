<?php require_once __DIR__.'/includes/common.php';
$articles = db()->query("SELECT a.*,u.username FROM articles a JOIN users u ON u.id=a.user_id ORDER BY a.created_at DESC LIMIT 10")->fetchAll();
$notifications = db()->query("SELECT * FROM notifications ORDER BY created_at DESC LIMIT 5")->fetchAll();
$uid = current_user_id();
?><!doctype html><html lang="zh-Hant"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>FunTech</title><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
<body><div id="home" class="container py-3">
<header class="site-header d-flex justify-content-between align-items-center mb-4"><div class="brand"><a class="brand-link fw-bold" href="index.php">FunTech</a></div>
<nav class="main-nav"><a class="home-link me-2" href="index.php">首頁</a><a class="games-link me-2" href="games.php">遊戲</a><a class="friends-link" href="friends.php">好友</a></nav>
<div class="user-area">
<?php if(!$uid): ?><a class="login-link me-2" href="login.php">登入</a><a class="register-link" href="register.php">註冊</a><?php else: ?><span class="user-badge me-2">已登入</span><a class="profile-link me-2" href="profile.php">個人頁面</a><a class="logout-link" href="logout.php">登出</a><?php endif; ?>
</div></header>
<div class="row"><section class="articles col-md-8"><?php foreach($articles as $a): ?><article class="article-item card mb-3"><div class="card-body"><h3 class="article-title h5"><?=htmlspecialchars($a['title'])?></h3><time class="article-date text-muted small"><?=$a['created_at']?></time><p class="article-excerpt mt-2"><?=htmlspecialchars(mb_substr($a['content'],0,50))?>...</p><a class="article-readmore" href="article.php?id=<?=$a['id']?>">閱讀更多</a></div></article><?php endforeach; ?></section>
<aside class="notifications col-md-4"><?php foreach($notifications as $n): ?><div class="notification-item border p-2 mb-2"><div class="notification-title"><?=htmlspecialchars($n['title'])?></div><time class="notification-date small text-muted"><?=$n['created_at']?></time></div><?php endforeach; ?></aside></div>
</div></body></html>
