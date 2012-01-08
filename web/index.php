<?php
	require_once('core/include.php');
	
	Renderer::render('view/template.phtml', array(
        'topMenu' => Renderer::partial('view/index_top_menu.phtml'),
		'content' => Renderer::partial('view/home.phtml')
	));