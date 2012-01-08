<?php
    require_once('core/include.php');

    $post = new DataObject($_POST);

    Log::message($post);

    if (!$post->email || !$post->password)
    {
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        header('Error: not enough data for login action');

        return;
    }

    $email = $post->email;
    $encodedPassword = encodePassword($post->password);

    
    $users = Database::query($conn, 'select * from users where email = :email and password = :password ;', array(
        ':email' => $email,
        ':password' => $encodedPassword,
    ));

    if (count($users) <= 0)
    {
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        header('Error: can not log in');

        return;
    }

    $user = new DataObject($users[0]);
    $_SESSION['user'] = $user;

    header('Location: profile.php');