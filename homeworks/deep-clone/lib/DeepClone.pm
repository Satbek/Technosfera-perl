package DeepClone;

use 5.010;
use strict;
use warnings;
no if ($] >= 5.018), 'warnings' => 'experimental';
#http://stackoverflow.com/questions/24653096/perl-no-warnings-experimental-on-old-perl
=encoding UTF8
=head1 SYNOPSIS
Клонирование сложных структур данных
=head1 clone($orig)
Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.
Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.
Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.
=cut
sub clone_($;$);
sub clone_($;$) {
	my $orig = shift;
	my $array_hash_refs = shift||{};
	my $cloned;
	given (ref $orig) {
		when ('') { $cloned = $orig; }
		when ('ARRAY') {
			$cloned = [];
			if (exists $array_hash_refs->{$orig}) {
				$cloned = $array_hash_refs->{$orig};
			}
			else {
				$array_hash_refs->{$orig} = $cloned;
				push @$cloned, clone_($_,$array_hash_refs) for (@$orig);
			}
		}
		when ('HASH') {
			$cloned = {};
			if (exists $array_hash_refs->{$orig}) {
				$cloned = $array_hash_refs->{$orig};
			}
			else {
				$array_hash_refs->{$orig} = $cloned;
				$cloned->{$_} = clone_($orig->{$_},$array_hash_refs) for (keys %$orig);
			}
		}
		default { die "incorrect input"; }
	}
	return $cloned;
}
sub clone($) {
	return eval { clone_(shift) } or undef;
}

1;
