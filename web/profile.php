<?php
    require_once('core/include.php');

    if (!isset($_SESSION['user']))
    {
        Renderer::render('view/template.phtml', array(
            'topMenu' => Renderer::partial('view/index_top_menu.phtml'),
            'content' => Renderer::partial('view/login.phtml')
        ));
    } else
    if (isset($_GET['id']))
    {
        $users = Database::query($conn, 'select * from users where id = :id ;', array(
            ':id' => $_GET['id'],
        ));

        /*$solvedTasks = Database::query($conn, 'select * from tasks where id = :id ;', array(
            ':id' => $_GET['id'],
        ));*/

        $solvedTasks = array();

        Renderer::render('view/template.phtml', array(
            'topMenu' => Renderer::partial('view/index_top_menu.phtml'),
            'content' => Renderer::partial('view/profile.phtml', array(
                'user' => $users[0],
                'solvedTasks' => $solvedTasks,
            ))
        ));
    } else
    {
        $solvedTasks = array();

        Renderer::render('view/template.phtml', array(
            'topMenu' => Renderer::partial('view/index_top_menu.phtml'),
            'content' => Renderer::partial('view/profile.phtml', array(
                'user' => $_SESSION['user'],
                'solvedTasks' => $solvedTasks,
            ))
        ));
    }