<?php
    require_once('core/include.php');
    
    $get = new DataObject($_GET);

    if (!$get->id)
        header('Location: tasks.php');

    $solutions = Database::query($conn, 'select * from solutions where id = :id ;', array(':id' => $get->id));
    $results = Database::query($conn, 'select * from results where solution_id = :id ;', array(':id' => $get->id));

    $solution = new DataObject($solutions[0]);

    Renderer::render('view/template.phtml', array(
        'header' => Renderer::partial('view/task_header.phtml'),
        'topMenu' => Renderer::partial('view/solution_top_menu.phtml', array(
            'pageTitle' => "Solution #" . $get->id,
        )),
        'content' => Renderer::partial('view/solution_results.phtml', array(
            'solution' => $solution,
            'results' => $results,
        ))
    ));