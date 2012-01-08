<?php
    require_once('core/include.php');

    $get = new DataObject($_GET);
    $post = new DataObject($_POST);
    $session = new DataObject($_SESSION);

    $uid = (isset($_SESSION['user'])) ? intval($session->user->id) : 0;
    $compilerArgs = array();

    if ($get->solution && $get->task)
    {
        $compilers = Database::query($conn, 'select server from compilers as A right join solutions as B on A.name = B.compiler where B.id = :solution ;', array(':solution' => $get->solution));

        if (count($compilers) <= 0)
        {
            header('Location: tasks.php?id=' . $get->task);
            header('Error: could not find right compiler');

            return;
        }

        $compiler = new DataObject($compilers[0]);

        preg_match('/(.+):(\d+)/', $compiler->server, $compilerArgs);

        $f = fsockopen('tcp://' . $compilerArgs[1], intval($compilerArgs[2]));

        if ($f)
        {
            fwrite($f, $get->solution);
            fgets($f);
            fclose($f);
        } else
        {
            header('Location: tasks.php?solution=' . $get->solution . '&id=' . $get->task);
            header('Error: could not connect to: ' . $compilerArgs[1] . '::' . intval($compilerArgs[2]));

            return;
        }

        header('Location: tasks.php?id=' . $get->task . '&solution=' . $get->solution);

        return;
    }

    if (!$get->task || !$post->code || !$post->compiler)
    {
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        header('Error: not enough data to solve task');

        return;
    }

    $sent = date('Y-m-d H:i:s');

    $compilers = Database::query($conn, 'select * from compilers where name = :compiler ;', array(':compiler' => $post->compiler));

    if (count($compilers) <= 0)
    {
        header('Location: tasks.php?id=' . $get->task);
        header('Error: could not find `' . $post->compiler . '` compiler');

        return;
    }

    $compiler = new DataObject($compilers[0]);

    Database::query($conn, 'insert into solutions (user_id, task_id, compiler, code, sent) values ( :uid , :tid , :compiler , :code , :sent);', array(
        ':uid' => $uid,
        ':tid' => intval($get->task), 
        ':compiler' => $compiler->name,
        ':code' => $post->code,
        ':sent' => $sent
    ));

    $ids = Database::query($conn, 'select id from solutions where user_id = :uid and task_id = :tid and compiler = :compiler and code = :code and sent = :sent ;', array(
        ':uid' => $uid,
        ':tid' => intval($get->task), 
        ':compiler' => $compiler->name,
        ':code' => $post->code,
        ':sent' => $sent
    ));

    if (count($ids) <= 0)
    {
        header('Location: tasks.php?id=' . $get->task);
        header('Error: could not find solution');

        return;
    }

    $solutionId = intval($ids[0]['id']);

    preg_match('/(.+):(\d+)/', $compiler->server, $compilerArgs);

    $f = fsockopen('tcp://' . $compilerArgs[1], intval($compilerArgs[2]));

    if ($f)
    {
        fwrite($f, $solutionId);
        fgets($f);
        fclose($f);
    } else
    {
        header('Location: tasks.php?id=' . $get->task);
        header('Error: could not connect to: ' . $compilerArgs[1] . '::' . intval($compilerArgs[2]));

        return;
    }

    header('Location: tasks.php?id=' . $get->task . '&solution=' . $solutionId);