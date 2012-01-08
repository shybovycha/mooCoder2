<?php
    require_once('core/include.php');
    
    $get = new DataObject($_GET);
    $session = new DataObject($_SESSION);

    $taskId = $get->get('id', 1);
    $solutionId = $get->solution;

    $totals = Database::query($conn, "select count(*) as total from tasks;");
    $tasks = Database::query($conn, "select * from tasks where id = :id ;", array(':id' => $taskId));
    $compilers = Database::query($conn, "select * from compilers;");

    $task = new DataObject($tasks[0]);

    $results = array();
    $solution = new DataObject(array());
    $pageTitle = $task->title;

    if (isset($solutionId))
    {
        $solutions = Database::query($conn, 'select * from solutions where id = :id ;', array(':id' => $solutionId));

        $results = Database::query($conn, 'select * from results where solution_id = :id ;', array(':id' => $solutionId));

        $solution = new DataObject($solutions[0]);

        $pageTitle = $task->title . ', Solution #' . $solution->id;
    }

    if ($solution->user_id != $session->user->id)
    {
        $solution->code = '';
    }

    $session = new DataObject($_SESSION);

    $uid = (isset($_SESSION['user'])) ? $session->user->id : null;

    if (isset($uid))
    {
        $attempts = Database::query($conn, 'SELECT *, (SUM(A.status) / (COUNT(C.id) * 48)) as completeness
            FROM results AS A
            JOIN tests AS C ON A.test_id = C.id
            JOIN solutions AS B ON A.solution_id = B.id
            WHERE B.task_id = :tid AND B.user_id = :uid
            GROUP BY B.id
        ', array(
            ':tid' => $taskId,
            ':uid' => $uid
        ));
    } else
    {
        $attempts = array();
    }

    Renderer::render('view/template.phtml', array(
        'header' => Renderer::partial('view/task_header.phtml'),
        
        'topMenu' => Renderer::partial('view/tasks_top_menu.phtml', array(
            'pageTitle' => $pageTitle,
            'page' => $taskId,
            'totalCount' => intval($totals[0]['total']),
        )),

        'content' => Renderer::partial('view/task.phtml', array(
            'results' => $results,
            'solution' => $solution,
            'task' => $task,
            'compilers' => $compilers,
            'attempts' => $attempts,
        ))
    ));