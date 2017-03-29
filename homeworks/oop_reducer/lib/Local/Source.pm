package Local::Source;
use strict;
use warnings;

=encoding utf8

=head1 NAME

Source
------

Класс, объекты которого отвечают за подачу данных в `Reducer`. Отвечает за получение данных (через интерфейс типа "итератор"), но не за их парсинг.

Методы:
* `next` — возвращает очередную строку или `undef`, если лог исчерпан.

Минимум надо реализовать:
* `Local::Source::Array` — отдает поэлементно массив, который передается в конструктор в параметре `array`.
* `Local::Source::Text` — отдает построчно текст, который передается в конструктор в параметре `text`. Разделитель — `\n`, но можно изменить параметром конструктора `delimiter`.

Также можно реализовать:
* `Local::Source::FileHandler` — отдает построчно содержимое файла, дескриптор которого передается в конструктор в параметре `fh`. Реализация должна позволять обрабатывать большие файлы (десятки гигабайт).


=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

sub new { };

sub next { };

1;
