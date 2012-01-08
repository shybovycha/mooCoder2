-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- Хост: localhost
-- Время создания: Янв 02 2012 г., 23:01
-- Версия сервера: 5.5.16
-- Версия PHP: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- База данных: `moocoder`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `recalc_user_points`(IN UID INT)
BEGIN
    update users set points = (
        select sum(Y.maxs) from 
            (select max(X.points) as maxs from
                (select A.solution_id, A.task_id, sum(if(A.status = 48, B.points_per_test, 0)) as points
                    from results as A
                    join solutions as B on A.solution_id = B.id
                    where B.user_id = UID
                    group by A.solution_id) as X
                group by task_id) as Y
    ) where id = UID;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `compilers`
--

CREATE TABLE IF NOT EXISTS `compilers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `server` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Дамп данных таблицы `compilers`
--

INSERT INTO `compilers` (`id`, `name`, `title`, `server`) VALUES
(1, 'msvc2008', 'Microsoft Visual Studio 2008', '127.0.0.1:3708'),
(2, 'msvc2010', 'Microsoft Visual Studio 2010', '127.0.0.1:3708'),
(3, 'gcc', 'GNU C Compiler', '127.0.0.1:3708');

-- --------------------------------------------------------

--
-- Структура таблицы `results`
--

CREATE TABLE IF NOT EXISTS `results` (
  `test_id` int(11) NOT NULL DEFAULT '0',
  `task_id` int(11) NOT NULL DEFAULT '0',
  `solution_id` int(11) NOT NULL DEFAULT '0',
  `status` int(4) DEFAULT NULL,
  PRIMARY KEY (`test_id`,`task_id`,`solution_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Дамп данных таблицы `results`
--

INSERT INTO `results` (`test_id`, `task_id`, `solution_id`, `status`) VALUES
(1, 1, 1, 32),
(1, 1, 2, 32),
(1, 1, 3, 48),
(1, 1, 4, 48),
(1, 1, 14, 34),
(1, 1, 15, 32),
(1, 1, 16, 48),
(1, 1, 41, 48),
(2, 2, 17, 38),
(2, 2, 19, 38),
(2, 2, 20, 38),
(2, 2, 21, 38),
(2, 2, 22, 38),
(2, 2, 23, 48),
(2, 2, 44, 32),
(2, 2, 46, 32),
(3, 2, 17, 38),
(3, 2, 19, 38),
(3, 2, 20, 38),
(3, 2, 21, 38),
(3, 2, 22, 38),
(3, 2, 23, 48),
(3, 2, 44, 32),
(3, 2, 46, 32),
(4, 2, 17, 38),
(4, 2, 19, 38),
(4, 2, 20, 38),
(4, 2, 21, 38),
(4, 2, 22, 38),
(4, 2, 23, 48),
(4, 2, 44, 32),
(4, 2, 46, 32),
(5, 2, 17, 38),
(5, 2, 19, 38),
(5, 2, 20, 38),
(5, 2, 21, 38),
(5, 2, 22, 38),
(5, 2, 23, 48),
(5, 2, 44, 32),
(5, 2, 46, 32),
(6, 2, 17, 38),
(6, 2, 19, 38),
(6, 2, 20, 38),
(6, 2, 21, 38),
(6, 2, 22, 38),
(6, 2, 23, 32),
(6, 2, 44, 32),
(6, 2, 46, 32),
(7, 3, 25, 48),
(7, 3, 26, 48),
(7, 3, 27, 1),
(7, 3, 28, 48),
(7, 3, 29, 48),
(7, 3, 30, 48),
(7, 3, 31, 48),
(7, 3, 32, 48),
(7, 3, 35, 48),
(7, 3, 38, 48),
(7, 3, 39, 32),
(7, 3, 40, 48),
(7, 3, 42, 48),
(8, 3, 25, 48),
(8, 3, 26, 48),
(8, 3, 27, 1),
(8, 3, 28, 48),
(8, 3, 29, 48),
(8, 3, 30, 48),
(8, 3, 31, 48),
(8, 3, 32, 48),
(8, 3, 35, 48),
(8, 3, 38, 48),
(8, 3, 39, 32),
(8, 3, 40, 32),
(8, 3, 42, 48),
(9, 3, 25, 48),
(9, 3, 26, 48),
(9, 3, 27, 1),
(9, 3, 28, 48),
(9, 3, 29, 48),
(9, 3, 30, 48),
(9, 3, 31, 48),
(9, 3, 32, 48),
(9, 3, 35, 48),
(9, 3, 38, 48),
(9, 3, 39, 32),
(9, 3, 40, 48),
(9, 3, 42, 48),
(10, 3, 25, 48),
(10, 3, 26, 48),
(10, 3, 27, 1),
(10, 3, 28, 48),
(10, 3, 29, 48),
(10, 3, 30, 48),
(10, 3, 31, 48),
(10, 3, 32, 48),
(10, 3, 35, 48),
(10, 3, 38, 48),
(10, 3, 39, 32),
(10, 3, 40, 32),
(10, 3, 42, 48),
(11, 3, 25, 32),
(11, 3, 26, 32),
(11, 3, 27, 1),
(11, 3, 28, 32),
(11, 3, 29, 32),
(11, 3, 30, 32),
(11, 3, 31, 48),
(11, 3, 32, 48),
(11, 3, 35, 48),
(11, 3, 38, 48),
(11, 3, 39, 32),
(11, 3, 40, 48),
(11, 3, 42, 48),
(12, 3, 25, 32),
(12, 3, 26, 32),
(12, 3, 27, 1),
(12, 3, 28, 32),
(12, 3, 29, 32),
(12, 3, 30, 32),
(12, 3, 31, 32),
(12, 3, 32, 48),
(12, 3, 35, 48),
(12, 3, 38, 48),
(12, 3, 39, 32),
(12, 3, 40, 32),
(12, 3, 42, 48),
(13, 3, 25, 48),
(13, 3, 26, 48),
(13, 3, 27, 1),
(13, 3, 28, 48),
(13, 3, 29, 48),
(13, 3, 30, 48),
(13, 3, 31, 48),
(13, 3, 32, 48),
(13, 3, 35, 48),
(13, 3, 38, 48),
(13, 3, 39, 32),
(13, 3, 40, 48),
(13, 3, 42, 48);

--
-- Триггеры `results`
--
DROP TRIGGER IF EXISTS `update_user_points`;
DELIMITER //
CREATE TRIGGER `update_user_points` AFTER INSERT ON `results`
 FOR EACH ROW BEGIN
    DECLARE uid INT;
    SELECT A.user_id INTO uid FROM SOLUTIONS AS A WHERE A.id = NEW.solution_id;
    CALL recalc_user_points(uid);
END
//
DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `solutions`
--

CREATE TABLE IF NOT EXISTS `solutions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `task_id` int(11) NOT NULL DEFAULT '0',
  `compiler` varchar(100) NOT NULL,
  `code` text,
  `sent` datetime NOT NULL,
  PRIMARY KEY (`id`,`user_id`,`task_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=50 ;

--
-- Дамп данных таблицы `solutions`
--

INSERT INTO `solutions` (`id`, `user_id`, `task_id`, `compiler`, `code`, `sent`) VALUES
(1, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  std::cout << "Hello, World!\\n";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(2, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  std::cout << "Hello, World!";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(3, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  std::cout << "Hello, World!";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(4, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  std::cout << "Hello, World!\\n";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(5, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  cout << "Hello, World!\\n";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(6, 1, 1, 'msvc2008', '#include <iostream>\r\n\r\nint main()\r\n{\r\n  cout << "Hello, World!\\n";\r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(7, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!\\n");\r\n  \r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(8, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!\\n");\r\n  \r\n  return 0;\r\n}', '0000-00-00 00:00:00'),
(9, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-22 20:53:28'),
(10, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 1;\r\n}', '2011-12-23 17:32:04'),
(11, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 1;\r\n}', '2011-12-23 17:33:04'),
(12, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 1;\r\n}', '2011-12-23 17:35:47'),
(13, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 1;\r\n}', '2011-12-23 17:37:10'),
(14, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 1;\r\n}', '2011-12-23 17:37:55'),
(15, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("hello");\r\n  \r\n  return 0;\r\n}', '2011-12-23 17:38:15'),
(16, 0, 1, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!");\r\n  \r\n  return 0;\r\n}', '2011-12-23 17:38:29'),
(17, 0, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N;\r\n  int *a = new int[10], l = 0;\r\n  \r\n  scanf("%ld", &N);\r\n  \r\n  while (N > 0)\r\n  {\r\n    a[l++] = N % 10;\r\n    N /= 10;\r\n  }\r\n  \r\n  for (int i = l - 1; i > -1; i--)\r\n    printf("%d ", a[i]);\r\n  \r\n  return 0;\r\n}', '2011-12-23 17:54:26'),
(18, 0, 2, 'msvc2008', '#include int main() \r\n{ long N; int *a = new int[10], l = 0; scanf("%ld", &N); while (N > 0) { a[l++] = N % 10; N /= 10; } for (int i = l - 1; i > -1; i--) printf("%d ", a[i]); return 0; }', '2011-12-23 18:00:03'),
(19, 0, 2, 'msvc2008', '#include <stdio.h> \r\nint main() \r\n{ long N; int *a = new int[10], l = 0; scanf("%ld", &N); while (N > 0) { a[l++] = N % 10; N /= 10; } for (int i = l - 1; i > -1; i--) printf("%d ", a[i]); return 0; }', '2011-12-23 18:03:16'),
(20, 0, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N;\r\n  int *a = new int[10], l = 0;\r\n  \r\n  scanf("%ld", &N);\r\n  \r\n  while (N > 0)\r\n  {\r\n    a[l++] = N % 10;\r\n    N /= 10;\r\n  }\r\n  \r\n  for (int i = l - 1; i > -1; i--)\r\n    printf("%d ", a[i]);\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:07:16'),
(21, 0, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N;\r\n  int *a = new int[10], l = 0;\r\n  \r\n  scanf("%ld", &N);\r\n  \r\n  while (N > 0)\r\n  {\r\n    a[l++] = N % 10;\r\n    N /= 10;\r\n  }\r\n  \r\n  for (int i = l - 1; i > -1; i--)\r\n    printf("%d ", a[i]);\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:09:08'),
(22, 0, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N;\r\n  int *a = new int[10], l = 0;\r\n  \r\n  scanf("%ld", &N);\r\n  \r\n  while (N > 0)\r\n  {\r\n    a[l++] = N % 10;\r\n    N /= 10;\r\n  }\r\n  \r\n  for (int i = l - 1; i > -1; i--)\r\n    printf("%d ", a[i]);\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:10:02'),
(23, 0, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N;\r\n  int *a = new int[10], l = 0;\r\n  \r\n  scanf("%ld", &N);\r\n  \r\n  while (N > 0)\r\n  {\r\n    a[l++] = N % 10;\r\n    N /= 10;\r\n  }\r\n  \r\n  for (int i = l - 1; i > -1; i--)\r\n    printf("%d ", a[i]);\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:10:51'),
(24, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return \r\n}', '2011-12-23 18:12:54'),
(25, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:13:19'),
(26, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:15:34'),
(27, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return \r\n}', '2011-12-23 18:15:45'),
(28, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:31:57'),
(29, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if (N % X)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 18:34:50'),
(30, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if ((N % X) != 0)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 19:19:16'),
(31, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if ((N % X) != 0)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 19:20:44'),
(32, 0, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  scanf("%ld%ld", &N, &X);\r\n  \r\n  if ((N % X) != 0)\r\n    printf("False\\n"); else\r\n      printf("True\\n");\r\n  \r\n  return 0;\r\n}', '2011-12-23 19:21:29'),
(33, 0, 3, 'msvc2008', '#include <iostream>\r\n\r\nusing namespace std;\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  cin >> N >> X;\r\n  \r\n  if ((N % X) == 0)\r\n    cout << "True\\n"; else\r\n      cout << "False\\n";\r\n  \r\n  return 0;\r\n}', '2011-12-24 15:36:15'),
(34, 0, 3, 'msvc2008', '#include <iostream>\r\n\r\nusing namespace std;\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  cin >> N >> X;\r\n  \r\n  if ((N % X) == 0)\r\n    cout << "True\\n"; else\r\n      cout << "False\\n";\r\n  \r\n  return 0;\r\n}', '2011-12-24 15:37:12'),
(35, 0, 3, 'msvc2008', '#include <iostream>\r\n\r\nusing namespace std;\r\n\r\nint main()\r\n{\r\n  long N, X;\r\n  \r\n  cin >> N >> X;\r\n  \r\n  if ((N % X) == 0)\r\n    cout << "True\\n"; else\r\n      cout << "False\\n";\r\n  \r\n  return 0;\r\n}', '2011-12-24 15:37:40'),
(38, 6, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  int N, X;\r\n  \r\n  scanf("%d%d", &N, &X);\r\n  \r\n  if ((N % X) == 0)\r\n  printf("True"); else\r\n    printf("False");\r\n  \r\n  return 0;\r\n}', '2011-12-26 22:59:15'),
(39, 6, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  int N, X;\r\n  \r\n  scanf("%d%d", &N, &X);\r\n  \r\n  if ((N % X) != 0)\r\n  printf("True"); else\r\n    printf("False");\r\n  \r\n  return 0;\r\n}', '2011-12-26 22:59:30'),
(40, 6, 3, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("False");\r\n  return 0;\r\n}', '2011-12-27 00:17:30'),
(41, 0, 1, 'gcc', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!");\r\n  \r\n  return 0;\r\n}', '2011-12-29 10:46:46'),
(42, 0, 3, 'gcc', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  int N, X;\r\n  \r\n  scanf("%d%d", &N, &X);\r\n  \r\n  if ((N % X) == 0)\r\n    printf("True"); else\r\n      printf("False");\r\n  \r\n  return 0;\r\n}', '2011-12-29 11:30:18'),
(44, 6, 2, 'gcc', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  printf("Hello, World!");\r\n  return 0;\r\n}', '2011-12-29 11:32:06'),
(45, 6, 2, 'msvc2008', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  int N;\r\n  scanf("%d", &N);\r\n  printf("Hello, World!");\r\n  return 0;\r\n}', '2011-12-29 11:32:22'),
(46, 6, 2, 'gcc', '#include <stdio.h>\r\n\r\nint main()\r\n{\r\n  int N;\r\n  scanf("%d", &N);\r\n  printf("Hello, World!");\r\n  return 0;\r\n}', '2011-12-29 11:32:36');

-- --------------------------------------------------------

--
-- Структура таблицы `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `points_per_test` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Дамп данных таблицы `tasks`
--

INSERT INTO `tasks` (`id`, `title`, `description`, `points_per_test`) VALUES
(1, 'Hello, world!', 'Just print the "<em>Hello, World!</em>" phrase keeping case.', 1),
(2, 'Numeric split? #1', 'Split a number <em>N</em> given to a set of numbers.<br /><strong>Output requirements:</strong> a set of a numbers, separated by a space.<br /><strong>Input specifications:</strong> 0 <= N <= 100500', 2),
(3, 'Division by X', 'Find out if the number <em>N</em> given is fully dividable by a number <em>X</em>.<br /><strong>Output requirements:</strong> "True" if so and "False" if not. No quotes are needed.<br /><strong>Input specifications:</strong> two numbers are given: N and then X. 0 <= N <= 100500; X <= N', 1),
(4, 'Impossible task', 'You just can not solve this task =) Accept it!', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `tests`
--

CREATE TABLE IF NOT EXISTS `tests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) NOT NULL DEFAULT '0',
  `input` text,
  `output` text,
  `timeout` int(11) NOT NULL DEFAULT '1000',
  PRIMARY KEY (`id`,`task_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=23 ;

--
-- Дамп данных таблицы `tests`
--

INSERT INTO `tests` (`id`, `task_id`, `input`, `output`, `timeout`) VALUES
(1, 1, NULL, 'Hello, World!\r\n', 1000),
(2, 2, '12345', '1 2 3 4 5', 1000),
(3, 2, '32764', '3 2 7 6 4', 1000),
(4, 2, '65537', '6 5 5 3 7', 1000),
(5, 2, '100500', '1 0 0 5 0 0', 1000),
(6, 2, '0', '0', 1000),
(7, 3, '7 3', 'False', 1000),
(8, 3, '8 2', 'True', 1000),
(9, 3, '17 4', 'False', 1000),
(10, 3, '18 9', 'True', 1000),
(11, 3, '32761 7', 'False', 1000),
(12, 3, '100500 3', 'True', 1000),
(13, 3, '100500 9', 'False', 1000),
(14, 0, 'moo', 'foo', 1000),
(15, 0, 'foo', 'foo', 1000),
(16, 0, 'moo', 'foo', 1000),
(17, 6, 'moo', 'foo', 1000),
(18, 6, 'foo', 'foo', 1000),
(19, 3, '13 1', 'True', 1000),
(20, 8, 'moo', 'foo', 1000);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `points` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `email`, `password`, `points`) VALUES
(1, 'some@mail1.com', 'e99a18c428cb38d5f260853678922e03', 1),
(2, 'some@mail2.com', 'e99a18c428cb38d5f260853678922e03', 0),
(3, 'some@mail3.com', 'e99a18c428cb38d5f260853678922e03', 0),
(4, 'some@mail4.com', 'e99a18c428cb38d5f260853678922e03', 0),
(5, 'some@mail5.com', 'e99a18c428cb38d5f260853678922e03', 0),
(6, 'moo', 'b4453d1f9f5386a1846e57a3ec95678f', 7);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
