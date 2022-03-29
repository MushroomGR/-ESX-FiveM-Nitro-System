CREATE TABLE IF NOT EXISTS `nitrocars` (
  `plate` varchar(50) NOT NULL,
  `nitro` tinyint(1) NOT NULL DEFAULT 0,
  `nitrolevel` int(100) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('nitro', 'Nitro Kit', 1, 0, 1);
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES ('nitrotools', 'Nitro Tools', 1, 0, 1);
