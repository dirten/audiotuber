package App::AudioTuber;

use Image::Magick;
use Exporter qw(import);

our @EXPORT_OK = qw(generateImage coverArt);

# Generate background image
sub generateImage {
	my $href = shift;
	my $image = $href->{image};
	my $title = $href->{title};
	my $artist = $href->{artist};
	my $composer = $href->{composer};

	my $filename = 'audiotuber.png';

	# Generate image caption
	my $text = '';
	$text .= "$title\n" if $title;
	$text .= "$artist\n" if $artist;
	$text .= "$composer\n" if $composer;

	# Create a new ImageMagick object
	my $object = Image::Magick->new;

	# If a background image was specified, use it
	if ($image && -e $image) {
		# Open image for reading
		$object->Read($image);
		# Scale it to 1280x720
		$object->Resize(geometry=>'1280x720');
		$object->Extent(gravity=>'Center', geometry=>'1280x720', background=>'black');
	} else {
		# Otherwise make a blank image
		$object->Set(size=>'1280x720');
		$object->ReadImage('canvas:white');
	}

	# Regardless of image origin, add the text
	$object->Annotate(pointsize=>40, stroke=>'black', fill=>'white', text=>$text, gravity=>'South');

	# Finally write out the temp image file
	$object->Write(filename=>$filename, compression=>'None');

	# Clean up ImageMagick
	undef $object;

	return $filename;
}

sub coverArt {
	my $href = shift;
	my $ffmpeg = $href->{ffmpeg};
	my $mp3 = $href->{mp3};

	my $hasart = `$ffmpeg -hide_banner -i "$mp3" 2>&1 | grep Stream | grep Video | wc -l`;
	chomp $hasart;
	if ($hasart >= 1) {
	        `$ffmpeg -hide_banner -loglevel panic -y -i "$mp3" -c:v png cover.png`;
		return 'cover.png';
	} else {
		return;
	}
}

# This ensures the lib loads smoothly
1;
