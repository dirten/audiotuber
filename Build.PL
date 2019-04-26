use Module::Build;
use Pod::Select;

my $class = Module::Build->subclass(
	class => 'My::Builder',
	code => q{
		sub ACTION_docs {
			use Pod::Select;
			my $self = shift;
			podselect({ -output => 'README.pod' }, 'bin/audiotuber');
			return $self->SUPER::ACTION_docs;
		}
	}
);

my $builder = $class->new(
	module_name => 'App::AudioTuber',
	dist_author => 'Jonathan Gazeley <me@jonathangazeley.com>',
	license  => 'perl',
	dist_abstract => 'bin/audiotuber',
	#	abstract_from => 'bin/audiotuber',
	configure_requires => {
		'Module::Build' => 0,
		'Pod::Select' => 0,
	},
	build_requires => {
		'Pod::Select' => 0,
	},
	requires => {
		'Getopt::Long' => 0,
		'File::Which' => 0,
		'File::Basename' => 0,
		'MP3::Info' => 0,
		'FFmpeg::Command' => 0,
	},
	test_requires => {
		'Test::More' => '0.47',
		'Test::Perl::Critic' => 0,
		'Test::Compile' => 0,
	},
);
$builder->create_build_script();
