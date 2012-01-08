<?php
    require_once('core/include.php');

    $post = new DataObject($_POST);

    if (!$post->email || !$post->password)
    {
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        header('Error: not enough data for register action');

        return;
    }

    $email = $post->email;
    $encodedPassword = encodePassword($post->password);

    $users = Database::query($conn, 'select * from users where email = :email ;', array(':email' => $email) );

    if (count($users) > 0)
    {
        header('Location: ' . $_SERVER['HTTP_REFERER']);
        header('Error: this e-mail is already taken');

        return;
    }

    Database::query($conn, 'insert into users (email, password) values ( :email , :password ) ;', array(
        ':email' => $email,
        ':password' => $encodedPassword,
    ));

    require('login.php');