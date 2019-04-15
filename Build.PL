use Module::Build;
use Pod::Select;

my $class = Module::Build->subclass(
	class => 'My::Builder',
);

my $builder = $class->new(
	module_name => 'App::AudioTuber',
	dist_author => 'Jonathan Gazeley <me@jonathangazeley.com>',
	license  => 'perl',
	configure_requires => {
		'Module::Build' => 0,
	},
	build_requires => {
	},
	requires => {
	},
	test_requires => {
	},
);
$builder->create_build_script();
