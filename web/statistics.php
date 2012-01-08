<?php
    require_once('core/include.php');
    
    $get = new DataObject($_GET);

    $unsolvedTasks = $incompleteTasks = $completeTasks = 0;

    $tasks = Database::query($conn, 'SELECT count(*) as unsolved
        FROM tasks AS A
        LEFT JOIN solutions AS B ON A.id = B.task_id
        WHERE B.task_id IS NULL
    ');

    if (count($tasks) > 0)
        $unsolvedTasks = $tasks[0]['unsolved'];

    // ----------------------------------------------------------------

    $tasks = Database::query($conn, 'SELECT COUNT(DISTINCT T.id) as incomplete
        FROM tasks AS T
        WHERE NOT EXISTS (
        SELECT * FROM results WHERE task_id = T.id AND status = 48)
    ');

    if (count($tasks) > 0)
        $incompleteTasks = $tasks[0]['incomplete'];

    // ----------------------------------------------------------------

    $tasks = Database::query($conn, 'SELECT COUNT(DISTINCT T.id) as solved
        FROM tasks AS T
        WHERE EXISTS (
        SELECT * FROM results WHERE task_id = T.id AND status = 48)
    ');

    if (count($tasks) > 0)
        $solvedTasks = $tasks[0]['solved'];

    // ----------------------------------------------------------------

    Renderer::render('view/template.phtml', array(
        'header' => Renderer::partial('view/statistics_header.phtml', array(
            'solvedTasks' => $solvedTasks,
            'unsolvedTasks' => $unsolvedTasks,
            'incompleteTasks' => $incompleteTasks,
            // 'untestedTasks' => $untestedTasks,
        )),
        
        'topMenu' => Renderer::partial('view/statistics_top_menu.phtml', array(
            'pageTitle' => "Statistics",
        )),

        'content' => Renderer::partial('view/statistics.phtml'),
    ));

    /*$tasks = Database::query($conn, 'select * from 
        tasks as T
        join results as A on A.task_id = T.id
        right join tests as B on A.test_id = B.id 
        join solutions as C on C.id = A.solution_id 
        where not exists (select status from results where status <> 48 and solution_id = A.solution_id) group by solution_id'
    );

    $solvedTasks = 0;
    $unsolvedTasks = 0;
    $incompleteTasks = 0;
    $untestedTasks = 0;

    $tasks = Database::query($conn, 'SELECT count( * ) as solved
        FROM results AS A
            JOIN solutions AS B ON A.solution_id = B.id
            JOIN users AS C ON B.user_id = C.id
        WHERE NOT EXISTS (
            SELECT *
            FROM results AS D
            WHERE D.status <> 48
            AND D.solution_id = B.id
        ) AND
        EXISTS (
            SELECT *
            FROM results AS D
            WHERE D.status = 48
            AND D.solution_id = B.id
        );
    ');

    if (count($tasks) > 0)
        $solvedTasks = $tasks[0]['solved'];

    $tasks = Database::query($conn, 'SELECT count( * ) as unsolved
        FROM results AS A
            JOIN solutions AS B ON A.solution_id = B.id
            JOIN users AS C ON B.user_id = C.id
        WHERE NOT EXISTS (
            SELECT *
            FROM results AS D
            WHERE D.solution_id = B.id
        );
    ');

    if (count($tasks) > 0)
        $unsolvedTasks = $tasks[0]['unsolved'];

    $tasks = Database::query($conn, 'SELECT count( * ) as incomplete
        FROM results AS A
            JOIN solutions AS B ON A.solution_id = B.id
            JOIN users AS C ON B.user_id = C.id
        WHERE EXISTS (
            SELECT *
            FROM results AS D
            WHERE D.status <> 48
            AND D.solution_id = B.id
        ) AND
        EXISTS (
            SELECT *
            FROM results AS D
            WHERE D.status = 48
            AND D.solution_id = B.id
        );
    ');

    if (count($tasks) > 0)
        $incompleteTasks = $tasks[0]['incomplete'];

    $tasks = Database::query($conn, 'SELECT count( * ) as untested
        FROM solutions AS A
            LEFT JOIN results AS B ON A.id = B.solution_id
            JOIN tasks AS C ON C.id = A.task_id
        WHERE B.solution_id IS NULL
    ');

    if (count($tasks) > 0)
        $untestedTasks = $tasks[0]['untested'];

    Renderer::render('view/template.phtml', array(
        'header' => Renderer::partial('view/statistics_header.phtml', array(
            'solvedTasks' => $solvedTasks,
            'unsolvedTasks' => $unsolvedTasks,
            'incompleteTasks' => $incompleteTasks,
            'untestedTasks' => $untestedTasks,
        )),
        
        'topMenu' => Renderer::partial('view/statistics_top_menu.phtml', array(
            'pageTitle' => "Statistics",
        )),

        'content' => Renderer::partial('view/statistics.phtml'),
    ));*/