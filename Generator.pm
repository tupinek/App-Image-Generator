package App::Image::Generator;

# Pragmas.
use strict;
use warnings;

# Modules.
use English;
use Error::Pure qw(err);
use File::Basename qw(fileparse);
use Getopt::Std;
use Image::Random;
use Image::Select;
use Readonly;

# Constants.
Readonly::Scalar our $EMPTY_STR => q{};

# Version.
our $VERSION = 0.01;

# Constructor.
sub new {
	my $class = shift;

	# Create object.
	my $self = bless {}, $class;

	# Object.
	return $self;
}

# Run script.
sub run {
	my $self = shift;

	# Process arguments.
	$self->{'_opts'} = {
		'h' => 0,
		'i' => $EMPTY_STR,
		's' => '1920x1080',
		'v' => 0,
	};
	if (! getopts('hi:s:v', $self->{'_opts'}) || @ARGV < 1
		|| $self->{'_opts'}->{'h'}) {

		print STDERR "Usage: $0 [-h] [-i input_dir] [-s size] [-v]".
			"\n\t[--version] output_file\n\n";
		print STDERR "\t-h\t\tPrint help.\n";
		print STDERR "\t-i input_dir\tInput directory with ".
			"images (default value is nothing).\n";
		print STDERR "\t-s size\t\tSize (default value is ".
			"1920x1080).\n";
		print STDERR "\t-v\t\tVerbose mode.\n";
		print STDERR "\t--version\tPrint version.\n";
		exit 1;
	}
	$self->{'_output_file'} = $ARGV[0];

	# Check size.
	if ($self->{'_opts'}->{'s'} !~ m/^(\d+)x(\d+)$/ms) {
		err 'Bad size value.', 'Value', $self->{'_opts'}->{'s'};
	}
	$self->{'_width'} = $1;
	$self->{'_height'} = $2;

	# Run.
	eval {
		my (undef, undef, $suffix) = fileparse($self->{'_output_file'},
			qr{\..*$});
		$suffix =~ s/^\.//g;

		# Images from directory.
		my $ig;
		if ($self->{'_opts'}->{'i'} ne $EMPTY_STR) {
			$ig = Image::Select->new(
				'debug' => ($self->{'_opts'}->{'v'} ? 1 : 0),
				'height' => $self->{'_height'},
				'path_to_images' => $self->{'_opts'}->{'i'},
				'type' => $suffix,
				'width' => $self->{'_width'},
			);

		# Random image.
		} else {
			$ig = Image::Random->new(
				'height' => $self->{'_height'},
				'type' => $suffix,
				'width'=> $self->{'_width'},
			);
		}
		$ig->create($self->{'_output_file'});
	};
	if ($EVAL_ERROR) {
		err 'Cannot create image.';
	}
	return 0;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

App::Image::Generator - Perl class for image-generator application.

=head1 SYNOPSIS

 use App::Image::Generator;
 my $obj = App::Image::Generator->new;
 $obj->run;

=head1 METHODS

=over 8

=item C<new()>

 Constructor.

=item C<run()>

 Run.

=back

=head1 ERRORS

 new():
         Bad size value.
                 Value: %s
         From Class::Utils:
                 Unknown parameter '%s'.

 run():
         Cannot create image.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use App::Image::Generator;

 # Run.
 App::Image::Generator->new->run;

 # Output like:
 # Usage: __SCRIPT__ [-h] [-i input_dir] [-s size] [-v]
 #         [--version] output_file
 # 
 #         -h              Print help.
 #         -i input_dir    Input directory with images (default value is nothing).
 #         -s size         Size (default value is 1920x1080).
 #         -v              Verbose mode.
 #         --version       Print version.

=head1 DEPENDENCIES

L<English>,
L<Error::Pure>,
L<File::Basename>,
L<Getopt::Std>,
L<Image::Random>,
L<Image::Select>,
L<Readonly>.

=head1 SEE ALSO

=over

=item L<App::Video::Generator>

Perl class for video-generator application.

=back

=head1 REPOSITORY

L<https://github.com/tupinek/App-Image-Generator>.

=head1 AUTHOR

Michal Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

 © 2015 Michal Špaček
 BSD 2-Clause License

=head1 VERSION

0.01

=cut