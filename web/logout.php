<?php
    require_once('core/include.php');

    unset($_SESSION['user']);

    header('Location: ' . $_SERVER['HTTP_REFERER']);