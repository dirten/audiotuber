package App::AudioTuber;

use Image::Magick;
use Exporter qw(import);

our @EXPORT_OK = qw(generateImage);

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
	$text .= "Title: $title\n" if $title;
	$text .= "Artist: $artist\n" if $artist;
	$text .= "Composer: $composer\n" if $composer;

	# Create a new ImageMagick object
	my $object = Image::Magick->new;

	# If a background image was specified, use it
	if ($image && -e $image) {
		# Open image for reading
	} else {
		# Otherwise make a blank image
		$object->Set(size=>'1280x720');
		$object->ReadImage('canvas:white');
	}

	# Regardless of image origin, add the text
	$object->Annotate(pointsize=>40, fill=>'black', text=>$text);

	# Finally write out the temp image file
	$object->Write(filename=>$filename, compression=>'None');

	# Clean up ImageMagick
	undef $object;

	return $filename;
}


# This ensures the lib loads smoothly
1;
